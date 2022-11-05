-- A) Realizar un procedimiento almacenado llamado sp_Agregar_Usuario que permita registrar un usuario en el sistema. 
-- El procedimiento debe recibir como parámetro DNI, Apellido, Nombre, Fecha de nacimiento y los datos del domicilio del usuario.

Create Procedure SP_Agregar_Usuario(
    @DNI varchar(10),
    @Apellido varchar(30),
    @Nombre varchar(30),
    @FechaNac Date,
    @Direcccion varchar(50)
)
as
Begin

    Declare @ExisteUsuario bit
    Set @ExisteUsuario = (Select Count(*) From Usuarios Where @DNI = Usuarios.DNI)

    If @ExisteUsuario = 1
        Begin 
            Print 'El usuario ya esta registrado'
        End
    Else
        Begin
            Insert into Usuarios Values (@DNI, @Apellido, @Nombre, @FechaNac, @Direcccion)
        End

End

-- B) Realizar un procedimiento almacenado llamado sp_Agregar_Tarjeta que dé de alta una tarjeta. El procedimiento solo debe recibir el DNI del usuario.
-- Como el sistema sólo permite una tarjeta activa por usuario, el procedimiento debe:
-- Dar de baja la última tarjeta del usuario (si corresponde).
-- Dar de alta la nueva tarjeta del usuario
-- Traspasar el saldo de la vieja tarjeta a la nueva tarjeta (si corresponde)

Create Procedure SP_Agregar_Tarjeta (
    @DNI varchar(10)
)
as
Begin

    Declare @ExisteTarjeta Bit  
    Declare @Saldo money = 0

    Set @ExisteTarjeta = (Select Count(*) from Tarjetas Where Tarjetas.DNIUsuario = @DNI)
    Set @Saldo = 0

    If  @ExisteTarjeta > 0
    Begin
        Declare @IDUltimaTarjeta bigint

        Set @IDUltimaTarjeta = (Select Top 1 Tarjetas.ID From Tarjetas 
                                Where Tarjetas.DNIUsuario = @DNI 
                                Order By Tarjetas.FechaAlta desc)
        Set @Saldo = (Select Top 1 Tarjetas.Saldo From Tarjetas 
                                Where Tarjetas.DNIUsuario = @DNI 
                                Order By Tarjetas.FechaAlta desc)

        Update Tarjetas Set Estado = 0 Where Tarjetas.ID = @IDUltimaTarjeta And Tarjetas.DNIUsuario = @DNI
    End

    Insert into Tarjetas Values (@DNI, 1, Getdate(), @Saldo, 1)

End 

-- Realizar un procedimiento almacenado llamado sp_Agregar_Viaje que registre un viaje a una tarjeta en particular. 
--El procedimiento debe recibir: Número de tarjeta, importe del viaje, nro de interno y nro de línea.
-- El procedimiento deberá:
-- Descontar el saldo
-- Registrar el viaje
-- Registrar el movimiento de débito

Create Procedure SP_Agregar_Viaje (
    @NumTarjeta bigint,
    @Importe money,
    @NumInterno bigint,
    @NumLineaColectivo int
)
as
Begin

    Declare @DeudaTarjeta money

    Set @DeudaTarjeta = (Select Tarjetas.Saldo from Tarjetas Where Tarjetas.ID = @NumTarjeta)

    Set @DeudaTarjeta = @DeudaTarjeta - @Importe

    If @DeudaTarjeta < -10 
        Begin 
            Print 'La tarjeta no puede superar los 10$ en deuda'
        End 
    Else 
        Begin 
            Update Tarjetas Set Saldo = Saldo - @Importe
            Insert into Viajes Values (Getdate(), @NumInterno, @NumLineaColectivo, @NumTarjeta, @Importe)
            Insert into Movimientos Values (Getdate(), @NumTarjeta, @Importe, 'D')
        End
End

--  Realizar un procedimiento almacenado llamado sp_Agregar_Saldo que registre un movimiento de crédito a una tarjeta en particular. 
-- El procedimiento debe recibir: El número de tarjeta y el importe a recargar. Modificar el saldo de la tarjeta.

Create Procedure SP_Agregar_Saldo (

    @NumTarjeta bigint,
    @Importe money
)
as 
Begin 
    Insert into Movimientos Values (Getdate(), @NumTarjeta, @Importe, 'C')
    Update Tarjetas Set Saldo = Saldo + @Importe
End

-- E) Realizar un procedimiento almacenado llamado sp_Baja_Fisica_Usuario que elimine un usuario del sistema. 
-- La eliminación deberá ser 'en cascada'. Esto quiere decir que para cada usuario primero deberán eliminarse todos los viajes y recargas de sus respectivas tarjetas. 
-- Luego, todas sus tarjetas y por último su registro de usuario.

Create Procedure sp_Baja_Fisica_Usuario (
    @DNI bigint
)
as
Begin

    Declare @ExisteUsuario bit
    Set @ExisteUsuario = (Select Count(*) From Usuarios Where @DNI = Usuarios.DNI)

    If @ExisteUsuario = 0
        Begin
            Print 'El usuario no existe'
        End
    Else
        Begin

            Declare @CantidadTarjetas int
            Set @CantidadTarjetas = (Select Count(*) from Tarjetas Where Tarjetas.DNIUsuario = @DNI)
            
            While(@CantidadTarjetas > 0)
                Begin
                    Declare @IDTarjetaActual int
                    Set @IDTarjetaActual = (Select Top 1 Tarjetas.ID From Tarjetas Where Tarjetas.DNIUsuario = @DNI Order By Tarjetas.FechaAlta desc)

                    Delete From Viajes Where Viajes.NumSUBE = @IDTarjetaActual
                    Delete From Movimientos WHERE Movimientos.NumSUBE = @IDTarjetaActual
                    Delete From Tarjetas Where Tarjetas.ID = @IDTarjetaActual

                    Set @CantidadTarjetas = @CantidadTarjetas - 1

                End

                Delete From Usuarios Where Usuarios.DNI = @DNI
        End
End
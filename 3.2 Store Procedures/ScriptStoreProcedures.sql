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
            Insert Viajes Values (Getdate(), @NumInterno, @NumLineaColectivo, @NumTarjeta, @Importe)
            Insert Movimientos Values (Getdate(), @NumTarjeta, @Importe, 'D')
        End
End


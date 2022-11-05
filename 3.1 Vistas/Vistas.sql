
-- A) Realizar una vista que permita conocer los datos de los usuarios y sus respectivas tarjetas. 
-- La misma debe contener: Apellido y nombre del usuario, número de tarjeta SUBE, estado de la tarjeta y saldo.

Create View VW_TarjetasXUsuario As 
Select U.Apellido, U.Nombre, T.ID, T.Saldo, T.Estado From Usuarios U
Inner Join Tarjetas T on T.DNIUsuario = u.DNI
Go

-- B) Realizar una vista que permita conocer los datos de los usuarios y sus respectivos viajes. 
-- La misma debe contener: Apellido y nombre del usuario, número de tarjeta SUBE, fecha del viaje, importe del viaje, número de interno y nombre de la línea.

Create View VW_ViajesXUsuario As 
Select U.Apellido, U.Nombre, V.NumSUBE, V.FechaHora, V.Importe, V.NumInternoColectivo, LC.NombreEmpresa From Usuarios U
Inner Join Tarjetas T on T.DNIUsuario = U.DNI
Inner Join Viajes V on V.NumSUBE = T.ID
Inner Join LineasColectivos LC on LC.Codigo = V.LineaColectivo
Go

-- C) Realizar una vista que permita conocer los datos estadísticos de cada tarjeta. 
-- La misma debe contener: Apellido y nombre del usuario, número de tarjeta SUBE, cantidad de viajes realizados, total de dinero acreditado (históricamente), 
-- cantidad de recargas, importe de recarga promedio (en pesos), estado de la tarjeta.

Create View VW_EstadisticasTarjetas As 
Select 
    U.Apellido, 
    U.Nombre, 
    T.ID, 
    (Select Count(V.CodigoViaje) 
    From Viajes V
    Inner Join Tarjetas T On V.NumSUBE = T.ID
    Where V.NumSUBE = T.ID
    Group By T.ID) as CantidadViajes, 
    (Select Sum(M.Importe) From Movimientos M 
    Inner Join Tarjetas T On M.NumSUBE = T.ID
    Where M.NumSUBE = T.ID) as TotalAcreditado, 
    (Select Count(M.TipoMovimiento) Where M.TipoMovimiento = 'C' And M.NumSUBE = T.ID) as CantidadRecargas,
    (Select Avg(M.Importe) Where M.NumSUBE = T.ID And M.TipoMovimiento = 'C'),
    T.Estado From Usuarios U
Inner Join Tarjetas T on U.DNI = T.DNIUsuario
Inner Join Viajes V on T.ID = V.NumSUBE
Inner Join Movimientos M on T.ID = M.NumSUBE
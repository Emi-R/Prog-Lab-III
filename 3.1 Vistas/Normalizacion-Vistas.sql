Create Database Actividad_SUBE
Go
 
Use Actividad_SUBE
Go

Create Table Usuarios (

    DNI varchar(10) Primary Key Check (DNI > 0),
    ID bigint,
    Apellido varchar(30) Not Null,
    Nombre Varchar(30)Not Null,
    FechaNacimiento Date Not Null,
    FechaPrimeraTarjeta Date Null,
    SaldoUltimaTarjeta Money Not Null Default(0),
    CantidadViajes Int Not Null Default (0),
    Direccion Varchar(50) Not Null,
    Localidad int Not Null,
    Ciudad int Not Null,
    Provinicia int Not Null,
    Estado Bit Not Null,

)

Create Table Tarjetas (

    DNIUsuario varchar(10) Foreign Key References Usuarios(DNI),
    ID bigint Primary Key,
    FechaAlta Date Not Null,
    Saldo Money,
    Estado bit Not Null
)

Create Table LineasColectivos(

    Codigo int Primary Key,
    NombreEmpresa varchar(50) Not Null,
    Direccion Varchar(50) Not Null,
    Localidad int Not Null,
    Ciudad int Not Null,
    Provinicia int Not Null

)

Create Table Viajes (

    CodigoViaje bigint Primary Key,
    FechaHora Date Not Null,
    NumInternoColectivo bigint Not Null,
    LineaColectivo int Not Null Foreign Key References LineasColectivos(Codigo),
    NumSUBE bigint Not Null Foreign Key References Tarjetas (ID),
    Importe money Not Null,
)

Create Table Movimientos (

    NumeroMovimiento int Primary Key,
    FechaHora DateTime Not Null,
    NumSUBE bigint foreign key References Tarjetas (ID),
    Importe money Not Null,
    TipoMovimiento char(1) Not Null,
)
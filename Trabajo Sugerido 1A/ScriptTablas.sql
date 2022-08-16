CREATE DATABASE TP1A
GO

USE TP1A
GO

CREATE TABLE Marcas(
	IDMarca INT PRIMARY KEY,
	NOMBRE VARCHAR(30) NOT NULL
)
GO

CREATE TABLE TipoArticulos(
	IDTipoArt INT PRIMARY KEY,
	DescripcionTipoArt VARCHAR(30),
)

CREATE TABLE Articulos(
	CodigoArticulo VARCHAR(6) PRIMARY KEY,
	Descrip VARCHAR(30) NULL,
	Marca INT NULL FOREIGN KEY REFERENCES Marcas( IDMarca ),
	TipoArt INT NULL FOREIGN KEY REFERENCES TipoArticulos ( IDTipoArt ),
	PrecioCompra MONEY NOT NULL CHECK ( PrecioCompra > 0 ),
	PrecioVenta MONEY NOT NULL CHECK ( PrecioVenta > 0 ),
	StockActual INT NULL CHECK ( StockActual > 0 ),
	StockMinimo INT NULL CHECK ( StockMinimo > 0 ),
	Estado smallint NOT NULL CHECK ( Estado = 1 OR Estado = 0 ) 
)
GO



CREATE TABLE Clientes (
	Legajo BIGINT PRIMARY KEY,
	DNI BIGINT NOT NULL CHECK ( DNI > 0),
	Apellido VARCHAR(50) NOT NULL,
	Nombres VARCHAR(50) NOT NULL,
	Sexo CHAR(1) NULL CHECK ( Sexo = 'M' OR Sexo = 'F' ),
	FechaNac DATE NULL,


)
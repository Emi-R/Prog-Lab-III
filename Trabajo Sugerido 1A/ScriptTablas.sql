CREATE DATABASE TP1A
GO

USE TP1A
GO

CREATE TABLE Marcas (
	IDMarca INT NOT NULL PRIMARY KEY,
	Marca VARCHAR(30) NOT NULL
)
GO

CREATE TABLE TipoArticulos (
	IDTipoArt INT NOT NULL PRIMARY KEY,
	DescripcionTipoArt VARCHAR(30) NOT NULL,
)
GO

CREATE TABLE Articulos (
	CodigoArticulo VARCHAR(6) NOT NULL PRIMARY KEY,
	Descrip VARCHAR(100) NOT NULL,
	Marca INT NULL FOREIGN KEY REFERENCES Marcas ( IDMarca ),
	TipoArt INT NOT NULL FOREIGN KEY REFERENCES TipoArticulos ( IDTipoArt ),
	PrecioCompra MONEY NOT NULL CHECK ( PrecioCompra > 0 ),
	PrecioVenta MONEY NOT NULL CHECK ( PrecioVenta > 0 ),
	StockActual INT NOT NULL CHECK ( StockActual > 0 ),
	StockMinimo INT NOT NULL CHECK ( StockMinimo > 0 ),
	Estado SMALLINT NOT NULL CHECK ( Estado = 1 OR Estado = 0 ) 
)
GO

CREATE TABLE ProvinciasPorId (
	IDProv INT NOT NULL PRIMARY KEY,
	Nombre VARCHAR(20) NOT NULL UNIQUE,
)
GO

CREATE TABLE LocalidadesPorCod (
	CodigoPostal INT PRIMARY KEY,
	Nombre VARCHAR(70) NOT NULL,
	IDProvincia INT NOT NULL FOREIGN KEY REFERENCES ProvinciasPorId ( IDProv )
)
GO

CREATE TABLE Clientes (
	NumCliente BIGINT PRIMARY KEY,
	DNI BIGINT CHECK ( DNI > 0 ),
	Apellido VARCHAR(50) NOT NULL,
	Nombres VARCHAR(50) NOT NULL,
	Sexo CHAR(1) NULL CHECK ( Sexo = 'M' OR Sexo = 'F' ),
	Fecha_Nac DATE NULL,
	Telefono BIGINT NOT NULL CHECK ( Telefono > 0 ),
	Mail VARCHAR(50) UNIQUE NOT NULL,
	Fecha_Alta DATE NOT NULL,
	Direccion VARCHAR(50) NOT NULL,
	CodPostal INT NOT NULL FOREIGN KEY REFERENCES LocalidadesPorCod ( CodigoPostal ),
)
GO

CREATE TABLE Vendedores (
	Legajo BIGINT PRIMARY KEY IDENTITY(1000, 1),
	Apellido VARCHAR(50) NOT NULL,
	Nombres VARCHAR(50) NOT NULL,
	Sexo CHAR(1) NULL CHECK ( Sexo = 'M' OR Sexo = 'F' ),
	FechaNac DATE NULL,
	FechaAlta DATE NOT NULL,
	Direccion VARCHAR(50) NOT NULL,
	Telefono BIGINT NOT NULL CHECK (Telefono > 0),
	CodPostal INT NOT NULL FOREIGN KEY REFERENCES LocalidadesPorCod ( CodigoPostal ),
	Sueldo MONEY NOT NULL,
)
GO

CREATE TABLE Ventas (
	NumVenta BIGINT PRIMARY KEY IDENTITY (1,1),
	FechaVenta DATETIME NOT NULL,
	Cliente BIGINT NULL FOREIGN KEY REFERENCES Clientes ( NumCliente ),
	Vendedor BIGINT NOT NULL FOREIGN KEY REFERENCES Vendedores ( Legajo ),
	FormaPago CHAR(1) NOT NULL CHECK (FormaPago = 'E' OR FormaPago = 'T' ),
	Importe MONEY NOT NULL CHECK ( Importe > 0 )
)
GO

CREATE TABLE ArticulosPorCompras (
	NumVenta BIGINT FOREIGN KEY REFERENCES Ventas (NumVenta),
	CodArticulo VARCHAR(6) NOT NULL FOREIGN KEY REFERENCES Articulos ( CodigoArticulo ),
	PrecioUnitario MONEY NOT NULL CHECK ( PrecioUnitario > 0 ),
	Cantidad INT NOT NULL CHECK ( Cantidad > 0 ),
	PRIMARY KEY (NumVenta, CodArticulo)
)
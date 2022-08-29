CREATE DATABASE RelacionNaN
GO

USE RelacionNaN
GO

CREATE TABLE Habitaciones (
	NumeroHab SMALLINT PRIMARY KEY IDENTITY (1,1),
	Precio MONEY NOT NULL CHECK ( Precio > 0 ),
	Piso INT NOT NULL CHECK ( Piso >= 0 ), -- 0 para planta baja!!
	CapacidadMax SMALLINT NOT NULL CHECK ( CapacidadMax > 0 AND CapacidadMax < 6 )
)
GO

CREATE TABLE Huespedes (
	Dni BIGINT PRIMARY KEY,
	Apellido VARCHAR(50) NOT NULL,
	Nombre VARCHAR(50) NOT NULL,
	Genero CHAR(1) NULL CHECK ( Genero = 'F' OR Genero = 'M' ),
	Telefono VARCHAR(30) NOT NULL,
	Mail VARCHAR(50) NULL UNIQUE,
)
GO

CREATE TABLE Reservas (
	IDReserva INT PRIMARY KEY IDENTITY (1,1),
	InicioEstadia DATE NOT NULL,
	FinEstadia DATE NOT NULL,
	CantidadPersonas SMALLINT NOT NULL CHECK ( CantidadPersonas > 0 AND CantidadPersonas < 6 ),
	DniHuesped BIGINT NOT NULL FOREIGN KEY REFERENCES Huespedes (Dni),
	NumHabitacion SMALLINT NOT NULL FOREIGN KEY REFERENCES Habitaciones (NumeroHab)
)
GO

ALTER TABLE 
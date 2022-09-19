ALTER TABLE Productos
ADD CONSTRAINT CHK_Precios CHECK(PrecioVentaMayorista < Precio)
GO
ALTER TABLE Pedidos
ADD CONSTRAINT FK_Clientes FOREIGN KEY (IDCliente)
REFERENCES Clientes(ID)
GO
ALTER TABLE Pedidos
ADD CONSTRAINT FK_Productos FOREIGN KEY (IDProducto)
REFERENCES Productos(ID)
GO
ALTER TABLE Productos
ADD CONSTRAINT FK_Categoria FOREIGN KEY (IDCategoria)
REFERENCES Categorias(ID)
go
Create Table Tareas(
    ID smallint not null primary key identity (1, 1),
    Nombre varchar(50) not null
)
go
Create Table Tareas_x_Pedido(
    ID bigint not null primary key identity (1, 1),
    Legajo int not null foreign key references Colaboradores(Legajo),
    IDPedido bigint not null foreign key references Pedidos(ID),
    IDTarea smallint not null foreign key references Tareas(ID),
    Tiempo int null check (Tiempo > 0)
)
go
Create Table Provincias(
    ID int not null primary key identity (1, 1),
    Nombre varchar(40)
)
go
Create Table Localidades(
    ID int not null primary key identity (1, 1),
    IDProvincia int not null foreign key references Provincias(ID),
    Nombre varchar(255) not null
)
go
Create Table Envios(
    IDPedido bigint not null primary key foreign key references Pedidos(ID),
    Direccion varchar(500) not null,
    IDLocalidad int not null foreign key references Localidades(ID),
    FechaEnvio date not null,
    Bonificado bit not null,
    Entregado bit not null
)
go
Create Table Materiales(
    ID smallint not null primary key,
    Nombre varchar(50) not null
)
go
Create Table Materiales_x_Producto(
    IDMaterial smallint not null foreign key references Materiales(ID),
    IDProducto int not null foreign key references Productos(ID),
    Primary Key (IDMaterial, IDProducto)
)
Go
Create Table Pagos(
    ID bigint not null primary key identity (1, 1),
    IDPedido bigint not null foreign key references Pedidos(ID),
    Fecha date not null,
    Importe money not null check (Importe > 0)
)
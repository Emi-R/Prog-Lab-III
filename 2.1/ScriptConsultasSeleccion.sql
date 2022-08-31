Select * From Colaboradores
Go

Select * From Clientes
Go

-- Apellido, nombres y fecha de ingreso de todos los colaboradores

Select 
	Apellidos, 
	Nombres, 
	A�oIngreso as 'Fecha de Ingreso' 
From Colaboradores
Go

--Apellido, nombres y antig�edad de todos los colaboradores

Select 
	Apellidos,
	Nombres,
	Year(GETDATE()) - A�oIngreso as Antig�edad
From Colaboradores
Go

-- Apellido y nombres de aquellos colaboradores que trabajen part-time.

Select Apellidos, Nombres From Colaboradores 
Where ModalidadTrabajo = 'P'
Go

-- Apellido y nombres, antig�edad y modalidad de trabajo de aquellos colaboradores cuyo sueldo sea entre 50000 y 100000.

Select 
	Apellidos,
	Nombres,
	Year(GETDATE()) - A�oIngreso as Antig�edad,
	ModalidadTrabajo
From Colaboradores
Where Sueldo >= 50000 
	And Sueldo <= 100000
Go

-- Apellidos y nombres y edad de los colaboradores con legajos 4, 6, 12 y 25

Select 
	Legajo, 
	Apellidos, 
	Nombres, 
	FechaNacimiento, 
	DATEDIFF(Year, FechaNacimiento, GETDATE()) as Edad 
From Colaboradores
Where Legajo like '%4%'
	Or Legajo like '%6%'
	Or Legajo Like '12'
	Or Legajo like '%25%'
Go

-- Todos los datos de todos los productos ordenados por precio de venta. Del m�s caro al m�s barato

Select * From Productos
Order by Precio desc
Go

-- El nombre del producto m�s costoso.

Select Top 1 Descripcion From Productos
Order by Costo Desc
Go

-- Todos los datos de todos los pedidos que hayan superado el monto de $20000.

Select * From Pedidos
Where Costo >= 20000
Go

-- Apellido y nombres de los clientes que no hayan registrado tel�fono.

Select 
	Apellidos,
	Nombres 
From Clientes
Where Telefono Is Null
Go

-- Apellido y nombres de los clientes que hayan registrado mail pero no tel�fono.

Select * From Clientes
Where Telefono Is Null 
	And Mail Is Not Null
Go

-- Apellidos, nombres y datos de contacto de todos los clientes.

-- Nota: En datos de contacto debe figurar el n�mero de celular, 
-- si no tiene celular el n�mero de tel�fono fijo 
-- si no tiene este �ltimo el mail. En caso de no tener ninguno de los tres debe figurar 'Incontactable'.

Select 
	Apellidos,
	Nombres, 
	IsNull(Celular, IsNull(Telefono, IsNull(Mail, 'Incontactable'))) As Contacto 
From Clientes
Go

--Apellidos, nombres y medio de contacto de todos los clientes. 

-- Si tiene celular debe figurar 'Celular'. 
-- Si no tiene celular pero tiene tel�fono fijo debe figurar 'Tel�fono fijo' de lo contrario debe figurar 'Email'. 
-- Si no posee ninguno de los tres debe figurar NULL.

Select 
	Apellidos,
	Nombres, 
	Case
		When Celular Is Not Null Then 'Celular'
		When Telefono Is Not Null Then 'Telefono fijo'
		When Mail Is Not Null Then 'Email'
		Else Null
	End as 'Medio de contacto'
From Clientes
Go

-- Todos los datos de los clientes que hayan nacido luego del a�o 2000

--Select * From Clientes
--Where 

-- Todos los datos de los clientes cuyo apellido finalice con vocal

Select * From Clientes
Where Apellidos like '%[AEIOU]'
Go

-- Todos los datos de los clientes cuyo nombre comience con 'A' y contenga al menos otra 'A'. Por ejemplo, Ana, Anatasia, Aaron, etc

Select * From Clientes
Where Nombres Like 'A%a%'
Go

-- Todos los colaboradores que tengan m�s de 10 a�os de antig�edad

Select 
	Apellidos,
	Nombres,
	Year(GETDATE()) - A�oIngreso as Antig�edad
From Colaboradores
Where Year(GETDATE()) - A�oIngreso > 10
Go

-- Los c�digos de producto, sin repetir, que hayan registrado al menos un pedido

Select Distinct IDProducto From Pedidos
Go

-- Todos los datos de todos los productos con su precio aumentado en un 20%

Select 
	ID,
	IDCategoria,
	Descripcion,
	DiasConstruccion,
	Costo,
	Cast(Precio + (Precio * 0.2) As Smallmoney) As Precio,
	PrecioVentaMayorista,
	CantidadMayorista,
	Estado
From Productos

-- Todos los datos de todos los colaboradores ordenados por apellido ascendentemente en primera instancia y por nombre descendentemente en segunda instancia.

Select * From Colaboradores
Order by Apellidos Asc, Nombres Desc
Go
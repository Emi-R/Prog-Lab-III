-- Por cada producto listar la descripción del producto, el precio y el nombre de la categoría a la que pertenece.
Select 
    P.Descripcion, 
    P.Precio, 
    C.Nombre 
From Productos P
Inner Join Categorias C On P.IDCategoria = C.ID
Go

-- Listar las categorías de producto de las cuales no se registren productos.
Select  
    C.Nombre
From Productos P
Right Join Categorias C On P.IDCategoria = C.ID
Where P.Descripcion Is Null
Go

-- Listar el nombre de la categoría de producto de aquel o aquellos productos que más tiempo lleven en construir.
Select Top 1 With Ties 
    C.Nombre 
From Categorias C
Inner Join Productos P On C.ID = P.IDCategoria
Order By P.DiasConstruccion Desc
Go

-- Listar apellidos y nombres y dirección de mail de aquellos clientes que no hayan registrado pedidos.
Select 
    C.Apellidos,
    C.Nombres,
    C.Mail
From Pedidos P
Right Join Clientes C On P.IDCliente = C.ID
Where P.IdCliente Is Null
Go

-- Listar apellidos y nombres, mail, teléfono y celular de aquellos clientes que hayan realizado algún pedido cuyo costo supere $1000000
Select Distinct 
    C.Apellidos,
    C.Nombres,
    C.Mail,
    C.Telefono,
    C.Celular
From Clientes C
Inner Join Pedidos P On C.ID = P.IDCliente
Where P.Costo > 1000000
Go

-- Listar IDPedido, Costo, Fecha de solicitud y fecha de finalización, descripción del producto, costo y apellido y nombre del cliente. Sólo listar aquellos registros de pedidos que hayan sido pagados.
Select 
    P.ID As 'ID Pedido', 
    P.Costo, 
    P.FechaSolicitud As 'Fecha de Solicitud', 
    P.FechaFinalizacion As 'Fecha de Finalizacion', 
    Prod.Descripcion, 
    Prod.Costo, 
    C.Apellidos, 
    C.Nombres 
From Pedidos P
Inner Join Clientes C On C.ID = P.ID
Inner Join Productos Prod On P.IDProducto = Prod.ID
Where P.Pagado = 1
Go

-- Listar IDPedido, Fecha de solicitud, fecha de finalización, días de construcción del producto, días de construcción del pedido (fecha de finalización - fecha de solicitud) y una columna llamada Tiempo de construcción con la siguiente información: 
-- 'Con anterioridad' → Cuando la cantidad de días de construcción del pedido sea menor a los días de construcción del producto.
-- 'Exacto'' → Si la cantidad de días de construcción del pedido y el producto son iguales
-- 'Con demora' → Cuando la cantidad de días de construcción del pedido sea mayor a los días de construcción del producto.
Select 
    P.ID As 'ID Pedido',
    P.FechaSolicitud, 
    P.FechaFinalizacion, 
    Datediff(Day, P.FechaSolicitud, P.FechaFinalizacion) As 'Dias de construccion del Producto', 
    Prod.DiasConstruccion As 'Dias de construccion del Pedido',
Case
    When Datediff(Day, P.FechaSolicitud, P.FechaFinalizacion) < Prod.DiasConstruccion Then 'Con Anterioridad'
    When Datediff(Day, P.FechaSolicitud, P.FechaFinalizacion) = Prod.DiasConstruccion Then 'Exacto'
    When Datediff(Day, P.FechaSolicitud, P.FechaFinalizacion) > Prod.DiasConstruccion Then 'Con Demora'
    End as 'Tiempo de Construccion'
From Pedidos P
Inner Join Productos Prod On P.IDProducto = Prod.ID
Go

-- Listar por cada cliente el apellido y nombres y los nombres de las categorías de aquellos productos de los cuales hayan realizado pedidos. No deben figurar registros duplicados.

Select Distinct C.Apellidos, C.Nombres, Cat.Nombre From Clientes C
Inner Join Pedidos P On C.ID = P.IDCliente
Inner Join Productos Pr On P.IDProducto = Pr.ID
Inner Join Categorias Cat On Pr.IDCategoria = Cat.ID

-- Listar apellidos y nombres de aquellos clientes que hayan realizado algún pedido cuya cantidad sea exactamente igual a la cantidad considerada mayorista del producto.

Select Distinct C.Apellidos, C.Nombres From Clientes C
Inner Join Pedidos P On P.IDCliente = C.ID
Inner Join Productos Pr On Pr.ID = P.IDProducto
Where P.Cantidad = Pr.CantidadMayorista

-- Listar por cada producto el nombre del producto, el nombre de la categoría, el precio de venta minorista, el precio de venta mayorista y el porcentaje de ahorro que se obtiene por la compra mayorista a valor mayorista en relación al valor minorista.

Select P.Descripcion, C.Nombre, P.Precio, P.PrecioVentaMayorista, (P.Precio - P.PrecioVentaMayorista) * 100 / P.Precio as 'Porcentaje de Ahorro' From Productos P
Inner Join Categorias C On C.ID = P.IDCategoria
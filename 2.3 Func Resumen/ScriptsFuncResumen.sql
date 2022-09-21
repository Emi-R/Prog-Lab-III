-- La cantidad de colaboradores que nacieron luego del año 1995.
Select 
    Count(FechaNacimiento) As Conteo 
From Colaboradores 
Where Year(FechaNacimiento) > 1995

-- El costo total de todos los pedidos que figuren como Pagado.
Select 
    Sum(Costo) as 'Costo Total' 
 From Pedidos 
 Where Pagado = 1

-- La cantidad total de unidades pedidas del producto con ID igual a 30.
Select 
    Count(IDProducto) As UnidadesPedidas 
From Pedidos 
Where IDProducto = 30

-- La cantidad de clientes distintos que hicieron pedidos en el año 2020.
Select 
    IDCliente,  
    Count(IDCliente) 
From Pedidos 
Where Year(FechaSolicitud) = 2020
Group By IDCliente

-- Por cada material, la cantidad de productos que lo utilizan.
Select 
    IDMaterial,
    Count(*) As Cantidad
From Materiales_x_Producto 
Group By IDMaterial

-- Para cada producto, listar el nombre y la cantidad de pedidos pagados.
Select
    P.ID,
    P.Descripcion As Nombre,
    Count(*) as 'Cantidad Pagados'
From Productos P Inner Join Pedidos Ped On P.ID = Ped.IDProducto
Where Ped.Pagado = 1
Group By P.ID, P.Descripcion

-- Por cada cliente, listar apellidos y nombres de los clientes y la cantidad de productos distintos que haya pedido.
Select
    C.Apellidos,
    C.Nombres,
    Count(distinct P.IDProducto) As Cant
From Clientes C 
Inner Join Pedidos P On P.IDCliente = C.ID
Group by C.Apellidos, C.Nombres

-- Por cada colaborador y tarea que haya realizado, listar apellidos y nombres, nombre de la tarea y la cantidad de veces que haya realizado esa tarea.
Select
    C.Apellidos,
    C.Nombres,
    T.Nombre,
    Count(Ta.IDTarea) as Cantidad
From Colaboradores C 
Inner Join Tareas_x_Pedido Ta On C.Legajo = Ta.Legajo
Inner Join Tareas T On Ta.IDTarea = T.ID
Group by C.Apellidos, C.Nombres, T.Nombre

-- Por cada cliente, listar los apellidos y nombres y el importe individual más caro que hayan abonado en concepto de pago.
Select
    C.ID,
    C.Apellidos,
    C.Nombres,
    Max(Pa.Importe) as 'Pago Maximo'
From Clientes C
Inner Join Pedidos P On C.ID = P.IDCliente
Inner Join Pagos Pa On P.IDCliente = Pa.ID
Group by C.ID, C.Apellidos, C.Nombres

-- Por cada colaborador, apellidos y nombres y la menor cantidad de unidades solicitadas en un pedido individual en el que haya trabajado.
Select
    C.Legajo,
    C.Apellidos,
    C.Nombres,
    Min(P.Cantidad)
From Colaboradores C
Inner Join Tareas_x_Pedido T On C.Legajo = T.Legajo
Inner Join Pedidos P On T.IDPedido = P.ID
Group By C.Legajo, C.Apellidos, C.Nombres

-- Listar apellidos y nombres de aquellos clientes que no hayan realizado ningún pedido. Es decir, que contabilicen 0 pedidos.
Select 
    C.Apellidos,
    C.Nombres,
    Count(P.Id) as Pedidos
From Clientes C
Left Join Pedidos P On C.ID = P.ID
Group By C.Apellidos, C.Nombres
Having Count(P.Id) = 0

-- Obtener un listado de productos indicando descripción y precio de aquellos productos que hayan registrado más de 15 pedidos.
Select
    P.Descripcion,
    P.Precio,
    Count(Pe.IDProducto)
From Productos P
Inner Join Pedidos Pe On P.ID = Pe.IDProducto
Group By Pe.IDProducto, P.Descripcion, P.Precio
Having Count(Pe.IDProducto) > 15

-- Obtener un listado de productos indicando descripción y nombre de categoría de los productos que tienen un precio promedio de pedidos mayor a $25000.
Select
    P.ID,
    P.Descripcion,
    C.Nombre,
    Avg(Pe.Costo) As Promedio
From Productos P
Inner Join Pedidos Pe on P.ID = Pe.IDProducto
Inner Join Categorias C On P.IDCategoria = C.ID
Group By P.ID, P.Descripcion, C.Nombre
Having Avg(Pe.Costo) > 25000

-- Apellidos y nombres de los clientes que hayan registrado más de 15 pedidos que superen los $15000.
Select
    C.Apellidos,
    C.Nombres,
    Count(P.Costo) As Pedidos
From Clientes C 
Inner Join Pedidos P On C.ID = P.IDCliente
Where P.Costo > 15000
Group by C.Nombres, C.Apellidos
Having Count(P.Costo) > 15

-- Para cada producto, listar el nombre, el texto 'Pagados'  y la cantidad de pedidos pagados. Anexar otro listado con nombre, el texto 'No pagados' y cantidad de pedidos no pagados.
Select 
    Pr.ID,
    Pr.Descripcion,
    Count(P.Pagado) As Pagados
From Pedidos P 
Inner Join Productos Pr On P.IDProducto = PR.ID
Where P.Pagado = 1
Group By Pr.ID, Pr.Descripcion
Select 
    Pr.ID,
    Pr.Descripcion,
    Count(P.Pagado) As 'NoPagados'
From Pedidos P 
Inner Join Productos Pr On P.IDProducto = PR.ID
Where P.Pagado = 0
Group By Pr.ID, Pr.Descripcion
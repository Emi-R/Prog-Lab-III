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



Select * From Materiales_x_Producto

Select * From Productos

Select * from Pedidos

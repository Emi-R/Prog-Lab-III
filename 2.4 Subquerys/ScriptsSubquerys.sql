-- Los pedidos que hayan sido finalizados en menor cantidad de días que la demora promedio
Select * From Pedidos P
Where Datediff(Day, P.FechaSolicitud, P.FechaFinalizacion) < (
    Select Avg(Datediff(Day, P.FechaSolicitud, P.FechaFinalizacion)) 
    From Pedidos P
    )

-- Los productos cuyo costo sea mayor que el costo del producto de Roble más caro
Select * from Productos P
Where P.Costo > (
    Select Max(Costo) from Productos P
    Inner Join Materiales_x_Producto MxP On P.ID = MxP.IDProducto
    Inner Join Materiales M On MxP.IDMaterial = M.ID 
    Where M.Nombre like 'Roble'
    )

-- Los clientes que no hayan solicitado ningún producto de material Pino en el año 2022


Select * From Materiales
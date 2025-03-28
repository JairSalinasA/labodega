-- 1. Insertar datos en la tabla Roles
INSERT INTO Roles (Nombre) 
VALUES 
    ('Admin'), 
    ('Vendedor'), 
    ('Cajero');

-- 2. Insertar datos en la tabla Configuracion
INSERT INTO Configuracion (NombreEmpresa, Direccion, Telefono, Email, Moneda, Impuestos) 
VALUES 
    ('Torres Meats', '123 Calle Principal, Ciudad', '555-1234', 'info@torresmeats.com', 'USD', 15.00);

-- 3. Insertar datos en la tabla TiposNotificacion
INSERT INTO TiposNotificacion (Nombre, Descripcion, Color, Icono, Estado) 
VALUES 
    ('NuevaVenta', 'Notificación de nueva venta registrada', 'success', 'shopping-cart', 1),
    ('StockBajo', 'Notificación de stock bajo', 'warning', 'exclamation-triangle', 1),
    ('TemperaturaAnormal', 'Notificación de temperatura anormal', 'danger', 'thermometer-half', 1),
    ('VencimientoProximo', 'Notificación de producto próximo a vencer', 'warning', 'calendar-times', 1);

-- 4. Insertar datos en la tabla Usuarios
-- Asegúrate de que no exista ya un usuario con el mismo email
IF NOT EXISTS (SELECT 1 FROM Usuarios WHERE Email = 'admin@torresmeats.com')
BEGIN
    INSERT INTO Usuarios (Nombre, Email, Contrasena, Estado, UsuarioCreacionID) 
    VALUES 
        ('Admin', 'admin@torresmeats.com', HASHBYTES('SHA2_256', 'password123'), 1, 1);
END;

-- 5. Insertar datos en la tabla UsuariosRoles
-- Asegúrate de que no exista ya una relación entre el usuario y el rol
IF NOT EXISTS (SELECT 1 FROM UsuariosRoles WHERE UsuarioID = 1 AND RolID = 1)
BEGIN
    INSERT INTO UsuariosRoles (UsuarioID, RolID) 
    VALUES 
        (1, 1);
END;

-- 6. Insertar datos en la tabla Clientes
INSERT INTO Clientes (Nombre, Direccion, Ciudad, Estado, CodigoPostal, Telefono, Email, Tipo, UsuarioCreacionID) 
VALUES 
    ('Cliente Ejemplo', '123 Calle Cliente', 'Ciudad Cliente', 'Estado Cliente', '12345', '555-6789', 'cliente@example.com', 'Individual', 1);

-- 7. Insertar datos en la tabla Proveedores
INSERT INTO Proveedores (Nombre, Contacto, Telefono, Email, Tipo, UsuarioCreacionID) 
VALUES 
    ('Proveedor Ejemplo', 'Juan Perez', '555-9876', 'proveedor@example.com', 'Empresa', 1);

-- 8. Insertar datos en la tabla Productos
INSERT INTO Productos (Nombre, Descripcion, CodigoBarras, SKU, Precio, Stock, StockMinimo, PesoLBS, Categoria, UsuarioCreacionID) 
VALUES 
    ('Producto A', 'Descripción del Producto A', '123456789', 'SKU001', 100.00, 50, 10, 5.00, 'Carnes', 1);

-- 9. Insertar datos en la tabla LotesProductos
INSERT INTO LotesProductos (ProductoID, NumeroLote, FechaProduccion, FechaCaducidad, Proveedor, CantidadInicial, CantidadActual, Estado, UsuarioCreacionID) 
VALUES 
    (1, 'LOTE001', '2023-01-01', '2023-12-31', 1, 100, 100, 'Activo', 1);

-- 10. Insertar datos en la tabla Inventario
INSERT INTO Inventario (ProductoID, Cantidad, TipoMovimiento, Ubicacion, UsuarioCreacionID) 
VALUES 
    (1, 50, 'Entrada', 'Almacen Principal', 1);

-- 11. Insertar datos en la tabla Ventas
INSERT INTO Ventas (ClienteID, Total, MetodoPago, Estado, UsuarioCreacionID) 
VALUES 
    (1, 500.00, 'Efectivo', 'Pagado', 1);

-- 12. Insertar datos en la tabla DetallesVentas
INSERT INTO DetallesVentas (VentaID, ProductoID, LoteID, Cantidad, PrecioUnitario, PesoLBS, NumCajas) 
VALUES 
    (1, 1, 1, 5, 100.00, 10.00, 1);

-- 13. Insertar datos en la tabla Compras
INSERT INTO Compras (ProveedorID, Total, MetodoPago, UsuarioCreacionID) 
VALUES 
    (1, 1000.00, 'Transferencia', 1);

-- 14. Insertar datos en la tabla DetallesCompras
INSERT INTO DetallesCompras (CompraID, ProductoID, Cantidad, PrecioUnitario) 
VALUES 
    (1, 1, 10, 100.00);

-- 15. Insertar datos en la tabla CuentasPorCobrar
INSERT INTO CuentasPorCobrar (ClienteID, VentaID, Monto, FechaVencimiento, Estado) 
VALUES 
    (1, 1, 500.00, '2023-12-31', 'Pendiente');

-- 16. Insertar datos en la tabla CuentasPorPagar
INSERT INTO CuentasPorPagar (ProveedorID, CompraID, Monto, FechaVencimiento, Estado) 
VALUES 
    (1, 1, 300.00, '2023-12-15', 'Pendiente');

-- 17. Insertar datos en la tabla Devoluciones
INSERT INTO Devoluciones (VentaID, ProductoID, Cantidad, Motivo, Estado, MontoReembolso, UsuarioCreacionID) 
VALUES 
    (1, 1, 2.00, 'Producto defectuoso', 'Pendiente', 200.00, 1);

-- 18. Insertar datos en la tabla Mermas
INSERT INTO Mermas (ProductoID, LoteID, Cantidad, Motivo, CostoEstimado, Notas, UsuarioRegistroID) 
VALUES 
    (1, 1, 5.00, 'Daño durante el transporte', 50.00, 'Producto dañado', 1);

-- 19. Insertar datos en la tabla ControlCalidad
INSERT INTO ControlCalidad (LoteID, Temperatura, AspectoBIT, ColorBIT, OlorBIT, TexturaBIT, Observaciones, Estado, UsuarioInspeccionID) 
VALUES 
    (1, -18.00, 1, 1, 1, 1, 'Producto en buen estado', 'Aprobado', 1);

-- 20. Insertar datos en la tabla RegistrosTemperatura
INSERT INTO RegistrosTemperatura (UbicacionID, Temperatura, Estado, Notas, UsuarioRegistroID) 
VALUES 
    ('Freezer1', -18.00, 'Normal', 'Temperatura dentro del rango', 1),
    ('Freezer2', 5.00, 'Advertencia', 'Temperatura elevada', 1);

-- 21. Insertar datos en la tabla ArqueoCaja
INSERT INTO ArqueoCaja (MontoInicial, MontoFinal, Diferencia, Observaciones, UsuarioID, Estado) 
VALUES 
    (1000.00, 1200.00, 200.00, 'Cierre de caja exitoso', 1, 'Cerrado');

-- 22. Insertar datos en la tabla Notificaciones
INSERT INTO Notificaciones (TipoNotificacionID, UsuarioID, Titulo, Mensaje, EntidadTipo, EntidadID) 
VALUES 
    (1, 1, 'Nueva Venta Registrada', 'Se ha registrado una nueva venta por $100.00', 'Venta', 1),
    (2, 1, 'Stock Bajo - Producto A', 'El producto Producto A ha alcanzado el stock mínimo.', 'Producto', 1);
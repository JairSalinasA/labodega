-- Primero eliminamos la base de datos si existe
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'LaBodegaDB')
BEGIN
    USE master;
    ALTER DATABASE LaBodegaDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE LaBodegaDB;
END
GO

-- Crear base de datos
CREATE DATABASE laBodegaDB;
GO
USE laBodegaDB;
GO

-- CREACIÓN DE TABLAS

-- Tabla de Roles
CREATE TABLE Roles (
    ID INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(50) NOT NULL UNIQUE -- Ejemplo: 'Admin', 'Vendedor', 'Cajero'
);
GO

-- Tabla de Usuarios
CREATE TABLE Usuarios (
    ID INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Contrasena NVARCHAR(255) NOT NULL,
    Foto VARBINARY(MAX),
    Estado BIT DEFAULT 1,
    UltimoAcceso DATETIME,
    IntentosFallidos INT DEFAULT 0,
    FechaCreacion DATETIME DEFAULT GETDATE(),
    FechaModificacion DATETIME DEFAULT GETDATE(),
    UsuarioCreacionID INT FOREIGN KEY REFERENCES Usuarios(ID),
    UsuarioModificacionID INT FOREIGN KEY REFERENCES Usuarios(ID)
);
GO

-- Tabla intermedia para roles de usuarios
CREATE TABLE UsuariosRoles (
    UsuarioID INT FOREIGN KEY REFERENCES Usuarios(ID) ON DELETE CASCADE,
    RolID INT FOREIGN KEY REFERENCES Roles(ID) ON DELETE CASCADE,
    PRIMARY KEY (UsuarioID, RolID)
);
GO

-- Tabla de Configuración
CREATE TABLE Configuracion (
    ID INT PRIMARY KEY IDENTITY,
    NombreEmpresa NVARCHAR(100) NOT NULL,
    Direccion NVARCHAR(255),
    Telefono NVARCHAR(50),
    Email NVARCHAR(100),
    Logo VARBINARY(MAX),
    Moneda NVARCHAR(10) DEFAULT 'USD',
    Impuestos DECIMAL(5,2) DEFAULT 0.0
);
GO

-- Tabla de Clientes
CREATE TABLE Clientes (
    ID INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(100) NOT NULL,
    Direccion NVARCHAR(255),
    Ciudad NVARCHAR(100),
    Estado NVARCHAR(50),
    CodigoPostal NVARCHAR(20),
    Telefono NVARCHAR(50),
    Email NVARCHAR(100),
    Foto VARBINARY(MAX),
    Tipo NVARCHAR(20) CHECK (Tipo IN ('Individual', 'Empresa')),
    Notas NVARCHAR(MAX),
    FechaCreacion DATETIME DEFAULT GETDATE(),
    UsuarioCreacionID INT FOREIGN KEY REFERENCES Usuarios(ID)
);
GO

-- Tabla de Proveedores
CREATE TABLE Proveedores (
    ID INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(100) NOT NULL,
    Contacto NVARCHAR(100),
    Telefono NVARCHAR(50),
    Email NVARCHAR(100),
    Logo VARBINARY(MAX),
    Tipo NVARCHAR(20) CHECK (Tipo IN ('Individual', 'Empresa')),
    Notas NVARCHAR(MAX),
    FechaCreacion DATETIME DEFAULT GETDATE(),
    UsuarioCreacionID INT FOREIGN KEY REFERENCES Usuarios(ID)
);
GO

-- Tabla de Productos
CREATE TABLE Productos (
    ID INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(255),
    CodigoBarras NVARCHAR(50) UNIQUE,
    SKU NVARCHAR(50) UNIQUE,
    Precio DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL,
    StockMinimo INT DEFAULT 0,
    PesoLBS DECIMAL(10,2) NOT NULL,
    Categoria NVARCHAR(50),
    Imagen VARBINARY(MAX),
    UnidadMedida NVARCHAR(20) DEFAULT 'LBS',
    FechaCreacion DATETIME DEFAULT GETDATE(),
    FechaModificacion DATETIME DEFAULT GETDATE(),
    UsuarioCreacionID INT FOREIGN KEY REFERENCES Usuarios(ID),
    UsuarioModificacionID INT FOREIGN KEY REFERENCES Usuarios(ID)
);
GO

-- Tabla de Lotes de Productos
CREATE TABLE LotesProductos (
    ID INT PRIMARY KEY IDENTITY,
    ProductoID INT FOREIGN KEY REFERENCES Productos(ID),
    NumeroLote NVARCHAR(50) NOT NULL,
    FechaProduccion DATE NOT NULL,
    FechaCaducidad DATE NOT NULL,
    Proveedor INT FOREIGN KEY REFERENCES Proveedores(ID),
    CantidadInicial DECIMAL(10,2) NOT NULL,
    CantidadActual DECIMAL(10,2) NOT NULL,
    Estado NVARCHAR(20) CHECK (Estado IN ('Activo', 'Agotado', 'Vencido', 'Descartado')),
    Notas NVARCHAR(MAX),
    FechaCreacion DATETIME DEFAULT GETDATE(),
    UsuarioCreacionID INT FOREIGN KEY REFERENCES Usuarios(ID)
);
GO

-- Tabla de Inventario
CREATE TABLE Inventario (
    ID INT PRIMARY KEY IDENTITY,
    ProductoID INT FOREIGN KEY REFERENCES Productos(ID),
    Cantidad INT NOT NULL,
    NumeroLote NVARCHAR(50),
    FechaMovimiento DATETIME DEFAULT GETDATE(),
    TipoMovimiento NVARCHAR(50) CHECK (TipoMovimiento IN ('Entrada', 'Salida')),
    Ubicacion NVARCHAR(100),
    Notas NVARCHAR(MAX),
    UsuarioCreacionID INT FOREIGN KEY REFERENCES Usuarios(ID)
);
GO

-- Tabla de Ventas
CREATE TABLE Ventas (
    ID INT PRIMARY KEY IDENTITY,
    ClienteID INT FOREIGN KEY REFERENCES Clientes(ID),
    NumeroFactura NVARCHAR(50) UNIQUE,
    Fecha DATETIME DEFAULT GETDATE(),
    Total DECIMAL(10,2) NOT NULL,
    OrderNumber NVARCHAR(50),
    MetodoPago NVARCHAR(50),
    Estado NVARCHAR(20) CHECK (Estado IN ('Pendiente', 'Pagado', 'Cancelado')),
    DireccionEnvio NVARCHAR(255),
    CiudadEnvio NVARCHAR(100),
    EstadoEnvio NVARCHAR(50),
    CodigoPostalEnvio NVARCHAR(20),
    CostoEnvio DECIMAL(10,2) DEFAULT 0.0,
    FechaEnvio DATETIME,
    UsuarioCreacionID INT FOREIGN KEY REFERENCES Usuarios(ID),
    UsuarioModificacionID INT FOREIGN KEY REFERENCES Usuarios(ID)
);
GO

-- Detalles de Ventas
CREATE TABLE DetallesVentas (
    ID INT PRIMARY KEY IDENTITY,
    VentaID INT FOREIGN KEY REFERENCES Ventas(ID),
    ProductoID INT FOREIGN KEY REFERENCES Productos(ID),
    LoteID INT FOREIGN KEY REFERENCES LotesProductos(ID),
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    PesoLBS DECIMAL(10,2) NOT NULL,
    NumCajas INT NOT NULL,
    Descuento DECIMAL(10,2) DEFAULT 0.0,
    Impuesto DECIMAL(10,2) DEFAULT 0.0,
    SubTotal AS (Cantidad * PrecioUnitario * (1 - Descuento) + Impuesto) PERSISTED
);
GO

-- Tabla de Devoluciones
CREATE TABLE Devoluciones (
    ID INT PRIMARY KEY IDENTITY,
    VentaID INT FOREIGN KEY REFERENCES Ventas(ID),
    ProductoID INT FOREIGN KEY REFERENCES Productos(ID),
    Cantidad DECIMAL(10,2) NOT NULL,
    Motivo NVARCHAR(255) NOT NULL,
    FechaDevolucion DATETIME DEFAULT GETDATE(),
    Estado NVARCHAR(20) CHECK (Estado IN ('Pendiente', 'Procesada', 'Rechazada')),
    MontoReembolso DECIMAL(10,2),
    Notas NVARCHAR(MAX),
    UsuarioCreacionID INT FOREIGN KEY REFERENCES Usuarios(ID)
);
GO

-- Tabla de Cuentas por Cobrar
CREATE TABLE CuentasPorCobrar (
    ID INT PRIMARY KEY IDENTITY,
    ClienteID INT FOREIGN KEY REFERENCES Clientes(ID),
    VentaID INT FOREIGN KEY REFERENCES Ventas(ID),
    Monto DECIMAL(10,2) NOT NULL,
    FechaVencimiento DATE NOT NULL,
    FechaPago DATE,
    Interes DECIMAL(10,2) DEFAULT 0.0,
    Estado NVARCHAR(20) CHECK (Estado IN ('Pendiente', 'Pagado'))
);
GO

-- Tabla de Compras
CREATE TABLE Compras (
    ID INT PRIMARY KEY IDENTITY,
    ProveedorID INT FOREIGN KEY REFERENCES Proveedores(ID),
    Fecha DATETIME DEFAULT GETDATE(),
    Total DECIMAL(10,2) NOT NULL,
    OrderNumber NVARCHAR(50),
    MetodoPago NVARCHAR(50),
    FechaEntrega DATE,
    Notas NVARCHAR(MAX),
    UsuarioCreacionID INT FOREIGN KEY REFERENCES Usuarios(ID)
);
GO

-- Detalles de Compras
CREATE TABLE DetallesCompras (
    ID INT PRIMARY KEY IDENTITY,
    CompraID INT FOREIGN KEY REFERENCES Compras(ID),
    ProductoID INT FOREIGN KEY REFERENCES Productos(ID),
    Cantidad INT NOT NULL,
    PrecioUnitario DECIMAL(10,2) NOT NULL,
    SubTotal AS (Cantidad * PrecioUnitario) PERSISTED
);
GO

-- Tabla de Cuentas por Pagar
CREATE TABLE CuentasPorPagar (
    ID INT PRIMARY KEY IDENTITY,
    ProveedorID INT FOREIGN KEY REFERENCES Proveedores(ID),
    CompraID INT FOREIGN KEY REFERENCES Compras(ID),
    Monto DECIMAL(10,2) NOT NULL,
    FechaVencimiento DATE NOT NULL,
    FechaPago DATE,
    Estado NVARCHAR(20) CHECK (Estado IN ('Pendiente', 'Pagado'))
);
GO

-- Tabla de Arqueo de Caja
CREATE TABLE ArqueoCaja (
    ID INT PRIMARY KEY IDENTITY,
    Fecha DATETIME DEFAULT GETDATE(),
    MontoInicial DECIMAL(10,2) NOT NULL,
    MontoFinal DECIMAL(10,2),
    Diferencia DECIMAL(10,2),
    Observaciones NVARCHAR(255),
    UsuarioID INT FOREIGN KEY REFERENCES Usuarios(ID),
    Estado NVARCHAR(20) CHECK (Estado IN ('Abierto', 'Cerrado'))
);
GO

-- Tabla de Registros de Temperatura
CREATE TABLE RegistrosTemperatura (
    ID INT PRIMARY KEY IDENTITY,
    UbicacionID NVARCHAR(50) NOT NULL,
    Temperatura DECIMAL(5,2) NOT NULL,
    FechaRegistro DATETIME DEFAULT GETDATE(),
    Estado NVARCHAR(20) CHECK (Estado IN ('Normal', 'Advertencia', 'Crítico')),
    Notas NVARCHAR(MAX),
    UsuarioRegistroID INT FOREIGN KEY REFERENCES Usuarios(ID)
);
GO

-- Tabla de Mermas
CREATE TABLE Mermas (
    ID INT PRIMARY KEY IDENTITY,
    ProductoID INT FOREIGN KEY REFERENCES Productos(ID),
    LoteID INT FOREIGN KEY REFERENCES LotesProductos(ID),
    Cantidad DECIMAL(10,2) NOT NULL,
    Motivo NVARCHAR(255) NOT NULL,
    FechaRegistro DATETIME DEFAULT GETDATE(),
    CostoEstimado DECIMAL(10,2),
    Notas NVARCHAR(MAX),
    UsuarioRegistroID INT FOREIGN KEY REFERENCES Usuarios(ID)
);
GO

-- Tabla de Control de Calidad
CREATE TABLE ControlCalidad (
    ID INT PRIMARY KEY IDENTITY,
    LoteID INT FOREIGN KEY REFERENCES LotesProductos(ID),
    FechaInspeccion DATETIME DEFAULT GETDATE(),
    Temperatura DECIMAL(5,2),
    AspectoBIT BIT,
    ColorBIT BIT,
    OlorBIT BIT,
    TexturaBIT BIT,
    Observaciones NVARCHAR(MAX),
    Estado NVARCHAR(20) CHECK (Estado IN ('Aprobado', 'Rechazado', 'En Revisión')),
    UsuarioInspeccionID INT FOREIGN KEY REFERENCES Usuarios(ID)
);
GO

-- Tabla para tipos de notificaciones
CREATE TABLE TiposNotificacion (
    ID INT PRIMARY KEY IDENTITY,
    Nombre NVARCHAR(50) NOT NULL UNIQUE,
    Descripcion NVARCHAR(255),
    Color NVARCHAR(20), -- Para diferenciación visual (ej: 'success', 'warning', 'danger')
    Icono NVARCHAR(50), -- Nombre del icono a mostrar
    Estado BIT DEFAULT 1 -- 1: Activo, 0: Inactivo
);
GO

-- Tabla principal de notificaciones
CREATE TABLE Notificaciones (
    ID INT PRIMARY KEY IDENTITY,
    TipoNotificacionID INT FOREIGN KEY REFERENCES TiposNotificacion(ID),
    UsuarioID INT FOREIGN KEY REFERENCES Usuarios(ID), -- Usuario que recibirá la notificación
    Titulo NVARCHAR(100) NOT NULL,
    Mensaje NVARCHAR(MAX) NOT NULL,
    FechaCreacion DATETIME DEFAULT GETDATE(),
    FechaLectura DATETIME, -- NULL significa no leída
    FechaExpiracion DATETIME, -- Opcional, para notificaciones que caducan
    URL NVARCHAR(255), -- Link opcional para redireccionar al hacer clic
    Prioridad INT DEFAULT 0, -- 0: Normal, 1: Alta, 2: Urgente
    Estado NVARCHAR(20) CHECK (Estado IN ('Pendiente', 'Leida', 'Archivada', 'Eliminada')),
    EntidadTipo NVARCHAR(50), -- Tipo de entidad relacionada (ej: 'Venta', 'Producto', 'Inventario')
    EntidadID INT, -- ID de la entidad relacionada
    UsuarioCreacionID INT FOREIGN KEY REFERENCES Usuarios(ID)
);
GO
 
 
-- PROCEDIMIENTOS ALMACENADOS

-- SP para crear nuevo usuario
CREATE PROCEDURE sp_CrearUsuario
    @Nombre NVARCHAR(100),
    @Email NVARCHAR(100),
    @Contrasena NVARCHAR(100),
    @RolID INT
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Insertar usuario
        INSERT INTO Usuarios (Nombre, Email, Contrasena)
        VALUES (@Nombre, @Email, HASHBYTES('SHA2_256', @Contrasena));

        -- Obtener el ID del usuario insertado
        DECLARE @UsuarioID INT = SCOPE_IDENTITY();

        -- Asignar rol
        INSERT INTO UsuariosRoles (UsuarioID, RolID)
        VALUES (@UsuarioID, @RolID);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- SP para actualizar stock
CREATE PROCEDURE sp_ActualizarStock
    @ProductoID INT,
    @Cantidad INT,
    @TipoMovimiento NVARCHAR(50),
    @UsuarioID INT
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Actualizar stock en Productos
        IF @TipoMovimiento = 'Entrada'
            UPDATE Productos 
            SET Stock = Stock + @Cantidad
            WHERE ID = @ProductoID;
        ELSE
            UPDATE Productos 
            SET Stock = Stock - @Cantidad
            WHERE ID = @ProductoID;

        -- Registrar movimiento en Inventario
        INSERT INTO Inventario (ProductoID, Cantidad, TipoMovimiento, UsuarioCreacionID)
        VALUES (@ProductoID, @Cantidad, @TipoMovimiento, @UsuarioID);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- SP para procesar venta
CREATE PROCEDURE sp_ProcesarVenta
    @ClienteID INT,
    @UsuarioID INT,
    @Total DECIMAL(10,2),
    @MetodoPago NVARCHAR(50)
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Insertar venta
        INSERT INTO Ventas (ClienteID, Total, MetodoPago, UsuarioCreacionID)
        VALUES (@ClienteID, @Total, @MetodoPago, @UsuarioID);

        -- Obtener el ID de la venta
        DECLARE @VentaID INT = SCOPE_IDENTITY();

        -- Crear notificación de venta
        INSERT INTO Notificaciones (
            TipoNotificacionID,
            UsuarioID,
            Titulo,
            Mensaje,
            EntidadTipo,
            EntidadID
        )
        SELECT 
            ID,
            @UsuarioID,
            'Nueva Venta Registrada',
            'Se ha registrado una nueva venta por $' + CAST(@Total AS NVARCHAR(20)),
            'Venta',
            @VentaID
        FROM TiposNotificacion
        WHERE Nombre = 'NuevaVenta';

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- TRIGGERS

-- Trigger para control de stock mínimo
CREATE TRIGGER tr_ControlStockMinimo
ON Productos
AFTER UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM inserted i 
        WHERE i.Stock <= i.StockMinimo
    )
    BEGIN
        INSERT INTO Notificaciones (
            TipoNotificacionID,
            Titulo,
            Mensaje,
            EntidadTipo,
            EntidadID
        )
        SELECT 
            (SELECT ID FROM TiposNotificacion WHERE Nombre = 'StockBajo'),
            'Stock Bajo - ' + i.Nombre,
            'El producto ' + i.Nombre + ' ha alcanzado el stock mínimo.',
            'Producto',
            i.ID
        FROM inserted i
        WHERE i.Stock <= i.StockMinimo;
    END
END;
GO

-- Trigger para control de temperatura
CREATE TRIGGER tr_ControlTemperatura
ON RegistrosTemperatura
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM inserted 
        WHERE Temperatura > 40 OR Temperatura < 0
    )
    BEGIN
        INSERT INTO Notificaciones (
            TipoNotificacionID,
            Titulo,
            Mensaje,
            EntidadTipo,
            EntidadID
        )
        SELECT 
            (SELECT ID FROM TiposNotificacion WHERE Nombre = 'TemperaturaAnormal'),
            'Alerta de Temperatura',
            'Temperatura anormal detectada: ' + CAST(i.Temperatura AS NVARCHAR(10)) + '°C',
            'RegistroTemperatura',
            i.ID
        FROM inserted i
        WHERE Temperatura > 40 OR Temperatura < 0;
    END
END;
GO

-- Trigger para control de vencimiento de productos
CREATE TRIGGER tr_ControlVencimiento
ON LotesProductos
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM inserted 
        WHERE DATEDIFF(day, GETDATE(), FechaCaducidad) <= 30
    )
    BEGIN
        INSERT INTO Notificaciones (
            TipoNotificacionID,
            Titulo,
            Mensaje,
            EntidadTipo,
            EntidadID
        )
        SELECT 
            (SELECT ID FROM TiposNotificacion WHERE Nombre = 'VencimientoProximo'),
            'Producto Próximo a Vencer',
            'El lote ' + i.NumeroLote + ' vencerá en ' + 
            CAST(DATEDIFF(day, GETDATE(), i.FechaCaducidad) AS NVARCHAR(10)) + ' días',
            'Lote',
            i.ID
        FROM inserted i
        WHERE DATEDIFF(day, GETDATE(), FechaCaducidad) <= 30;
    END
END;
GO

-- ÍNDICES ADICIONALES

-- Índices ya creados en el script original de tablas
/* 
CREATE INDEX IX_Productos_CodigoBarras ON Productos(CodigoBarras);
CREATE INDEX IX_Productos_SKU ON Productos(SKU);
CREATE INDEX IX_Ventas_NumeroFactura ON Ventas(NumeroFactura);
CREATE INDEX IX_LotesProductos_NumeroLote ON LotesProductos(NumeroLote);
CREATE INDEX IX_DetallesVentas_VentaID ON DetallesVentas(VentaID);
CREATE INDEX IX_DetallesVentas_ProductoID ON DetallesVentas(ProductoID);
CREATE INDEX IX_Inventario_ProductoID ON Inventario(ProductoID);
CREATE INDEX IX_LotesProductos_ProductoID ON LotesProductos(ProductoID);
CREATE INDEX IX_Notificaciones_UsuarioID ON Notificaciones(UsuarioID);
CREATE INDEX IX_Notificaciones_Estado ON Notificaciones(Estado);
CREATE INDEX IX_Notificaciones_FechaCreacion ON Notificaciones(FechaCreacion);
*/

-- Índices adicionales para búsquedas frecuentes en Ventas
CREATE INDEX IX_Ventas_Fecha ON Ventas(Fecha);
CREATE INDEX IX_Ventas_ClienteID ON Ventas(ClienteID);

-- Índices adicionales para búsquedas en Inventario
CREATE INDEX IX_Inventario_FechaMovimiento ON Inventario(FechaMovimiento);
CREATE INDEX IX_Inventario_TipoMovimiento ON Inventario(TipoMovimiento);

-- Índices adicionales para Lotes
CREATE INDEX IX_LotesProductos_FechaCaducidad ON LotesProductos(FechaCaducidad);
CREATE INDEX IX_LotesProductos_Estado ON LotesProductos(Estado);

-- Índices adicionales para Control de Calidad
CREATE INDEX IX_ControlCalidad_FechaInspeccion ON ControlCalidad(FechaInspeccion);
CREATE INDEX IX_ControlCalidad_Estado ON ControlCalidad(Estado);

-- Índices adicionales para Clientes
CREATE INDEX IX_Clientes_Nombre ON Clientes(Nombre);
CREATE INDEX IX_Clientes_Email ON Clientes(Email);

-- Índices adicionales para CuentasPorCobrar
CREATE INDEX IX_CuentasPorCobrar_FechaVencimiento ON CuentasPorCobrar(FechaVencimiento);
CREATE INDEX IX_CuentasPorCobrar_Estado ON CuentasPorCobrar(Estado);
GO

-- VISTAS

-- Vista de Productos con Stock Bajo
CREATE VIEW vw_ProductosStockBajo
AS
SELECT 
    p.ID,
    p.Nombre,
    p.Stock,
    p.StockMinimo,
    p.Categoria
FROM Productos p
WHERE p.Stock <= p.StockMinimo;
GO

-- Vista de Ventas del Día
CREATE VIEW vw_VentasDelDia
AS
SELECT 
    v.ID,
    v.NumeroFactura,
    c.Nombre AS Cliente,
    v.Total,
    v.MetodoPago,
    v.Estado
FROM Ventas v
INNER JOIN Clientes c ON v.ClienteID = c.ID
WHERE CAST(v.Fecha AS DATE) = CAST(GETDATE() AS DATE);
GO

-- Vista de Productos por Vencer
CREATE VIEW vw_ProductosPorVencer
AS
SELECT 
    p.Nombre AS Producto,
    l.NumeroLote,
    l.FechaCaducidad,
    l.CantidadActual,
    DATEDIFF(day, GETDATE(), l.FechaCaducidad) AS DiasParaVencer
FROM LotesProductos l
INNER JOIN Productos p ON l.ProductoID = p.ID
WHERE l.Estado = 'Activo' 
AND DATEDIFF(day, GETDATE(), l.FechaCaducidad) <= 30;
GO
 
 
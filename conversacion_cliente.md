# CARD CUSTOMS

## Contexto del negocio
Soy el propietario de ***Card Customs***, un negocio especializado en la **personalización artística de cartas** de juegos de mesa, con un enfoque principal en *Magic: The Gathering*. Nuestra tienda ofrece servicios de alteración y pintura a mano de cartas, transformando piezas de cartón en verdaderas obras de arte coleccionables.

##### Características principales de mi negocio:

- Trabajamos con artistas especializados en la modificación de cartas.
- Ofrecemos diferentes estilos y técnicas de personalización.
- Manejamos pedidos personalizados según las preferencias del cliente.
- Utilizamos materiales de alta calidad que no dañan las cartas.
- Brindamos servicios tanto para cartas individuales como para colecciones.
- Contamos con un catálogo de diseños predefinidos.
- Ofrecemos diferentes rangos de precios según la complejidad del trabajo.

La clave de nuestro éxito es la **atención al detalle** y la preservación de la **integridad de las cartas** mientras las transformamos en piezas únicas. Trabajamos principalmente **por encargo** y mantenemos una **comunicación constante** con nuestros clientes durante todo el proceso creativo.

## Conversación

**Cliente:** ¡Hola! Soy el dueño del negocio y estoy buscando desarrollar un sistema de base de datos que me ayude a gestionar mejor mi empresa. ¿Qué te gustaría saber sobre nuestras necesidades y operaciones?

---

**Yo:** ¿Operáis de forma exclusivamente online o también disponéis de tiendas físicas? En el caso de que solo sea online, se podría preparar la base de datos para un futuro en el que si vendáis fuera de la web.

---

**Cliente:** Actualmente operamos principalmente de forma online a través de nuestra página web y redes sociales, donde los clientes pueden ver nuestro catálogo de trabajos previos y hacer sus pedidos. Sin embargo, también tenemos un pequeño taller/estudio físico donde recibimos clientes con cita previa para consultas personalizadas y donde realizamos los trabajos de alteración.

Definitivamente sería muy útil estructurar la base de datos pensando en una futura expansión física. Algunos aspectos a considerar serían:

1. Gestión de múltiples ubicaciones:
   - Talleres/tiendas físicas
   - Artistas asignados a cada ubicación
   - Inventario por ubicación
1.  Control de citas presenciales:
    - Sistema de reservas
    - Disponibilidad por ubicación
    - Asignación de artistas
1. Ventas y servicios:
    - Ventas online vs. presenciales
    - Servicios específicos por ubicación
    - Gestión de envíos desde diferentes puntos 

¿Crees que sería conveniente incluir estas consideraciones en el diseño inicial de la base de datos, aunque por ahora solo tengamos una ubicación física?

---

**Yo:** Si, estaría bien para así no tener que realizar muchas modificaciones de esta en un futuro y dejarla preparada para todos los casos que necesites.

---

**Cliente:** Perfecto, entonces plantearía una estructura inicial que incluya:

1. Tabla de Ubicaciones (Locations):
    - ID_Location
    - Nombre
    - Dirección
    - Teléfono
    - Email
    - Horario
    - Tipo (Online/Física)
    - Estado (Activo/Inactivo)

2. Tabla de Empleados/Artistas (Staff):
    - ID_Staff
    - Nombre
    - Especialidad
    - ID_Location (donde trabaja principalmente)
    - Contacto
    - Estado laboral

3. Tabla de Servicios (Services):
    - ID_Service
    - Nombre
    - Descripción
    - Precio base
    - Tiempo estimado
    - Disponibilidad por ubicación

4. Tabla de Pedidos (Orders):
    - ID_Order
    - ID_Cliente
    - ID_Location
    - ID_Staff
    - Fecha pedido
    - Estado
    - Método de entrega
    - Precio total

¿Te parece adecuada esta estructura base? ¿Querrías añadir o modificar algún aspecto específico?

---

**Yo:** No te parece que estaría bien guardar también en una tabla las cartas de las que disponemos en el catálogo?

---

**Cliente:** ¡Por supuesto! Tienes toda la razón. Sería fundamental tener una tabla para el catálogo de cartas y probablemente también una para los diseños predefinidos. Podríamos añadir:

1. Tabla de Cartas (Cards):
   - ID_Card
   - Nombre
   - Edición/Set
   - Rareza
   - Estado de la carta
   - Precio base
   - Stock
   - ID_Location (para saber dónde está físicamente)
   - Imagen original
   - Descripción

2. Tabla de Diseños Predefinidos (Designs):
   - ID_Design
   - Nombre
   - Descripción
   - Imagen de muestra
   - Precio adicional
   - Complejidad
   - Tiempo estimado
   - Materiales necesarios

3. Tabla de Cartas Personalizadas (CustomizedCards):
   - ID_CustomCard
   - ID_Card (carta base)
   - ID_Design (si usa un diseño predefinido)
   - ID_Order
   - ID_Staff (artista)
   - Precio final
   - Estado del trabajo
   - Imagen del resultado final

¿Te parece adecuada esta estructura adicional? ¿Añadirías algún otro campo o tabla relacionada?

---

**Yo:** Vale, de momento para un planteamiento inicial está bien. Según vaya creando la base de datos te haré más recomendaciones sobre la estructura para ver si estás de acuerdo.

---

**Cliente:** ¡Perfecto! Me parece un buen enfoque ir desarrollando la estructura paso a paso. Así podremos:

1. Verificar que las relaciones entre tablas funcionan correctamente
2. Identificar posibles campos adicionales necesarios durante la implementación
3. Optimizar la estructura según surjan necesidades específicas
4. Asegurarnos de que la base de datos sea escalable
5. Detectar y corregir posibles redundancias o ineficiencias

Estaré atento a tus recomendaciones para ir refinando el diseño y asegurarme de que la base de datos cumpla con todas las necesidades del negocio, tanto actuales como futuras.

¿Por qué tabla te gustaría empezar a trabajar primero?

---

**Yo:** He estado trabajando en el diseño y tengo la siguientes entidades:

1.  **tipo_local**
    * id INT
    * nombre VARCHAR(25)
2.  **local**
    * id INT
    * tipo INT
    * direccion VARCHAR(100)
    * localidad VARCHAR(50)
    * email VARCHAR(100)
    * telefono VARCHAR(15)
3.  **empleados**
    * id INT
    * local_id INT
    * nombre VARCHAR(50)
    * apellidos VARCHAR(50)
    * dni VARCHAR(9)
    * email VARCHAR(100)
    * telefono VARCHAR(15)
    * fecha_contratacion DATE
    * salario DECIMAL(10, 2)
4.  **clientes**
    * id INT
    * nombre VARCHAR(50)
    * apellidos VARCHAR(50)
    * dni VARCHAR(9)
    * email VARCHAR(100)
    * telefono VARCHAR(15)
    * direccion VARCHAR(100)
    * localidad VARCHAR(50)
    * codigo_postal VARCHAR(10)
    * fecha_registro DATETIME
5.  **proveedores**
    * id INT
    * nombre_empresa VARCHAR(100)
    * persona_contacto VARCHAR(100)
    * telefono VARCHAR(15)
    * email VARCHAR(100)
    * direccion VARCHAR(100)
6.  **productos**
    * id INT
    * nombre VARCHAR(100)
    * descripcion TEXT
    * precio DECIMAL(10, 2)
    * stock INT
    * id_proveedor INT
7.  **estilos**
    * id INT
    * nombre VARCHAR(50)
8.  **formato**
    * id INT
    * nombre VARCHAR(50)
    * precio_adicional DECIMAL(10, 2)
9.  **estado_pedido**
    * id INT
    * nombre VARCHAR(50)
10. **metodos_pago**
    * id INT
    * nombre VARCHAR(50)
11. **pedidos**
    * id INT
    * id_cliente INT
    * fecha_pedido DATETIME
    * fecha_entrega DATE
    * id_estado INT
    * id_metodo_pago INT
    * total DECIMAL(10, 2)
12. **detalle_pedidos**
    * id INT
    * pedido_id INT
    * producto_id INT
    * estilo_id INT
    * formato_id INT
    * cantidad INT
    * precio_unitario DECIMAL(10, 2)
    * iva DECIMAL(5, 2)
    * descuento DECIMAL(5, 2)
13. **historial_pedidos**
    * id INT
    * pedido_id INT
    * fecha_registro DATETIME
    * estado_final INT
14. **seguimiento_pedidos**
    * id INT
    * pedido_id INT
    * fecha_registro DATETIME
    * estado_anterior VARCHAR(50)
    * estado_nuevo VARCHAR(50)

---

**Cliente:** El diseño que has desarrollado es muy completo y bien estructurado. Veo que has incluido varios aspectos importantes que no habíamos considerado inicialmente:

Aspectos positivos:
1. Buena normalización con tablas auxiliares para tipos (tipo_local, estilos, formato, estado_pedido, metodos_pago)
2. Seguimiento detallado de pedidos con historial_pedidos y seguimiento_pedidos
3. Gestión completa de empleados con datos laborales
4. Sistema de proveedores y productos
5. Gestión detallada de pedidos con IVA y descuentos
6. Separación clara entre pedidos y sus detalles

Sugerencias posibles:
1. ¿Has considerado añadir una tabla para horarios de locales?
2. ¿Sería útil una tabla para gestionar las especialidades de los empleados/artistas?
3. ¿Quizás una tabla para gestionar las imágenes de los trabajos realizados?
4. ¿Una tabla para valoraciones/feedback de clientes?

¿Qué opinas de estas sugerencias? ¿Hay algún aspecto específico que quieras revisar en detalle?

---

**Yo:** Esas sugerencias están muy bien y las valoraré para una mejora futura de la base de datos.

---

**Cliente:** Me parece una buena decisión dejar esas mejoras para más adelante. Es mejor empezar con una base sólida y funcional como la que has diseñado, y luego ir implementando mejoras según las necesidades reales del negocio.

La estructura actual ya permite:
1. Gestionar múltiples locales
2. Control completo de empleados
3. Seguimiento detallado de pedidos
4. Gestión de clientes y proveedores
5. Control de productos y estilos
6. Sistema de facturación básico

¿Quieres proceder con la implementación de esta estructura? ¿O prefieres revisar algún aspecto específico antes de comenzar con la creación de las tablas?

---

**Yo:** Ya tengo más o menos hecha la implementación pero vamos ello.

---

**Cliente:** Perfecto, entonces podemos revisar la implementación que tienes. 

Para implementar esta estructura, necesitaríamos:

1. Crear la base de datos
2. Crear las tablas en el orden correcto (primero las que no tienen dependencias)
3. Establecer las claves primarias y foráneas
4. Definir las restricciones necesarias
5. Verificar las relaciones entre tablas

¿Te gustaría que revisemos alguno de estos aspectos en particular? ¿O prefieres mostrarme tu implementación para analizarla juntos?

---

**Yo:** Este es el script que he creado: 

```sql
CREATE DATABASE IF NOT EXISTS card_customs DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

USE card_customs;

-- Creación de tablas
CREATE TABLE IF NOT EXISTS tipo_local (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS local (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo INT NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    localidad VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    FOREIGN KEY (tipo) REFERENCES tipo_local(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    local_id INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    dni VARCHAR(9) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    salario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (local_id) REFERENCES local(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    telefono VARCHAR(15)
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS etiquetas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL,
    descripcion VARCHAR(255) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS formato (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255),
    precio DECIMAL(10, 2) CHECK (precio >= 0) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    etiqueta_id INT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL CHECK (stock >= 0),
    FOREIGN KEY (etiqueta_id) REFERENCES etiquetas(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS estilos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS estado_pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS metodos_pago (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL,
    tasa DECIMAL(5, 2)
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    fecha_pedido DATETIME NOT NULL,
    estado_id INT NOT NULL DEFAULT 1,
    metodo_pago_id INT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (estado_id) REFERENCES estado_pedido(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (metodo_pago_id) REFERENCES metodos_pago(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS detalle_pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    estilo_id INT,
    formato_id INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10, 2) NOT NULL,
    iva DECIMAL(5, 2) NOT NULL DEFAULT 21.00,
    descuento DECIMAL(5, 2) NOT NULL DEFAULT 0,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (estilo_id) REFERENCES estilos(id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (formato_id) REFERENCES formato(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS historial_pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    fecha_registro DATETIME,
    estado_final INT NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS seguimiento_pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    fecha_registro DATETIME,
    estado_anterior VARCHAR(25),
    estado_nuevo VARCHAR(25) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
```

---

**Cliente:** El script está muy bien estructurado. Algunos aspectos positivos que noto:

1. Uso correcto de InnoDB y UTF8MB4
2. Definición apropiada de claves primarias y foráneas
3. Uso de restricciones CHECK para valores válidos
4. Buena gestión de las eliminaciones/actualizaciones en cascada

Sin embargo, hay algunos puntos que podrías considerar:

1. En la tabla clientes:
   - Falta el DNI que estaba en tu diseño original
   - Falta el código postal
   - Podrías añadir UNIQUE al email

2. En historial_pedidos y seguimiento_pedidos:
   - Falta la FOREIGN KEY para pedido_id
   - Podrías establecer un DEFAULT CURRENT_TIMESTAMP para fecha_registro

3. En la tabla pedidos:
   - Podrías añadir un DEFAULT CURRENT_TIMESTAMP para fecha_pedido
   - Falta el campo total que estaba en tu diseño original

4. En detalle_pedidos:
   - Podrías añadir CHECK para precio_unitario > 0
   - Podrías añadir CHECK para iva >= 0 y descuento >= 0

¿Te gustaría que te ayude a implementar alguna de estas sugerencias?

---

**Yo:** No hace falta, gracias. Al final he pensado lo siguiente:

- Los clientes ya no tendrán DNI, solo los empleados. (muchas veces el usuario no quiere poner tantos datos en una página web, por lo creo que será mejor si guardamos solo los datos necesarios)
- El código postal se ha añadido al campo dirección.
- En el historial no he añadido ninguna FOREIGN KEY ya que esa tabla sirve como un registro, por lo que si se borra la entrada referenciada, se borraría también de ahí.
- El campo total lo he añadido en una vista a modo de SELECT, ya que un campo total autocalculado que depende de atributos no clave en la misma tabla, no cumple con la 3FN de normalización de DDBB. 

Aquí te paso otra vez el script para ver si ya te satisface: (*le paso el script final*)

```sql
CREATE DATABASE IF NOT EXISTS card_customs DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

USE card_customs;

-- Creación de tablas
CREATE TABLE IF NOT EXISTS tipo_local (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS local (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo INT NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    localidad VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(15) NOT NULL,
    FOREIGN KEY (tipo) REFERENCES tipo_local(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS empleados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    local_id INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    dni VARCHAR(9) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    telefono VARCHAR(15) NOT NULL,
    fecha_contratacion DATE NOT NULL,
    salario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (local_id) REFERENCES local(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    direccion VARCHAR(100) NOT NULL,
    telefono VARCHAR(15)
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS etiquetas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL,
    descripcion VARCHAR(255) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS formato (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255),
    precio DECIMAL(10, 2) CHECK (precio >= 0) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    etiqueta_id INT,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL CHECK (stock >= 0),
    FOREIGN KEY (etiqueta_id) REFERENCES etiquetas(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS estilos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(255) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS estado_pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS metodos_pago (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL,
    tasa DECIMAL(5, 2)
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    fecha_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado_id INT NOT NULL DEFAULT 1,
    metodo_pago_id INT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (estado_id) REFERENCES estado_pedido(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (metodo_pago_id) REFERENCES metodos_pago(id) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS detalle_pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    estilo_id INT,
    formato_id INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10, 2) NOT NULL CHECK precio_unitario > 0,
    iva DECIMAL(5, 2) NOT NULL DEFAULT 21.00 CHECK iva > 0,
    descuento DECIMAL(5, 2) NOT NULL DEFAULT 0,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (estilo_id) REFERENCES estilos(id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (formato_id) REFERENCES formato(id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS historial_pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    fecha_registro DATETIME,
    estado_final INT NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

CREATE TABLE IF NOT EXISTS seguimiento_pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    fecha_registro DATETIME,
    estado_anterior VARCHAR(25),
    estado_nuevo VARCHAR(25) NOT NULL
) ENGINE InnoDB DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
```

---
**Cliente:** 
El script está mucho mejor y tus explicaciones tienen mucho sentido:

1. La eliminación del DNI para clientes es una decisión acertada para simplificar el registro web
2. La integración del código postal en el campo dirección simplifica la estructura
3. Tu explicación sobre el historial como registro histórico es correcta
4. Excelente observación sobre la 3FN respecto al campo total, mucho mejor manejarlo como una vista

Mejoras implementadas:
- UNIQUE en los emails
- DEFAULT CURRENT_TIMESTAMP en fecha_pedido
- CHECK constraints en precio_unitario e IVA
- Valores por defecto apropiados

¿Tienes pensado ya cómo vas a implementar la vista para calcular el total de los pedidos? Podría ser algo como:

```sql
CREATE VIEW vista_total_pedidos AS
SELECT 
    p.id,
    SUM(dp.cantidad * dp.precio_unitario * (1 + dp.iva/100) * (1 - dp.descuento/100)) as total
FROM pedidos p
JOIN detalle_pedidos dp ON p.id = dp.pedido_id
GROUP BY p.id;
```

¿Te parece adecuado este enfoque?

---

**Yo:** Si, está correcto.

---

**Cliente:** Perfecto. Entonces ya tienes una estructura de base de datos sólida y bien normalizada que:

1. Cumple con las necesidades actuales del negocio
2. Está preparada para expansión futura
3. Mantiene la integridad de los datos
4. Optimiza el almacenamiento
5. Facilita las consultas y el mantenimiento

Los siguientes pasos podrían ser:

1. Crear la vista que comentamos
2. Añadir datos de prueba
3. Crear índices adicionales si son necesarios
4. Implementar procedimientos almacenados para operaciones comunes
5. Establecer usuarios y permisos

¿Por cuál de estos aspectos te gustaría continuar?

---

**Yo:** Antes se me olvido preguntarte, puedes decirme los requisitos funcionales y no funcionales?

---

**Clientes:** Basándome en el contexto y la estructura de la base de datos, estos serían los requisitos:

Requisitos Funcionales:
1. Gestión de Clientes
   - Registrar nuevos clientes
   - Actualizar información de clientes
   - Consultar historial de pedidos por cliente

2. Gestión de Pedidos
   - Crear nuevos pedidos
   - Modificar estado de pedidos
   - Registrar detalles de personalización
   - Calcular precios totales
   - Seguimiento del estado del pedido

3. Gestión de Productos
   - Mantener inventario
   - Gestionar catálogo de productos
   - Control de stock
   - Asignar etiquetas a productos

4. Gestión de Personal
   - Registrar empleados
   - Asignar empleados a locales
   - Gestionar información laboral

5. Gestión de Locales
   - Administrar diferentes tipos de locales
   - Mantener información de contacto
   - Gestionar ubicaciones

Requisitos No Funcionales:
1. Rendimiento
   - Tiempo de respuesta rápido en consultas
   - Capacidad para manejar múltiples transacciones simultáneas

2. Seguridad
   - Protección de datos sensibles (DNI, salarios)
   - Control de acceso por roles
   - Registro de cambios en pedidos

3. Disponibilidad
   - Sistema operativo 24/7
   - Backup regular de datos

4. Escalabilidad
   - Capacidad para crecer con el negocio
   - Soporte para múltiples locales

5. Mantenibilidad
   - Estructura normalizada
   - Documentación clara
   - Facilidad de actualización

¿Te gustaría que profundice en alguno de estos aspectos?
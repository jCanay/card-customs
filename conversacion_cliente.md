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
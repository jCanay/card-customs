<!-- Posible nuevo nombre: CARD DESIGNS -->
# CARD CUSTOMS

Este proyecto se encarga de **crear y gestionar la base de datos** de una empresa de personalización de cartas. Con un enfoque en *Magic: The Gathering*, esta ofrece servicios de modificación y personalización a mano de cartas, transformándolas en arte coleccionables.

## 📦 Características Principales
- **Gestión de Inventario**: Agrega, edita y elimina productos.
- **Facturación y pedidos**: Gestión de pedidos con múltiples métodos de pago.
- **Análisis y monitorización**: Historial de facturación, ingresos, ventas, pagos, etc.
- **Autenticación Segura**: Control de usuarios para mayor seguridad de acceso y/o manipulación.

## 🚀 Tecnologías Utilizadas
> [!WARNING]
> Las tecnologías de Frontend todavía están no están implementadas en el proyecto. Los lenguajes presentados son una simple plantilla para desarrollar la página web.

### **Frontend (Cliente)**
- [React](https://reactjs.org/) con [Vite](https://vitejs.dev/)
- [TailwindCSS](https://tailwindcss.com/) para estilos

### **Backend (Servidor)**
- [Node.js](https://nodejs.org/) con [Express](https://expressjs.com/)
- [MySQL](https://www.mysql.com/) para la base de datos

### **Herramientas**
- [yEd Live](https://www.yworks.com/yed-live/) para diagramas

## 📂 Estructura del Proyecto

```
./
├── diseño/      
│   ├── modelo_conceptual/    # Imagenes del modelo conceptual de la BBDD
│   └── modelo_relacional/    # Imagenes del modelo relacional de la BBDD
│
├── instalacion/              # Script completo que inicializa la BBDD
│
├── scripts/                  # Creacion, inserción, consultas, etc
│
├── conversacion_cliente.md   # Conversación con el bot
```

<!-- ## 🛠️ Instalación y Configuración

### Instalar MySQL en diferentes OS

- #### Windows:
    https://dev.mysql.com/downloads/installer/
    
    ```sh
    winget install Oracle.MySQL
    ```
- #### Debian/Ubuntu:
   ```sh
   sudo apt update
   sudo apt install mysql-server
   ```
- #### AlmaLinux:
   ```sh
   sudo dnf install mysql-server
   ```
- #### OpenSUSE:
   ```sh
   sudo zypper install mysql
   ```

### Requisitos Previos
- [MySQL](https://www.mysql.com/) en ejecución
- [MySQL Workbech](https://dev.mysql.com/downloads/workbench/) o similar instalado
- 
### Pasos de Instalación

1. Clonar el repositorio:
   ```sh
   git clone https://github.com/jCanay/card-customs.git
   ```
2. Ejecutar script de instalacion en MySQL Workbench:
   ```sh
   cd instalacion/
   ``` -->

## 📅 Futuras mejoras

1. Establecer un sistema para gestionar las **compras internas a proovedores** que se realicen en la empresa.
2. Controlar de manera más detallada el **reparto de productos** desde los almacenes a las tiendas.
3. Agregar la posibilidad de tener **diferentes productos** (sin necesidad de ser sólo cartas).
4. Añadir códigos promocionales para descuentos.
5. Mejorar el manejo y control de pedidos.

> [!NOTE]
> El nombre del proyecto y de la empresa no es final y podría variar a lo largo del tiempo.

## 📜 Licencia
En este proyecto todavía no se ha determinado una licencia concreta. Por lo que, hasta el momento, **quedan reservados todos los derechos de uso, copia y distribución**.
A exclusíon de los **colaboradores** del proyecto, los cuáles, de no ser los propietarios, solo tendrán **derecho de uso**.
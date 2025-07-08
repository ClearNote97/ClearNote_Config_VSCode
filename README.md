"""
# 🧠 Mi Configuración Global para Visual Studio Code (ClearNote)

¡Hola! 👋

Gracias por visitar este repositorio. Aquí encontrarás una plantilla curada y funcional de configuración global para Visual Studio Code, pensada especialmente para:

- 🧪 Ciencia de datos en Python  
- 🐳 Trabajo profesional con Docker y Dev Containers  
- ⚙️ Flujo moderno con Git y control de versiones  
- ✍️ Buenas prácticas de legibilidad y edición

---

## 🎯 Propósito del repositorio

Este repositorio sirve como **base replicable, limpia y portable** para quienes desean trabajar exclusivamente desde entornos aislados usando Dev Containers, sin instalar dependencias en su sistema anfitrión (host).

Incluye:

- `settings.json` con configuraciones limpias y funcionales
- `extensions.txt` con las extensiones mínimas necesarias para el entorno global
- `setup.ps1` para aplicar la configuración en un nuevo equipo
- Archivo `.gitattributes` para normalizar saltos de línea entre sistemas operativos

---

## ⚙️ ¿Cómo usar esta configuración?

### 1. Clona este repositorio

git clone https://github.com/tu_usuario/ClearNote_Config_VSCode.git

cd ClearNote_Config_VSCode

### 2. Ejecuta el script de configuración (solo una vez por máquina)

Abre PowerShell como administrador y ejecuta:

Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

./setup.ps1

Este comando instalará todas las extensiones listadas y copiará los settings.json al entorno de usuario de VS Code.

> 🛑 Si recibes un error del tipo:
> Execution of scripts is disabled on this system, sigue las instrucciones anteriores con Set-ExecutionPolicy.

---

## ✅ Buenas prácticas que seguimos

- 🧩 Instalamos globalmente solo lo necesario para interactuar con Git y VS Code (no Python ni Jupyter).

- 📦 Las herramientas de desarrollo específicas (como formateadores o depuradores) viven dentro del contenedor.

- 🧼 Mantenemos VS Code en inglés y sin extensiones redundantes para mejorar rendimiento.

- 🔐 No usamos rutas personales ni tokens en settings.json.

- 🧱 Este repositorio sirve como punto de partida antes de iniciar cualquier entorno de trabajo basado en contenedores.

---

## 🛠 ¿Qué incluye?

| Tipo de recurso                   | Archivo         |
|-----------------------------------|-----------------|
| Configuración global              | `settings.json` |
| Lista de extensiones base         | `extensions.txt`|
| Script de instalación automatizada| `setup.ps1`     |
| Estandarización de saltos de línea| `.gitattributes`|

---

## 📬 ¿Quieres colaborar?

Si tienes mejoras, ideas o usas otras prácticas en tu flujo de trabajo, puedes:

- Abrir un issue

- Crear un pull request

- O escribirme directamente si quieres compartir ideas

---

## ⚖️ Licencia

Distribuido bajo licencia [MIT](https://opensource.org/license/MIT). Puedes copiar, modificar y reutilizar esta plantilla con total libertad.

**MSc. Nicolás Enrique Valencia Santiago**
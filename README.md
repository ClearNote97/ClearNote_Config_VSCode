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
- `extensions-core.txt` con las extensiones esenciales del entorno global
- `extensions-optional.txt` con extensiones opcionales (el script pregunta antes de instalarlas)
- `setup.sh` para aplicar la configuración en un equipo nuevo (Windows, Linux y macOS)
- `reset.sh` para borrar toda la configuración de VS Code y empezar de cero (con confirmación)
- Archivo `.gitattributes` para normalizar saltos de línea entre sistemas operativos

---

## ⚙️ ¿Cómo usar esta configuración?

### 1. Clona este repositorio

                            git clone https://github.com/tu_usuario/ClearNote_Config_VSCode.git

                            cd tu_ruta/ClearNote_Config_VSCode
---

### 2. Ejecuta el script de configuración (solo una vez por máquina)

El script es **un solo archivo portable** (`setup.sh`) que funciona en los tres sistemas:

- 🪟 **Windows:** ábrelo desde **Git Bash** (no desde PowerShell). Git Bash viene con la instalación de Git para Windows.
- 🐧 **Linux** y 🍎 **macOS:** ábrelo desde la terminal normal.

En cualquiera de los tres:

                            bash setup.sh

El script:

1. Instala las extensiones **esenciales** (`extensions-core.txt`).
2. Pregunta una por una si quieres instalar las **opcionales** (`extensions-optional.txt`).
3. Hace un **respaldo** de tu `settings.json` anterior antes de aplicar el nuevo (nunca pierdes tu configuración previa).

> 🛑 Si al ejecutar te dice que no encuentra el comando `code`, abre VS Code, presiona `Ctrl+Shift+P` y ejecuta:
> **Shell Command: Install 'code' command in PATH**.

---

## 🧼 ¿Cómo reiniciar toda la configuración desde cero?

Si quieres borrar **toda** la configuración previa de VS Code (settings, extensiones y caché) y arrancar limpio, usa el script dedicado:

                            bash reset.sh

> ⚠️ Esta acción es **irreversible**. El script te pedirá que escribas la palabra `BORRAR` en mayúsculas antes de eliminar nada. Detecta tu sistema operativo y borra las carpetas correctas en Windows, Linux o macOS.

Después de resetear, puedes volver a dejar todo listo con `bash setup.sh`.

---

## ✅ Buenas prácticas que seguimos

- 🧩 Instalamos globalmente solo lo necesario para interactuar con Git y con los contenedores (no Python ni Jupyter).

- 📦 Las herramientas de desarrollo específicas de cada lenguaje (formateadores, linters, depuradores) **viven dentro del contenedor**, en el `.devcontainer` de cada proyecto — no en esta configuración global.

- 🤖 No incluimos un asistente de IA como extensión base. Se recomienda trabajar con tu asistente de IA preferido según el proyecto, y no atarlo a la plantilla global.

- 🧼 Mantenemos VS Code en inglés y sin extensiones redundantes para mejorar rendimiento.

- 🔐 No usamos rutas personales ni tokens en `settings.json`.

- 🧱 Este repositorio sirve como punto de partida antes de iniciar cualquier entorno de trabajo basado en contenedores.

- ⚠️ Lección aprendida: Añadimos la línea siguiente en `settings.json` para evitar errores de montaje en Windows al usar contenedores:

                            "remote.containers.mountWaylandSocket": false

Esto previene errores silenciosos o advertencias al iniciar entornos `.devcontainer`, especialmente en Windows.
---

## 🛠 ¿Qué incluye?

| Tipo de recurso                     | Archivo                  |
|-------------------------------------|--------------------------|
| Configuración global                | `settings.json`          |
| Extensiones esenciales              | `extensions-core.txt`    |
| Extensiones opcionales              | `extensions-optional.txt`|
| Script de instalación (portable)    | `setup.sh`               |
| Script de reinicio total            | `reset.sh`               |
| Estandarización de saltos de línea  | `.gitattributes`         |

---

## 🧠 Lecciones aprendidas
Estas son las decisiones y descubrimientos que moldearon esta configuración:

- Evitar `ipykernel` y Jupyter preinstalados en configuraciones base para mantener imágenes ligeras y enfocadas.

- Usar **Ruff** como linter y formateador de Python. Ruff no vive en esta configuración global: se instala **dentro del `.devcontainer`** de cada proyecto Python (extensión `charliermarsh.ruff` + formateo al guardar), para no imponer herramientas de Python a proyectos que no lo son.

- Mantener `"jupyter.interactiveWindow.textEditor.executeSelection": true` incluso sin `ipykernel` en el host, para habilitar la interactividad (ejecutar selección de código) sin errores en cuanto el entorno lo soporte.

- Separar extensiones esenciales (`extensions-core.txt`) de las opcionales (`extensions-optional.txt`) para mantener el entorno limpio y modular, dejando que quien instala decida qué opcionales quiere.

- Un único `setup.sh` portable (Windows vía Git Bash, Linux y macOS) es más fácil de mantener que un script por sistema operativo.

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

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

                            cd tu_ruta/ClearNote_Config_VSCode
---

### 2. Ejecuta el script de configuración (solo una vez por máquina)

Abre PowerShell como administrador y ejecuta:

                            Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

                            ./setup.ps1

Este comando instalará todas las extensiones listadas y copiará los settings.json al entorno de usuario de VS Code.

> 🛑 Si recibes un error del tipo:
> Execution of scripts is disabled on this system, sigue las instrucciones anteriores con Set-ExecutionPolicy.

---

## 🧼 ¿Cómo reiniciar toda la configuración desde cero?
Abre PowerShell como administrador y ejecuta este bloque para limpiar toda la configuración previa de Visual Studio Code:

### Borra configuración del usuario
                            Remove-Item -Recurse -Force "$env:APPDATA\Code" -ErrorAction SilentlyContinue
                            Remove-Item -Recurse -Force "$env:USERPROFILE\.vscode" -ErrorAction SilentlyContinue

### Borra configuración local (incluye caché de extensiones, contenedores remotos, etc.)
                            Remove-Item -Recurse -Force "$env:LOCALAPPDATA\Programs\Microsoft VS Code" -ErrorAction SilentlyContinue
                            Remove-Item -Recurse -Force "$env:LOCALAPPDATA\Code" -ErrorAction SilentlyContinue
                            Remove-Item -Recurse -Force "$env:LOCALAPPDATA\Temp\*Code*" -ErrorAction SilentlyContinue
                            Remove-Item -Recurse -Force "$env:APPDATA\Code - Insiders" -ErrorAction SilentlyContinue

### Opcional: limpia posibles sobras de contenedores remotos
                            Remove-Item -Recurse -Force "$env:APPDATA\Code\User\globalStorage\ms-vscode-remote.remote-containers" -ErrorAction SilentlyContinue

---

## ✅ Buenas prácticas que seguimos

- 🧩 Instalamos globalmente solo lo necesario para interactuar con Git y VS Code (no Python ni Jupyter).

- 📦 Las herramientas de desarrollo específicas (como formateadores o depuradores) viven dentro del contenedor.

- 🧼 Mantenemos VS Code en inglés y sin extensiones redundantes para mejorar rendimiento.

- 🔐 No usamos rutas personales ni tokens en settings.json.

- 🧱 Este repositorio sirve como punto de partida antes de iniciar cualquier entorno de trabajo basado en contenedores.

- ⚠️ Lección aprendida: Añadimos la línea siguiente en los settings.json para evitar errores de montaje en Windows al usar contenedores:

                            "remote.containers.mountWaylandSocket": false

Esto previene errores silenciosos o advertencias al iniciar entornos .devcontainer, especialmente en Windows.
---

## 🛠 ¿Qué incluye?

| Tipo de recurso                   | Archivo         |
|-----------------------------------|-----------------|
| Configuración global              | `settings.json` |
| Lista de extensiones base         | `extensions.txt`|
| Script de instalación automatizada| `setup.ps1`     |
| Estandarización de saltos de línea| `.gitattributes`|

---

## 🧠 Lecciones aprendidas
Estas son las decisiones y descubrimientos que moldearon esta configuración:

- Evitar ipykernel y Jupyter preinstalados en configuraciones base para mantener imágenes ligeras y enfocadas.

- Añadir ms-python.black-formatter como extensión y configurar Black como formateador sin necesidad de instalarlo globalmente.

- Añadir "jupyter.interactiveWindow.textEditor.executeSelection": true incluso sin ipykernel, para habilitar la interactividad futura sin errores.

- Separar extensiones esenciales de las opcionales (como docker-compose o django) para mantener el entorno limpio y modular.

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
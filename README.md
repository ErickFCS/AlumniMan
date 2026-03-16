# AlumniMan - Gestión de Alumnos

Un script de automatización en Bash diseñado para procesar registros de alumnos, gestionar un entorno de archivos dinámico y realizar operaciones de filtrado y ordenamiento de datos.

## Status

![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macos-lightgrey)
![Shell](https://img.shields.io/badge/shell-bash-blue)

## Contexto del Proyecto

Este proyecto surge como un ejercicio práctico para el manejo de flujos de trabajo en sistemas Unix, consolidación de archivos y control de procesos en segundo plano.

- **[Descargar Consigna Completa (PDF)](./consigna.pdf)**

## TODOS

- [x] Definir estructura de directorios (`entrada`, `salida`, `procesado`).
- [x] Implementar lógica de consolidación de archivos `.txt`.
- [x] Desarrollar menú interactivo de 6 opciones.
- [x] Implementar flag de limpieza `-d` (borrado de entorno y kill de procesos).
- [x] Optimizar búsqueda por padrón mediante `grep`.

## ¿Por qué este proyecto?

El objetivo es fortalecer el dominio de herramientas de terminal y el manejo de variables de entorno, simulando un sistema real de procesamiento de datos académicos.

## Proceso de Uso

1. **Preparación:** Define la variable de ambiente `FILENAME`.
2. **Entorno:** Ejecuta la Opción 1 para crear las carpetas necesarias.
3. **Carga:** Coloca tus archivos `.txt` en la carpeta `entrada/`.
4. **Procesamiento:** Ejecuta la Opción 2 para unificar los datos en la carpeta `salida/`.
5. **Consulta:** Usa las opciones 3, 4 y 5 para visualizar la información.

## Instalación

No requiere instalación compleja. Simplemente clona el repositorio y asegúrate de tener permisos de ejecución:

```sh
git clone https://github.com/ErickFCS/AlumniMan.git
cd AlumniMan
chmod +x main.sh consolidar.sh
```

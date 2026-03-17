#set document(
  title: "Ejercicio Práctico Bash",
  author: "Erick Fernando Carvalho Sanchez",
  date: auto,
)

#set page(
  paper: "a4",
  margin: 2.5cm,
  numbering: "1",
  number-align: center,
)

// --- Configuración de Texto ---
#let baseFont = 11pt
#set text(
  font: "Georgia",
  size: baseFont,
  lang: "es",
  kerning: true,
  hyphenate: false,
)

#set par(justify: true, leading: 0.65em)
#show heading: set block(above: 1.5em, below: 1em)

// --- Título ---
#align(center)[
  #text(size: 22pt, weight: "bold", title()) \
  #line(length: 100%, stroke: 0.5pt + gray)
]

== Resumen
Se requiere el desarrollo de un script en *Bash* que proporcione un menú interactivo para realizar diversas operaciones de gestión de archivos en sistemas Linux o MacOS.

El script debe interactuar con una variable de entorno llamada `FILENAME` para determinar el nombre del archivo de registro y soportar parámetros opcionales para la limpieza del entorno.

== Opciones del Menú

+ *Crear entorno:* Crea el directorio `~/EPNro1` con la siguiente estructura de subdirectorios:
  - `entrada/`
  - `salida/`
  - `procesado/`

+ *Correr proceso:*
  Ejecuta en segundo plano (`background`) el script `consolidar.sh` ubicado en `EPNro1`.
  - *Lógica:* Concatena el contenido de cada archivo que entra en `entrada/` al final de `salida/$FILENAME.txt`.
  - *Post-procesamiento:* Tras la consolidación, mueve los archivos originales a `procesado/`.

+ *Listar alumnos:*
  Muestra el contenido de `salida/$FILENAME.txt` ordenado por número de padrón ascendentemente.

+ *Top 10 Notas:*
  Muestra los 10 registros con las calificaciones más altas basándose en el archivo consolidado.

+ *Buscar por padrón:*
  Solicita un número de padrón al usuario y filtra la información correspondiente desde el archivo de salida.

+ *Salir:*
  Finaliza la ejecución del programa.

---

=== Parámetro Especial `-d`
Si el script se invoca con el parámetro `-d`, deberá realizar una rutina de limpieza:
- Eliminar recursivamente el directorio `EPNro1`.
- Finalizar los procesos asociados que se estén ejecutando en segundo plano.

#pagebreak()

== Condiciones Técnicas
- *Archivos de entrada:* Cualquier nombre, pero extensión obligatoria `.txt`.
- *Formato de datos:* `Padrón Nombre Apellido Email Nota`.
- *Integridad:* No se requiere validación de formato; se asume que los padrones son únicos.
- *Entorno:* Exclusivamente Bash Shell.

== Ejemplo de Datos
#block(
  fill: luma(245),
  inset: 12pt,
  radius: 4pt,
  stroke: luma(200),
  width: 100%,
  [
    ```text
    100998 Pedro Valdéz pvaldez@fi.uba.ar 5
    89032 Carla Simone csimone@fi.uba.ar 7
    77542 Franco Lomba flomba@fi.uba.ar 10
    100223 Juana Pola jpola@fi.uba.ar 4
    122435 Lucia Fernandez lfernandez@fi.uba.ar 9
    95432 Martin Gomez mgomez@fi.uba.ar 6
    110443 Sofia Rincon srincon@fi.uba.ar 10
    88321 Alberto Rossi arossi@fi.uba.ar 3
    105678 Elena Torres etorres@fi.uba.ar 8
    92110 Ricardo Darin rdarin@fi.uba.ar 7
    115432 Marta Minujin mminujin@fi.uba.ar 9
    76543 Charly Garcia cgarcia@fi.uba.ar 10
    120987 Gustavo Cerati gcerati@fi.uba.ar 8
    100456 Luis Spinetta lspinetta@fi.uba.ar 7
    85432 Mercedes Sosa msosa@fi.uba.ar 9
    118765 Fito Paez fpaez@fi.uba.ar 6
    99432 Tini Stoessel tstoessel@fi.uba.ar 5
    102345 Manu Ginobili mginobili@fi.uba.ar 10
    113456 Lionel Messi lmessi@fi.uba.ar 10
    ```
  ],
)

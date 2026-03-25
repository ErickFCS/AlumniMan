#!/bin/bash

UBICACION_BASE_ENTORNO="$HOME"
NOMBRE_CARPETA_ENTORNO="EPNro1"
NOMBRE_CARPETA_ENTRADA="entrada"
NOMBRE_CARPETA_SALIDA="salida"
NOMBRE_CARPETA_PROCESADOS="procesado"

CONSOLIDAR_SH="
#!/bin/bash

while true; do
  for i in $UBICACION_BASE_ENTORNO/$NOMBRE_CARPETA_ENTORNO/$NOMBRE_CARPETA_ENTRADA/*.txt; do
    if [[ -f \"\$i\" ]] && ! fuser -s \"\$i\"; then
      cat \"\$i\" >> $UBICACION_BASE_ENTORNO/$NOMBRE_CARPETA_ENTORNO/$NOMBRE_CARPETA_SALIDA/\$FILENAME
      mv \"\$i\" $UBICACION_BASE_ENTORNO/$NOMBRE_CARPETA_ENTORNO/$NOMBRE_CARPETA_PROCESADOS/
    fi
  done
  sleep 5
done
"

MENSAJE_HELP="
  AlumniMan, made for Bash compliant shells.
  AlumniMan is copyrighted by ErickFCS.
  Licensed under BSD-3. See source distribution for detailed.
  copyright notices.

  Usage: AlumniMan [-d] [-h | --help]

  AlumniMan es un script que organiza el listado de alumnos a
        partir de un conjunto de archivos .txt en la carpeta $NOMBRE_CARPETA_ENTRADA.
        Combinandolos en un archivo nombrado en base a la variable
        FILENAME. Permite buscar y listar a los alumnos.
        Los archivos base tienen que tener en la siguiente forma:
        Legajo Nombre Apellido Email Nota
        Ej:
        122332 Juan Lopez jlopez@fi.uba.ar 8
        100998 Pedro Valdéz pvaldez@fi.uba.ar 5
        89032 Carla Simone csimone@fi.uba.ar 7
        77542 Franco Lomba flomba@fi.uba.ar 10
        100223 Juana Pola jpola@fi.uba.ar 4
        122435 Lucia Fernandez lfernandez@fi.uba.ar 9

        Flags:
        -d          Borrará todo el entorno creado en la carpeta $NOMBRE_CARPETA_ENTORNO
        y se matarán los procesos creados en background.
        -h, --help  Muestra este mensaje y termina.
"

MENSAJE_ATENCION_ELIMINACION_DE_ENTORNO='
  ¡ATENCION!
  Usted esta por eliminar todo el entorno creado por esta herramienta.
  Esto no tiene vuelta atras. Solo continue si entiende las implicaciones.
'

MENSAJE_MENU="
  Opción 1) Crear entorno.
    Crea un directorio en el "home" de tu usuario llamado "$NOMBRE_CARPETA_ENTORNO". Y dentro de este tres carpetas, una llamada "$NOMBRE_CARPETA_ENTRADA", otra llamada "$NOMBRE_CARPETA_SALIDA", y otra llamada "$NOMBRE_CARPETA_PROCESADOS".

  Opción 2) Correr proceso.
    Inicia un proceso de fondo que toma cada archivo en la carpeta "$NOMBRE_CARPETA_ENTRADA", adjunta sus contenidos al archivo $FILENAME, y lo mueve a la carpeta "$NOMBRE_CARPETA_PROCESADOS".

  Opción 3) Listar Alumnos.
    Muestra el listado de alumnos ordenados por número de padrón.

  Opción 4) Listar Notas más altas.
    Muestra el listado de los 10 alumnos con las notas más altas.

  Opción 5) Buscar por padrón.
    Busca los datos de un alumno por número de padrón.

  Opción 6) Salir.
    Termina el programa dejando todo el entorno y datos como están.
"

success() {
  # \x1b[92m es el código ansii para el color VERDE claro.
  # \x1b[0m es el código ansii para volver al default.
  echo -e "\x1b[92m$1\x1b[0m"
}

warn() {
  # \x1b[93m es el código ansii para el color AMARILLO claro.
  # \x1b[0m es el código ansii para volver al default.
  echo -e "\x1b[93m$1\x1b[0m"
}

error() {
  # \x1b[91m es el código ansii para el color ROJO claro.
  # \x1b[0m es el código ansii para volver al default.
  echo -e "\x1b[91m$1\x1b[0m"
}

entorno_existe() {
  if [[ !( -d $UBICACION_BASE_ENTORNO/$NOMBRE_CARPETA_ENTORNO && -d $UBICACION_BASE_ENTORNO/$NOMBRE_CARPETA_ENTORNO/$NOMBRE_CARPETA_ENTRADA && -d $UBICACION_BASE_ENTORNO/$NOMBRE_CARPETA_ENTORNO/$NOMBRE_CARPETA_SALIDA && -d $UBICACION_BASE_ENTORNO/$NOMBRE_CARPETA_ENTORNO/$NOMBRE_CARPETA_PROCESADOS  ) ]]; then
    error "Entorno corrupto o no iniciado. Intente correr primero la opción 1."
    warn "Si el problema persiste contacte con soporte."

    return 1
  fi

  return 0
}

FILENAME_existe_y_no_esta_vacio() {
  if [[ ! -s $UBICACION_BASE_ENTORNO/$NOMBRE_CARPETA_ENTORNO/$NOMBRE_CARPETA_SALIDA/$FILENAME ]]; then
    error "El archivo $FILENAME todavia no existe o esta vacio."
    warn 'Asegúrece de:
    haber creado el entorno con la opción 1
    haber agregado archivos a la carpeta $NOMBRE_CARPETA_ENTRADA
    haber iniciado el processo de fondo con la opción 2'
    warn "En caso de que el problema persista, contacte con soporte."

    return 1
  fi

  return 0
}

crear_entorno() {
  echo "Creando la carpeta $NOMBRE_CARPETA_ENTORNO si no existe."
  echo "Creando la carpeta $NOMBRE_CARPETA_ENTRADA si no existe."
  mkdir -p $UBICACION_BASE_ENTORNO/$NOMBRE_CARPETA_ENTORNO/$NOMBRE_CARPETA_ENTRADA
  echo "Creando la carpeta $NOMBRE_CARPETA_SALIDA si no existe."
  mkdir -p $UBICACION_BASE_ENTORNO/$NOMBRE_CARPETA_ENTORNO/$NOMBRE_CARPETA_SALIDA
  echo "Creando la carpeta $NOMBRE_CARPETA_PROCESADOS si no existe."
  mkdir -p $UBICACION_BASE_ENTORNO/$NOMBRE_CARPETA_ENTORNO/$NOMBRE_CARPETA_PROCESADOS
  echo ""
  success "El entorno fue creado."
}

correr_proceso() {
  if [[ ! -e $UBICACION_BASE_ENTORNO/$NOMBRE_CARPETA_ENTORNO/consolidar.sh ]]; then
    warn "El script consolidar.sh no se encuentra en la carpeta $NOMBRE_CARPETA_ENTORNO."
    echo "Creando script consolidar.sh."
    echo "$CONSOLIDAR_SH" > $UBICACION_BASE_ENTORNO/$NOMBRE_CARPETA_ENTORNO/consolidar.sh
    chmod +x $UBICACION_BASE_ENTORNO/$NOMBRE_CARPETA_ENTORNO/consolidar.sh
    success "Script consolidar.sh creado."
  fi

  if pgrep -f "consolidar.sh" > /dev/null 2>&1; then
    warn "Hay procesos iniciados."
    warn "Terminando los procesos para reiniciar."
    CANTIDAD_DE_PROCESOS=$(pkill -c -f consolidar.sh)
    success "Los $CANTIDAD_DE_PROCESOS procesos que habían fueron terminados."
  fi

  echo "Ejecutando de fondo el script consolidar.sh."
  nohup bash -c "FILENAME=$FILENAME $UBICACION_BASE_ENTORNO/$NOMBRE_CARPETA_ENTORNO/consolidar.sh" > /dev/null 2>&1 &
  success "Proceso de fondo iniciado."
}

listar_alumnos() {
  sort -h $UBICACION_BASE_ENTORNO/$NOMBRE_CARPETA_ENTORNO/$NOMBRE_CARPETA_SALIDA/$FILENAME
}

listar_alumnos_con_notas_mas_altas() {
  sort --field-separator=" " --key=5,5nr $UBICACION_BASE_ENTORNO/$NOMBRE_CARPETA_ENTORNO/$NOMBRE_CARPETA_SALIDA/$FILENAME | head -n 10
}

buscar_por_padron() {
  if [[ -z "$1" ]]; then
    error "No se ingreso ningún dato."
  elif ! grep "^$1 " $UBICACION_BASE_ENTORNO/$NOMBRE_CARPETA_ENTORNO/$NOMBRE_CARPETA_SALIDA/$FILENAME; then
    error "El numero de padrón $1 no se encuentra registrado."
  fi
}

case "$1" in
  "-h" | "--help")

    echo "$MENSAJE_HELP"
    ;;

  "-d" | "--destroy") # Aquí asumi que -d es de --destroy por lo que lo agregue

    warn "$MENSAJE_ATENCION_ELIMINACION_DE_ENTORNO"
    read -p "Desea continuar? Solo \"si\" sera aceptado como afirmativo: " confirma
    echo ""

    if [[ $confirma == "si" ]]; then
      CANTIDAD_DE_PROCESOS=$(pkill -c -f consolidar.sh)
      success "Los $CANTIDAD_DE_PROCESOS procesos que habían fueron terminados."
      rm -fr $UBICACION_BASE_ENTORNO/$NOMBRE_CARPETA_ENTORNO/
      success "El entorno fue eliminado."

    else
      warn "La operacion fue cancelada."
    fi
    ;;

  *)

    if [[ -z "$FILENAME" ]]; then
      warn "La variable de entorno FILENAME no fue definida o esta vacía."
      warn "El valor \"Alumnos.txt\" sera usado."
      FILENAME=${FILENAME:-"Alumnos.txt"}
    fi

    SALIENDO=false

    while [[ $SALIENDO == false ]]; do

      echo "$MENSAJE_MENU"

      CANTIDAD_DE_PROCESOS=$(pgrep -fc "consolidar.sh")
      success "Hay $CANTIDAD_DE_PROCESOS procesos activos"
      echo ""
      read -p "Numero de opción elegida: " opt

      echo ""
      echo "Opción \"$opt\" seleccionada."
      echo ""

      case "$opt" in
        "1")

          crear_entorno
          ;;

        "2")

          if entorno_existe; then
            correr_proceso
          fi
          ;;

        "3")

          if entorno_existe && \
            FILENAME_existe_y_no_esta_vacio; then
            listar_alumnos
          fi

          echo ""
          read -p "Presione enter para continuar."
          ;;

        "4")

          if entorno_existe && \
            FILENAME_existe_y_no_esta_vacio; then
            listar_alumnos_con_notas_mas_altas
          fi

          echo ""
          read -p "Presione enter para continuar."
          ;;

        "5")

          if entorno_existe && \
            FILENAME_existe_y_no_esta_vacio; then
            read -p "Ingrese su numero de padrón: " numPadron
            buscar_por_padron $numPadron
          fi

          echo ""
          read -p "Presione enter para continuar."
          ;;

        "6")

          echo "Saliendo."
          SALIENDO=true
          ;;

        *)

          error "Opción invalida, revise su elección."
          ;;
      esac
    done
    ;;
esac

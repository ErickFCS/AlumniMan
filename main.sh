#!/bin/bash

FILENAME=${FILENAME:-"numbredearchivo.txt"}
SALIENDO=false

CONSOLIDAR_SH='
#!/bin/bash

echo "Ejecución iniciada."

for i in $HOME/EPNro1/entrada/*.txt; do
if [[ -f "$i" ]]; then
cat "$i" >> $HOME/EPNro1/salida/$FILENAME
mv "$i" $HOME/EPNro1/procesado/
else
echo "No hay archivos que procesar."
fi
done

echo "Ejecución finalizada."
'

MENSAJE_HELP='
  erick@desktop:$HOME/Downloads/TP0$ busybox --help
  AlumniMan, made for Bash compliant shells.
  AlumniMan is copyrighted by ErickFCS.
  Licensed under BSD-3. See source distribution for detailed.
  copyright notices.

  Usage: AlumniMan [-d] [-h | --help]

  AlumniMan es un script que organiza el listado de alumnos a 
        partir de un conjunto de archivos .txt en la carpeta entrada.
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
        -d          Borrará todo el entorno creado en la carpeta EPNro1
        y se matarán los procesos creados en background.
        -h, --help  Muestra este mensaje y termina.
'

MENSAJE_ATENCION_ELIMINACION_DE_ENTORNO='
  ¡ATENCION!
  Usted esta por eliminar todo el entorno creado por esta herramienta.
  Esto no tiene vuelta atras. Solo continue si entiende las implicaciones.
'

MENSAJE_MENU='
  Opción 1) Crear entorno.
  Crea un directorio en el "home" de tu usuario llamado "EPNro1". Y dentro de este tres carpetas, una llamada "entrada", otra llamada "salida", y otra llamada "procesado".

  Opción 2) Correr proceso.
  Inicia un proceso de fondo que toma cada archivo en la carpeta "entrada", adjunta sus contenidos al archivo $FILENAME, y lo mueve a la carpeta "procesado".

  Opción 3) Listar Alumnos.
  Muestra el listado de alumnos ordenados por número de padrón.

  Opción 4) Listar Notas más altas.
  Muestra el listado de los 10 alumnos con las notas más altas.

  Opción 5) Buscar por padrón.
  Busca los datos de un alumno por número de padrón.

  Opción 6) Salir.
  Termina el programa dejando todo el entorno y datos como están.
'

entorno_existe() {
  if [[ !( -d $HOME/EPNro1 && -d $HOME/EPNro1/entrada && -d $HOME/EPNro1/salida && -d $HOME/EPNro1/procesado  ) ]]; then
    echo "Entorno corrupto o no iniciado. Intente correr primero la opción 1."
    echo "Si el problema persiste contacte con soporte."
    return 1
  fi
  return 0
}

FILENAME_existe_y_no_esta_vacio() {
  if [[ ! -s $HOME/EPNro1/salida/$FILENAME ]]; then
    echo "El archivo $FILENAME todavia no existe o esta vacio."
    return 1
  fi
  return 0
}

crear_entorno() {
  echo "Creando la carpeta EPNro1 si no existe."
  echo "Creando la carpeta entrada si no existe."
  mkdir -p $HOME/EPNro1/entrada
  echo "Creando la carpeta salida si no existe."
  mkdir -p $HOME/EPNro1/salida
  echo "Creando la carpeta procesado si no existe."
  mkdir -p $HOME/EPNro1/procesado
}

correr_proceso() {
  if [[ ! -e $HOME/EPNro1/consolidar.sh ]]; then
    echo "El script consolidar.sh no se encuentra en la carpeta EPNro1."
    echo "Creando script consolidar.sh."
    echo "$CONSOLIDAR_SH" > $HOME/EPNro1/consolidar.sh
    chmod +x $HOME/EPNro1/consolidar.sh
  fi
  echo "Ejecutando de fondo el script consolidar.sh."
  FILENAME=$FILENAME $HOME/EPNro1/consolidar.sh &
}

listar_alumnos() {
  sort -h $HOME/EPNro1/salida/$FILENAME
}

listar_alumnos_con_notas_mas_altas() {
  sort --field-separator=" " --key=5,5nr $HOME/EPNro1/salida/$FILENAME | head -n 10
}

buscar_por_padron() {
  if [[ -z "$numPadron" ]]; then
    echo "No se ingreso ningún dato."
  elif ! grep "^$numPadron " $HOME/EPNro1/salida/$FILENAME; then
    echo "El numero de padrón $numPadron no se encuentra registrado."
  fi
}

case "$1" in
  "-h" | "--help")
    echo "$MENSAJE_HELP"
    ;;
  "-d" | "--destroy")
    echo "$MENSAJE_ATENCION_ELIMINACION_DE_ENTORNO"
    read -p "Desea continuar? Solo \"si\" sera aceptado como afirmativo: " confirma
    echo ""

    if [[ $confirma == "si" ]]; then
      rm -fr $HOME/EPNro1/
      echo "El entorno fue eliminado."
      pkill -f consolidar.sh
      echo "Los procesos fueron terminados."

    else
      echo "La operacion fue cancelada."
    fi
    ;;
  *)
    while [[ $SALIENDO == false ]]; do
      echo "$MENSAJE_MENU"
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
          echo "Opción invalida, revise su elección."
          ;;
      esac
    done
    ;;
esac

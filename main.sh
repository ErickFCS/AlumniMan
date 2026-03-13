#!/bin/bash

FILENAME="numbredearchivo.txt"
SALIENDO=false

verificar_existencia_de_entorno() {
  if [[ !( -d ~/EPNro1 && -d ~/EPNro1/entrada && -d ~/EPNro1/salida && -d ~/EPNro1/procesado  ) ]]; then
    echo "Entorno corrupto o no iniciado. Intente correr primero la opción 1."
    echo "Si el problema persiste contacte con soporte."
    return 1
  fi
}

verificar_existencia_y_contenido_del_archivo_FILENAME() {
  if [[ ! -s ~/EPNro1/salida/$FILENAME ]]; then
    echo "El archivo $FILENAME todavia no existe o esta vacio"
    return 1
  fi
}

if [[ $1 == "-h" || $1 == "--help" ]]; then
  cat << \
EOF
erick@desktop:~/Downloads/TP0$ busybox --help
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
EOF


elif [[ $1 == "-d" ]]; then
  cat << EOF

¡ATENCION!
Usted esta por eliminar todo el entorno creado por esta herramienta.
Esto no tiene vuelta atras. Solo continue si entiende las implicaciones.

EOF
  read -p "Desea continuar? Solo \"si\" sera aceptado como afirmativo: " confirma
  if [[ $confirma == "si" ]]; then
    rm -fr ~/EPNro1/
    echo "El entorno fue eliminado."
    pkill -f consolidar.sh
    echo "Los procesos fueron terminados."
  else
    echo "La operacion fue cancelada"
  fi


else
  while [[ $SALIENDO == false ]]; do
    cat << \
EOF

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

EOF

    read -p "Numero de opción elegida: " opt

    echo "Opción $opt seleccionada."

    case "$opt" in
      "1")
        echo "Creando la carpeta EPNro1 si no existe"
        echo "Creando la carpeta entrada si no existe"
        mkdir -p ~/EPNro1/entrada
        echo "Creando la carpeta salida si no existe"
        mkdir -p ~/EPNro1/salida
        echo "Creando la carpeta procesado si no existe"
        mkdir -p ~/EPNro1/procesado
        ;;
      "2")
        if verificar_existencia_de_entorno; then
          if [[ ! -e ~/EPNro1/consolidar.sh ]]; then
            echo "El script consolidar.sh no se encuentra en la carpeta EPNro1."
            echo "Creando script consolidar.sh."
            cat > ~/EPNro1/consolidar.sh << \
'EOF'
#!/bin/bash

echo "Ejecución iniciada."

for i in ~/EPNro1/entrada/*.txt; do
  if [[ -f "$i" ]]; then
    cat "$i" >> ~/EPNro1/salida/$FILENAME
    mv "$i" ~/EPNro1/procesado/
  else
    echo "No hay archivos que procesar"
  fi
done

echo "Ejecución finalizada."

EOF
          chmod +x ~/EPNro1/consolidar.sh
          fi
          echo "Ejecutando de fondo el script consolidar.sh"
          FILENAME=$FILENAME ~/EPNro1/consolidar.sh &
        fi
        ;;
      "3")
        if verificar_existencia_de_entorno; then
          if verificar_existencia_y_contenido_del_archivo_FILENAME; then
            sort -h ~/EPNro1/salida/$FILENAME
            read -p "Presione enter para continuar"
          fi
        fi
        ;;
      "4")
        if verificar_existencia_de_entorno; then
          if verificar_existencia_y_contenido_del_archivo_FILENAME; then
            sort --field-separator=" " --key=5,5n --reverse ~/EPNro1/salida/$FILENAME | head -n 10
            read -p "Presione enter para continuar"
          fi
        fi
        ;;
      "5")
        if verificar_existencia_de_entorno; then
          if verificar_existencia_y_contenido_del_archivo_FILENAME; then
            read -p "Ingrese su numero de padrón: " numPadron
            if ! grep $numPadron ~/EPNro1/salida/$FILENAME; then
              echo "El numero de padrón $numPadron no se encuentra registrado"
            fi
            read -p "Presione enter para continuar"
          fi
        fi
        ;;
      "6")
        echo "Saliendo"
        SALIENDO=true
        ;;
      *)
        echo "Opción invalida, revise su elección."
        ;;
    esac

  done
fi

#!/bin/bash

FILENAME="numbredearchivo.txt"

verificar_existencia_de_entorno() {
  if [[ !( -d ~/EPNro1 && -d ~/EPNro1/entrada && -d ~/EPNro1/salida && -d ~/EPNro1/procesado  ) ]]; then
    echo "Entorno corrupto o no iniciado. Intente correr primero la opción 1."
    echo "Si el problema persiste contacte con sopote."
    return 1
  fi
}

cat << EOF

Bienvenido al programa de del TP0 de introduccion al desarrollo de software

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

read -p "Numero de opción elegída: " opt

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
        echo "El script consolidar.sh no se encuentra en la carpera EPNro1"
        echo "Creando script consolidar.sh"
        cat > ~/EPNro1/consolidar.sh << \
EOF
#!/bin/bash

echo "Ejecución iniciada."

for i in ~/EPNro1/entrada/*.txt; do
  cat $i >> ~/EPNro1/salida/$FILENAME
  mv $i ~/EPNro1/procesado/
done

echo "Ejecución finalizada."

EOF
      chmod +x ~/EPNro1/consolidar.sh
      fi
      echo "Ejecutando de fondo el script consolidar.sh"
      ~/EPNro1/consolidar.sh &
    fi
    ;;
  "3")
    if verificar_existencia_de_entorno; then
      if [[ -e ~/EPNro1/salida/$FILENAME ]]; then
        sort -h ~/EPNro1/salida/$FILENAME
      else
        echo ""
      fi
    fi
    ;;
  "4")
    if verificar_existencia_de_entorno; then
      if [[ -e ~/EPNro1/salida/$FILENAME ]]; then
        sort --field-separator=" " --key=4n ~/EPNro1/salida/$FILENAME | head -c 10
      fi
    fi
    ;;
  "5")
    if verificar_existencia_de_entorno; then
      if [[ -e ~/EPNro1/salida/$FILENAME ]]; then
        read -p "Ingrese su numero de padrón: " numPadron
        if ! grep $numPadron ~/EPNro1/salida/$FILENAME; then
          echo "El numero de padrón $numPadron no se encuentra registrado"
        else
          grep $numPadron ~/EPNro1/salida/$FILENAME
        fi
      fi
    fi
    ;;
  "6")
    echo "Saliendo"
    ;;
  *)
    echo "Opción invalida, revise su elección."
    ;;
esac

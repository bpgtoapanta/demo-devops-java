#!/bin/bash

set -e

USO="Uso : create_codepipeline.sh [opciones]
El archivo debe conetener el siguiente formato de variables'
Ejemplo de contenido:  config_pipeline.ini
  repository_name=devsu_practica
Ejemplo de ejecucion: bash destroy_codepipeline.sh -f config_pipeline.ini
"

function ayuda() {
  echo "${USO}"
  if [[ ${1} ]]; then
    echo ${1}
  fi
}

# Validate arguments
while getopts ":f:a" OPCION; do
  case ${OPCION} in
  f)
    NOMBRE_ARCHIVO_CONFIG=$OPTARG
    if [ -f "$NOMBRE_ARCHIVO_CONFIG" ]; then
      # load the variables defined in the file config.ini
      source ${NOMBRE_ARCHIVO_CONFIG}
      # get and assign the value to the variables obtained in the file config.ini
      REPOSITORY_NAME=${repository_name//$'\r'/}
    else
      ayuda "Error, el archivo '${NOMBRE_ARCHIVO_CONFIG}' no existe"
      exit 1
    fi
    ;;
  a)
    ayuda
    exit 0
    ;;
  :)
    ayuda "Falta el parametro para -$OPTARG"
    exit 1
    ;;
  \?)
    ayuda "La opcion no existe : $OPTARG"
    exit 1
    ;;
  esac
done

export TF_VAR_app_name_repository=""

if [ -z ${REPOSITORY_NAME} ]; then
  ayuda "La variable del nomnbre de repositorio (repository_name) debe ser especificada en el archivo '${NOMBRE_ARCHIVO_CONFIG}'"
  exit 1
fi

cd infraestructure_terraform
export TF_VAR_app_name_repository=${REPOSITORY_NAME}

terraform init 
terraform destroy -auto-approve
if [[ $? -eq 0 ]]; then
  echo "***** terraform destroy completo *******"
else
  echo "ERROR --> Terraform destroy no se completo"
fi

exit 0

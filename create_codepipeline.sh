#!/bin/bash

set -e

USO="Uso : create_codepipeline.sh [opciones]
El archivo debe conetener el siguiente formato de variables'
Ejemplo de contenido:  config_pipeline.ini
  repository_name=devsu_practica
  github_oauth_token=......
  github_owner=bpgtoapanta
  bucket_name_demo=devsu-practica-bt-bucket
  account_aws=xxxxx
Ejemplo de ejecucion: bash create_codepipeline.sh -f config_pipeline.ini
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
      GITHUB_TOKEN=${github_oauth_token//$'\r'/}
      GITHUB_OWNER=${github_owner//$'\r'/}
      BUCKET_NAME=${bucket_name_demo//$'\r'/}
      ACCOUNT_AWS=${account_aws//$'\r'/}
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
export TF_VAR_github_oauth_token=""

# validation of the variables obtained
if [ -z ${REPOSITORY_NAME} ]; then
  ayuda "La variable del nomnbre de repositorio (repository_name) debe ser especificada en el archivo '${NOMBRE_ARCHIVO_CONFIG}'"
  exit 1
fi
if [ -z ${GITHUB_TOKEN} ]; then
  ayuda "El token de Github (github_oauth_token) debe ser especificada en el archivo '${NOMBRE_ARCHIVO_CONFIG}'"
  exit 1
fi

if [ -z ${GITHUB_OWNER} ]; then
  ayuda "El owner de Github (github_owner) debe ser especificada en el archivo '${NOMBRE_ARCHIVO_CONFIG}'"
  exit 1
fi

if [ -z ${BUCKET_NAME} ]; then
  ayuda "El nombre del bucket (bucket_name_demo) debe ser especificada en el archivo '${NOMBRE_ARCHIVO_CONFIG}'"
  exit 1
fi

if [ -z ${ACCOUNT_AWS} ]; then
  ayuda "El cuenta aws (account_aws) debe ser especificada en el archivo '${NOMBRE_ARCHIVO_CONFIG}'"
  exit 1
fi

cd infraestructure_terraform
## terraform variable mapping
export TF_VAR_app_name_repository=${REPOSITORY_NAME}
export TF_VAR_github_oauth_token=${GITHUB_TOKEN}
export TF_VAR_owner_github=${GITHUB_OWNER}
export TF_VAR_bucket_name_demo=${BUCKET_NAME}
export TF_VAR_account_aws=${ACCOUNT_AWS}

## terraform execution
terraform init
if [[ $? -eq 0 ]]; then
  echo "***** terraform init correcto *******"
  terraform plan
  if [[ $? -eq 0 ]]; then
    echo "***** terraform plan correcto *******"
    terraform apply -auto-approve
    if [[ $? -eq 0 ]]; then
      echo "***** terraform apply correcto *******"
    else
      echo "ERROR --> fallo la creacion de terraform"
    fi
  else
    echo "ERROR --> La salida de la creacion de Terraform tiene errores, el archivo no es valido"
  fi
else
  echo "****ERROR --> Terraform init no se pudo iniciar"
fi
exit 0

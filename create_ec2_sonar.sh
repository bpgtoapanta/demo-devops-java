
#!/bin/bash

cd ec2_sonar_terraform
terraform init
if [[ $? -eq 0 ]]; then 
  echo "***** terraform init correcto *******"
  terraform plan
  if [[ $? -eq 0 ]]; then 
     echo "***** terraform plan correcto *******"
     terraform apply
       if [[ $? -eq 0 ]]; then 
          echo "***** terraform plan correcto *******"
       else 
        echo "ERROR --> fallo la creacion de terraform"
      fi     
   else 
    echo "ERROR --> La salida de la creacion de Terraform tiene errores, el archivo no es valido"
  fi
else 
echo "ERROR --> Terraform no se pudo iniciar"
fi



#!/bin/bash

cd ec2_sonar_terraform
terraform destroy
if [[ $? -eq 0 ]]; then 
  echo "***** terraform destroy completo *******"
else 
echo "ERROR --> Terraform destroy no se completo"
fi


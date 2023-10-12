# Practica DEVOPS
## Resolución del ejercicio practico

Para la resolución de este ejercicio se tomó el proyecto https://bitbucket.org/devsu/demo-devops-java/src/master/
Este repositorio una vez clonado se lo sube en una cuenta personal como parte de la resolución de esta practica
https://github.com/bpgtoapanta/demo-devops-java

Se usó las siguientes tecnologías para la resolución

- Docker (Construcción de imágenes)
- AWS (Codepipeline, codebuild, eks, ecr, ec2)
- Terraform (IaC creación de infraestructura en AWS)
- Kubernetes
- SonarQube (Análisis de código)

## Diagrama de la solución

![](https://github.com/bpgtoapanta/demo-devops-java/blob/main/images/demo_devops_drawio.png)

## Puntos de resolución

## Docker

Se realizó un archivo dockerfile, el cual contiene la definición para dockerizar la imagen con el artefacto de distribución del proyecto y los comandos necesarios para la ejecución, se agrega también un healtcheck para conocer el estado de un contenedor con la imagen desplegada.

## AWS 

Se elige la nube de AWS para la implementación de toda la solución, así como también infraestructura necesaria para la construcción y el despliegue de la aplicación

## Terraform

Se usa Terraform para la creación de la infraestructura como IaC, en esta definición se usa el provider de AWS. En este punto de crea mediante Terraform los siguientes componentes:
- Codepipeline - Pipeline de despliegue que contiene las etapas que se define en la practica
- Codebuild - Servidores de compilación necesarios para la ejecución de comandos necesarios del CI/CD
- EKS - Infraestructura para alojar el despliegue de la aplicación
- ECR - Registry para almacenar la imagen construida necesaria para el despliegue
- EC2 - Se crea una instancia para esta práctica con el fin de alojar SonarQube para integrar con la solución del pipeline con respecto a los test al código.

## Kubernetes

Para esta práctica se usa un ReplicaSet para garantiza que un número específico de réplicas de un pod, adicional a esto se crea un Service de tipo LoadBalancer el cual permita exponer la aplicación a internet, para esto previamente se crea la infraestructura con Terraform para este punto se usa los módulos de https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest

## SonarQube

Se hizo una integración al pipeline con SonarQube para el análisis de código estático y en análisis de cobertura del código. Para esto se pensó en crear una instancia donde aloje la instalación de SonarQube y posterior a esto se integre con el codepipeline.

## Ejecución de IaC 

Previo a esta actividad se deberá tomar en cuenta poseer un usuario de la nube de aws que tenga acceso programático

# Exportar tus credenciales como variables de entorno:
```
AWS
Linux
export TF_VAR_aws_access_key={{*******}}
export TF_VAR_aws_secret_key={{*****}}
```

# Crear EC2 sonar 
Para la crear la infraestructura de ec2 que contiene la instancia con la instalación de sonar ejecute el siguiente archivo.
```
create_ec2_sonar.sh
```

# Crear Codepipeline 
Pre requisitos 
Tener la configuración previa de sonar y la instancia encendida

Pre requisito para crear el pipeline del frontend editar el archivo config_pipeline_frontend.ini-- Ejemplo 
```
repository_name=<nombre del repositorio>
github_oauth_token=<token de la cuenta github con permisos de lectura y escritura de repositorio>
github_owner=<owner de la cuenta de Github>
bucket_name_demo=<nombre del bucket para almacenar artefactos propios de la generacion del pipeline>
```
Para la crear la infraestructura de codepipeline ejecute el siguiente archivo
```
bash create_codepipeline_frontend.sh -f config_pipeline_frontend.ini
```
# Destruir Codepipeline frontend
Para la destruir la infraestructura de codepipeline ejecute el siguiente archivo
```
bash destroy_codepipeline_frontend.sh -f config_pipeline_frontend.ini
```

# Problemas al Despliegue
Por un tema de permisos por el configmap de aws-auth se tuvo que ejecutar una actividad manual luego del despliegue de la IaC, esto como parte que el despliegue se concrete sin problemas.

```
aws eks --region us-east-1 update-kubeconfig --name demo-devops-java
kubectl edit -n kube-system cm aws-auth
Se agregó al archivo estas lineas para que la ejecución del despliegue desde codebuild no tenga problemas
    - groups:
      - system:masters
      rolearn: arn:aws:iam::<ACCOUNT>:role/demo-devops-java_role
      username: demo-devops-java_role
```


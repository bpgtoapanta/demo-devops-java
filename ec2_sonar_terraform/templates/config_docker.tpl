#!/bin/bash
# Install docker
sudo amazon-linux-extras install docker
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo chkconfig docker on
sudo yum install -y git
#Install docker compose
sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
#Check the version
docker-compose --version
#Install sonar
mkdir sonar
cd sonar
# Put the docker-compose.yml file at the root of our persistent volume
cat > docker-compose.yml <<-TEMPLATE
${sonar_docker_compose}
TEMPLATE
echo "vm.max_map_count=262144" >> /etc/sysctl.conf
sysctl -p
# Write the systemd service that manages us bringing up the service
cat > /etc/systemd/system/up_docker_sonar.service <<-TEMPLATE
[Unit]
Description=servicio
After=${systemd_after_stage}
[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/docker-compose -f /sonar/docker-compose.yml up -d
Restart=on-failure
[Install]
WantedBy=multi-user.target
TEMPLATE
# Start the service.
systemctl start up_docker_sonar
systemctl enable up_docker_sonar

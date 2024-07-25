# https://pkg.origin.jenkins.io/debian-stable/

#!/bin/bash

# Update system packages
sudo apt update

# Install Java Development Kit (JDK)
sudo apt install -y default-jdk

# Criar a pasta yaman
sudo mkdir /opt/yaman

# Download Java 11
sudo wget -P /opt/yaman/java https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz

# Extract Java 11
sudo tar -xf /opt/yaman/java/openjdk-11.0.2_linux-x64_bin.tar.gz -C /opt/yaman/java

# Add Java 11 to PATH
echo 'export PATH="/opt/yaman/java/jdk-11.0.2/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

 sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \ https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key


 echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null


# Start Jenkins service
sudo systemctl start jenkins

# Enable Jenkins service to start on boot
sudo systemctl enable jenkins

# Allow Jenkins to run on port 8080
sudo ufw allow 8080

# Display Jenkins initial admin password
echo "Jenkins initial admin password:"

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Download JMeter 5.6.3
wget -P /ferramentas https://downloads.apache.org/jmeter/binaries/apache-jmeter-5.6.3.tgz

# Extract JMeter
tar -xf /ferramentas/apache-jmeter-5.6.3.tgz -C /ferramentas

# Add JMeter to PATH
echo 'export PATH="/ferramentas/apache-jmeter-5.6.3/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
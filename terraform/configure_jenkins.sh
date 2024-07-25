# https://pkg.origin.jenkins.io/debian-stable/

#!/bin/bash

# Update system packages
sudo apt update

# Install Java Development Kit (JDK)
sudo apt install -y default-jdk

# Download Java 11
wget -P /opt/yaman/java https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz

# Extract Java 11
sudo tar -xf /opt/yaman/java/openjdk-11.0.2_linux-x64_bin.tar.gz -C /opt/yaman/java

# Add Java 11 to PATH
echo 'export PATH="/opt/yaman/java/jdk-11.0.2/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Add Jenkins repository key
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -

# Add Jenkins repository
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Update system packages again
sudo apt update

# Install Jenkins
sudo apt install -y jenkins

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
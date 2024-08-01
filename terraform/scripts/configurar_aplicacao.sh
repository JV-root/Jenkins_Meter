#!/bin/bash

# This script is used to configure the application by performing the following steps:
# 1. Updates the system packages using 'apt update' and 'apt upgrade' commands.
# 2. Checks if OpenJDK 11 is already installed. If not, installs it using 'apt install' command.
# 3. Checks if the Easy Travel application is already downloaded. If not, downloads it using 'wget' command.
# 4. Executes the Easy Travel application using 'java -jar' command.
# 5. Changes the directory to 'easytravel-2.0.0-x64/weblauncher/'.
# 6. Changes the permissions of 'weblauncher.sh' file using 'chmod' command.
# 7. Launches the 'weblauncher.sh' script in the background using './weblauncher.sh &' command.

# Atualizar os pacotes do sistema
sudo apt update -y
sudo apt upgrade -y

# Verificar se o OpenJDK 11 já está instalado
if ! java -version 2>&1 | grep -q "openjdk version"; then

# Instalar o OpenJDK 11
sudo apt install -y openjdk-11-jre
fi

# Verificar se o Easy Travel já está baixado
if [ ! -f "dynatrace-easytravel-linux-x86_64.jar" ]; then

# Baixar o Easy Travel do Dynatrace
wget https://etinstallers.demoability.dynatracelabs.com/latest/dynatrace-easytravel-linux-x86_64.jar
fi

# Executar o Easy Travel
java -jar dynatrace-easytravel-linux-x86_64.jar

# entrar no diretório do easy_travel
cd easytravel-2.0.0-x64/weblauncher/

chmod 777 weblauncher.sh 

./weblauncher.sh &

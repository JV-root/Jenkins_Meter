# Este script é usado para configurar o InfluxDB no Ubuntu/Debian AMD64.
# Ele faz o download do pacote InfluxDB, instala-o usando o dpkg, inicia o serviço InfluxDB e verifica o status do serviço.

# Fazer o download do pacote InfluxDB
curl -LO https://download.influxdata.com/influxdb/releases/influxdb2_2.7.8-1_amd64.deb

# Instalar o pacote InfluxDB
sudo dpkg -i influxdb2_2.7.8-1_amd64.deb

# Iniciar o serviço InfluxDB
sudo service influxdb start

# Verificar o status do serviço InfluxDB
sudo service influxdb status

# Por padrão o influx inicia na porta 8086
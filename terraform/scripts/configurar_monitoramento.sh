# Este script é usado para configurar o monitoramento usando Prometheus e Node Exporter.

# Baixar e extrair o Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.51.1/prometheus-2.51.1.linux-amd64.tar.gz
tar xzf prometheus-2.51.1.linux-amd64.tar.gz
mv prometheus-2.51.1.linux-amd64 /etc/prometheus

# Editar o arquivo de serviço do Prometheus
sudo nano /etc/prometheus/prometheus.service

# Copiar e colar o conteúdo abaixo no arquivo prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target
[Service]
ExecStart=/etc/prometheus/prometheus --config.file=/etc/prometheus/prometheus.yml
Restart=always
[Install]
WantedBy=multi-user.target

# Recarregar o daemon do systemd e reiniciar o serviço do Prometheus
systemctl daemon-reload
systemctl restart prometheus
systemctl enable prometheus
systemctl status prometheus

# Baixar e extrair o Node Exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
tar xzf node_exporter-1.7.0.linux-amd64.tar.gz
mv node_exporter-1.7.0.linux-amd64 /etc/node_exporter

# Editar o arquivo de serviço do Node Exporter
nano /etc/systemd/system/node_exporter.service

# Copiar e colar o conteúdo abaixo no arquivo node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
[Service]
ExecStart=/etc/node_exporter/node_exporter
Restart=always
[Install]
WantedBy=multi-user.target

# Recarregar o daemon do systemd e reiniciar o serviço do Node Exporter
systemctl daemon-reload
systemctl restart node_exporter
systemctl enable node_exporter
systemctl status node_exporter

# Remover o arquivo de configuração do Prometheus existente
rm -rf /etc/prometheus/prometheus.yml

# Editar o arquivo de configuração do Prometheus
sudo nano /etc/prometheus/prometheus.yml

# Copiar e colar o conteúdo abaixo no arquivo prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
- job_name: node
  static_configs:
  - targets: ['COLOQUE_AQUI_SEU_IP:9100']

# Reiniciar o serviço do Prometheus
sudo systemctl restart prometheus
sudo systemctl status prometheus

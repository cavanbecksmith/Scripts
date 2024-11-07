#!/bin/bash

# Download and install the public signing key:
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg

sudo apt-get install apt-transport-https

echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list

sudo apt-get update && sudo apt-get install elasticsearch

sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service


# Update package index
sudo apt-get update

# Install Java (Elasticsearch and Logstash dependency)
sudo apt-get install -y openjdk-8-jdk

# Install Elasticsearch
sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo sh -c 'echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" > /etc/apt/sources.list.d/elastic-7.x.list'
sudo apt-get update
sudo apt-get install -y elasticsearch

# Start and enable Elasticsearch service
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch

# Install Logstash
sudo apt-get install -y logstash

# Install Kibana
sudo sh -c 'echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" > /etc/apt/sources.list.d/elastic-7.x.list'
sudo apt-get update
sudo apt-get install -y kibana

# Start and enable Kibana service
sudo systemctl start kibana
sudo systemctl enable kibana

# Open necessary ports for Kibana (5601) and Elasticsearch (9200)
sudo ufw allow 5601
sudo ufw allow 9200

# Display information about accessing Kibana
echo "ELK Stack installation completed successfully!"
echo "Access Kibana at http://localhost:5601"
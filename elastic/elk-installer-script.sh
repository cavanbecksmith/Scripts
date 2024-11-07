function elasticsearch(){
	wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
	sudo apt-get install apt-transport-https
	echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
	sudo apt-get update && sudo apt-get install elasticsearch
	sudo systemctl daemon-reload
	sudo systemctl enable elasticsearch.service
}

function kibana(){
	wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
	sudo apt-get install apt-transport-https
	echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
	sudo apt-get update && sudo apt-get install kibana
}


function logstash(){
	wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elastic-keyring.gpg
	sudo apt-get install apt-transport-https
	echo "deb [signed-by=/usr/share/keyrings/elastic-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-8.x.list
	sudo apt-get update && sudo apt-get install logstash
}

if [ -z $1 ]
then
	printf """${BGreen}installer-script.sh                 
    ${RED}
ELK Stack:
* elk-install
--------
    "
elif [ $1 == 'elk-install' ]; then
	echo "elk install"
	elasticsearch
	kibana
	logstash
fi
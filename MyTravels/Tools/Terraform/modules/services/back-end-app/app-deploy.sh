#!/bin/bash

wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

sudo apt-get install -y apt-transport-https
sudo apt-get update
sudo apt-get install -y dotnet-sdk-6.0
sudo apt-get install -y nginx
sudo service nginx start

echo "it's for test purpose only"

echo "server {
 listen 8080;
 location / {
    proxy_pass http://localhost:5000;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection keep-alive;
    proxy_set_header Host \$host;
    proxy_cache_bypass \$http_upgrade;
 }
}" | sudo tee /etc/nginx/sites-available/default > /dev/null

sudo nginx -s reload

cd /home/ubuntu
git clone https://github.com/kazheko/MyTravels.git

sudo dotnet publish MyTravels/MyTravels -o publish -c release

echo "{
  \"ConnectionStrings\": {
    \"DefaultConnection\": \"Host=${db_address};Port=${db_port};Database=${db_database};Username=${db_username};Password=${db_password}\"
  }
}" | sudo tee ./publish/appsettings.${env}.json > /dev/null

echo "[Unit] 
Description=My Travels

[Service] 
WorkingDirectory=/home/ubuntu/publish 
ExecStart=/usr/bin/dotnet /home/ubuntu/publish/MyTravels.WebApi.dll 
Restart=always 
RestartSec=10 # Restart service after 10 seconds if dotnet service crashes 
SyslogIdentifier=offershare-web-app
Environment=ASPNETCORE_ENVIRONMENT=${env} 

[Install] 
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/my-travels-web-api.service > /dev/null

sudo systemctl enable my-travels-web-api.service
sudo systemctl start my-travels-web-api.service
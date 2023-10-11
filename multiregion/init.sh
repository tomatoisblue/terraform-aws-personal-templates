#! bin/bash

# change sshd port
sudo sed -i "s/#Port 22/Port ${ssh_port_num}/" /etc/ssh/sshd_config
systemctl reload sshd

# サーバーの設定変更
sudo sed -i 's/^HOSTNAME=[a-zA-Z0-9\.\-]*$/HOSTNAME=tomatoisblue/g' /etc/sysconfig/network
sudo hostname 'tomatoisblue'
sudo cp /usr/share/zoneinfo/Japan /etc/localtime
sudo sed -i 's|^ZONE=[a-zA-Z0-9\.\-\"]*$|ZONE="Asia/Tokyo"|g' /etc/sysconfig/clock
sudo echo "LANG=ja_JP.UTF-8" > /etc/sysconfig/i18n

# アパッチのインストール （ユーザーデータはルートユーザーで実行されるためSudoはなくても実行可能：また、つけても実行可能です。）
sudo yum update -y
sudo yum install httpd -y
sudo echo "<h1>Hello, World!</h1>" > /var/www/html/index.html
sudo systemctl restart httpd

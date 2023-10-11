#! bin/bash

# change sshd port
sudo sed -i "s/#Port 22/Port ${ssh_port_num}/" /etc/ssh/sshd_config
systemctl reload sshd

# サーバーの設定変更
sudo sed -i 's/^HOSTNAME=[a-zA-Z0-9\.\-]*$/HOSTNAME=udemy-bash/g' /etc/sysconfig/network
sudo hostname 'udemy-bash'
sudo cp /usr/share/zoneinfo/Japan /etc/localtime
sudo sed -i 's|^ZONE=[a-zA-Z0-9\.\-\"]*$|ZONE="Asia/Tokyo"|g' /etc/sysconfig/clock
sudo echo "LANG=ja_JP.UTF-8" > /etc/sysconfig/i18n


sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd

# index.htmlの設置
# aws s3 cp s3://${bucket_name}/index.html /var/www/html
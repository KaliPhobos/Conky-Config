echo "ping -c 1 1.1.1.1 | grep \"bytes from\" | awk '{print \$7}' | tr -d 'time='" > /etc/conky/conky_Ping.sh
chmod +x /etc/conky/conky_Ping.sh

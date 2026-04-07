#!/bin/bash
source <(grep -E '^[a-z0-9_]+_ip:' group_vars/ips.yml \
  | tr -d '\r' \
  | awk -F':' '{gsub(/ /, "", $2); print $1"="$2}')

cat > inventory.ini << ENDINV
[dns_servers]
dns-server ansible_host=${dns_server_ip}

[web_servers]
web01      ansible_host=${web01_ip}
web02      ansible_host=${web02_ip}

[nfs_servers]
nfs-server ansible_host=${nfs_server_ip}

[db_servers]
mariadb-server ansible_host=${db_server_ip}

[lb_servers]
haproxy    ansible_host=${haproxy_ip}

[task7:children]
dns_servers
nfs_servers
db_servers

[task8:children]
dns_servers
nfs_servers
db_servers
lb_servers

[all:vars]
ansible_user                 = root
ansible_ssh_private_key_file = ~/.ssh/id_rsa
ansible_python_interpreter   = /usr/bin/python3
ENDINV

echo "✅ Đã tạo inventory.ini:"
grep ansible_host inventory.ini

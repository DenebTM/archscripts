#!/bin/sh
echo >> checkssh.log && echo $(date) >> checkssh.log
for ip in $(cat ips.txt); do
    nmap $ip --host-timeout 1 -PN -p ssh | grep 'open' > /dev/null
    if [ $? == 0 ]; then
        echo $ip
        echo $ip >> checkssh.log
    fi
done

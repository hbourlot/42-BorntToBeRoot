#!/bin/bash

export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

name=$(head -2 /etc/os-release | grep -Po 'NAME="\K[^"]*')
arch=$(uname -r)
version=$(head -5 /etc/os-release | grep -Po 'VERSION_ID="\K[^*]*')
arch_version=$(uname -m)
CPU=$(lscpu | head -15 | grep  'Socket(s)' | awk '{print $2}')
vCPU=$(lscpu | head -5 | grep  'CPU(s)' | awk '{print $2}')
MemUse=$(free --mega | head -2 | grep  'Mem:' | awk '{print $3}')
MemMax=$(free --mega | head -2 | grep  'Mem:' | awk '{print $2}')
PorUsa=$(free | grep Mem | awk '{printf "%.2f%\n", $3/$2 * 100}')
cpu_percent=$(mpstat | sed '3d' | sed '1d' | awk '{print((100-$13))}' | sed '1d')
number_users=$(who | wc -l)
sudo=$(journalctl | grep sudo | grep COMMAND | wc -l)
diskusage=$(df -h --total | grep total | awk '{printf "%d (%s)\n", $2, $5}')
lastboot=$(who -b | awk '{printf "%s %s", $3,$4}')
lvm=$(if [ $(lsblk | grep lvm | wc -l) -gt 0 ]; then echo "yes"; else echo "no"; fi)
tcpconnections=$(ss -Htan state established | wc -l)
network=$(ip -4 addr show | grep inet | awk '{print $2}' | cut -d/ -f1 | sed '2!d')
macaddress=$(ip addr show | grep ether | awk '{print $2}')


wall "#Architecture: $name $arch $version $arch_version
#CPU physical: $CPU
#vCPU: $vCPU
#Memory Usage: $MemUse/$MemMax"MB" ($PorUsa)
#Disk Usage: $diskusage
#CPU load:  $cpu_percent
#Last boot:  $lastboot
#LVM use: $lvm
#Connections TCP: $tcpconnections ESTABLISHED
#User log: $number_users
#Network: IP $network ($macaddress)
#Sudo: $sudo cmd"
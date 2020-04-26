#! /bin/bash
printf "Time;Disk;CPU;RAM (used);RAM (free);Network inbound (Mbit/s);Network outbound (Mbit/s)\n"

RUNtimeh=12
RUNtimem=30

INTtotal=60
INTnet=5

end=$((SECONDS + $RUNtimeh*3600 + RUNtimem*60))
while [ $SECONDS -lt $end ]; do

DATE=`date +"%H:%M:%S"`
DISK=$(df -h | awk '$NF=="/"{printf "%s", $5 }' | tr '.' ',')
CPU=$(top -bn1 | grep load | awk '{printf "%.2f%%", $(NF-2) }' | tr '.' ',')
RAMused=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2}' | tr '.' ',')
RAMavail=$(free -m | awk 'NR==2{printf "%.2f%%", $7*100/$2}' | tr '.' ',')
CONinout=$(ifstat -i eno1 -b -n $INTnet 1 | awk 'NR==3{printf "%.2f;%.2f", $1/1028, $2/1028}' | tr '.' ',')
printf "%s;%s;%s;%s;%s;%s\n" $DATE $DISK $CPU $RAMused $RAMavail $CONinout
sleep $((INTtotal - INTnet))
done

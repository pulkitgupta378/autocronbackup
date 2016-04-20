#!/bin/bash


mkdir -p /mnt/autocron
cd /mnt/autocron/

ht=`cat /etc/bashrc | grep -i "&& PS1" | cut -d@ -f2 | awk {'print $1'}`
dt=`date | awk {'print $2'}`

mkdir -p /mnt/$ht
cat /etc/hosts > hosts.txt

crontab -l > cron.txt

#for part in $(sed 's/#.*//' cron.txt | while read t1 t2 t3 t4 t5 main; do echo $main; done); do
#  echo $part
#done | grep / | grep -v :// > dir.txt

crontab -l |  awk '{print $6 "\n" $7}' | grep '^/' | egrep -o '.*[/]' | egrep -v "/bin/|/dev/" | awk -F'.' '{print $1}' | sort -u > dir.txt

#for path in `cat dir.txt`
#do
#dirname $path >> file.txt
#done

#sort file.txt | uniq > path.txt

#for i in `cat /mnt/autocron/path.txt`
#  do
# echo $i
#for j in `cat /mnt/std.txt`
#  do
# echo $j
#
#if   [ $i = $j ]

#then
#echo $i >> /mnt/autocron/bkp.txt

#else

#echo "nothing to  copy"

#fi
#done
#done

#sort bkp.txt | uniq > file.txt

#echo $(cat bkp.txt) | while read -r row
echo $(cat dir.txt) | while read -r row
do
tar -cvf $ht.tar.gz --exclude='*.gz' --exclude='*.jar' --exclude='*.bkp' --exclude='*.csv' --exclude='*.log' $row
done

cp -r hosts.txt cron.txt $ht.tar.gz /mnt/$ht/

s3cmd put -r /mnt/$ht s3://admarvel-images/2015/cron/$dt/



#scp -r $ht 10.185.181.170:/mnt/cron_bkp_july15/

cd /mnt;rm -rf autocron $ht

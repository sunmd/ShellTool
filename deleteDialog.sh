#!/bin/sh

# Check the size of storage, when less than 80% delete tomcat and nginx log.
# anthor --- sunmd 
storage=`df | grep '/usr/local' | awk '{ print $5 }' | awk -F% '{print $1}'`

echo "this server storage size % is $storage " >> $deletelog

# this is storage online 
size=80

# tomcat path 
tomcatPath="/usr/local/tomcat/logs/"
#tomcatPath="/usr/local/tomcat_test/logs/"

tomcatlogfile1="localhost"
tomcatlogfile2="localhost_access_log"

deletelog="/var/log/deleteDialog.log"

echo " deleteDialog is beagin ! storage is $storage " >> $deletelog
echo " ---------`date +%Y_%m_%d`---------" >> $deletelog 

# check df , the size of storage more than size
if [ $storage -ge $size ] ; then 
	
	#check logfile is exist, if true delete the logfile which is not today logfile
	for file in ${tomcatPath}${tomcatlogfile2}.*
	do
		if [ -f $file -a $file != "$tomcatPath$tomcatlogfile2.`date +%Y-%m-%d`.txt" ] ; then 

			echo "will delete this file : $file" >> $deletelog

			rm -f $file
		fi
	done
	
	#check logfile is exist, if true delete the logfile which is not today logfile
	for file2 in ${tomcatPath}${tomcatlogfile1}.*
	do
		if [ -f $file2 -a $file2 != "$tomcatPath$tomcatlogfile1.`date +%Y-%m-%d`.log" ] ; then
			echo "will delete this file2 : $file2" >> $deletelog
			rm -f $file2
		fi
	done
	
	#delete nginx log file 
	/sbin/service nginx stop
	
	echo " nginx is stop !" >> $deletelog

	echo " delete nginx log begin!" >> $deletelog

	ls -lh /usr/local/nginx/logs/*.log >> $deletelog

	rm -f /usr/local/nginx/logs/*.log

	
	sleep 10s	

	/sbin/service nginx start
	echo " nginx is start ! " >> $deletelog	
fi
echo " deleteDialog is end ! " >> $deletelog 

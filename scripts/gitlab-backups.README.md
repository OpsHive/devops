This scripts takes daily backups

```
#!/bin/bash

start(){
	echo "###### script start ######"

	echo "##### setup variables #####"

	DATETIME=`date +%y%m%d-%H_%M_%S`

	echo "#####  generating backups for  gitlab-data #####"

	if gitlab-backup create; then

	echo "#### backup generated successfully  #####"
       else
          echo "### faild backups ####"
          return 1
       fi
       
	echo "##### creating folder #####"

	if mkdir -p /mnt/backups_spaces/gitlab-backups/$DATETIME; then

	echo "#### dirctory created for digitalocean spaces ####"
        else
          echo "### faild to create dir in digitalocean spaces ###"
          return 1
        fi
        echo "### moving backups to spaces"

	if cp -r /var/opt/gitlab/backups/* /mnt/backups_spaces/gitlab-backups/$DATETIME; then
        echo "### moved backup to spaces successfully ####"
        else
          echo "### FAILD to move files on spaces ####"
          return 1
        fi
        echo "### moving configurations files into backupfolder ###"
        cp -r /etc/gitlab /mnt/backups_spaces/gitlab-backups/$DATETIME
	echo "#### removing generated backups ####"

	rm -f /var/opt/gitlab/backups/*

       
	echo "done"

}

start

```

open your crontab with 

```
crontab -e

```

this will open editor just point your sechdule

```
# Edit this file to introduce tasks to be run by cron.
# 
# Each task to run has to be defined through a single line
# indicating with different fields when the task will be run
# and what command to run for the task
# 
# To define the time you can provide concrete values for
# minute (m), hour (h), day of month (dom), month (mon),
# and day of week (dow) or use '*' in these fields (for 'any').
# 
# Notice that tasks will be started based on the cron's system
# daemon's notion of time and timezones.
# 
# Output of the crontab jobs (including errors) is sent through
# email to the user the crontab file belongs to (unless redirected).
# 
# For example, you can run a backup of all your user accounts
# at 5 a.m every week with:
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
# 
# For more information see the manual pages of crontab(5) and cron(8)
# 
# m h  dom mon dow   command
0 0 * * * ~/backup.sh

```

save and exit

you can also restore backups copy backups file on /var/opt/gitlab/backups

```
sudo gitlab-ctl stop unicorn
sudo gitlab-ctl stop sidekiq
sudo gitlab-rake gitlab:backup:restore BACKUP=TIMESTAMP_OF_BACKUP
sudo gitlab-ctl start

```

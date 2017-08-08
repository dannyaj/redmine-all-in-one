#!/bin/bash

TIME=$(date +%Y-%m-%d-%T)
FILE_NAME="mysql-$TIME.sql"

mysqldump -h127.0.0.1 -uroot -ppassword redmine > /mnt/redmine/backup/$FILE_NAME
mysqldump -h127.0.0.1 -uroot -ppassword redmine > /mnt/nfs_redmine_backup/backup/redmine.sql
/bin/cp -rpaf /mnt/redmine/files /mnt/nfs_redmine_backup/
/bin/cp -rpaf /mnt/svn/repo /mnt/nfs_svn_backup/

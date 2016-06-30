#!/bin/bash

cd $BUGZILLA_ROOT

# Configure database
/usr/bin/mysqld_safe &
sleep 5
mysql -u root mysql -e "GRANT ALL PRIVILEGES ON *.* TO bugs@localhost IDENTIFIED BY 'bugs'; FLUSH PRIVILEGES;"
mysql -u root mysql -e "CREATE DATABASE bugs CHARACTER SET = 'utf8';"


chown -R $BUGZILLA_USER.$BUGZILLA_USER $BUGZILLA_ROOT


perl checksetup.pl /checksetup_answers.txt
perl checksetup.pl /checksetup_answers.txt

mysqladmin -u root shutdown

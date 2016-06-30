#!/bin/bash
# Restore all-databases and bugzilla folder data.
BAK_IP=$1
NEW_IP=$2

[[  $BAK_IP =~ [0-9]  ]] && [[  $NEW_IP =~ [0-9]  ]] || (echo 'Need BAK_IP and NEW_IP in $1, $2.' && exit 1)
if [ $? == 1 ];then
exit 1
fi

cd $BUGZILLA_ROOT

([ -f /bak/bugzilla_bak.tar.gz ] && echo '[Using] /bak/bugzilla_bak.tar.gz .. ' && tar zxf /bak/bugzilla_bak.tar.gz -C $BUGZILLA_ROOT/ )|| echo '/bak/bugzilla_bak.tar.gz not found. Using default bugzilla config data.'

chown -R $BUGZILLA_USER.$BUGZILLA_USER $BUGZILLA_ROOT
sed -i "/urlbase/ s@$1@$2@ " $BUGZILLA_ROOT/data/params.json 
sed -i  's@www-data@bugzilla@' $BUGZILLA_ROOT/localconfig
sed -i "/db_pass/ s@''@'bugs'@" $BUGZILLA_ROOT/localconfig
sed -i 's@/var/run/mysqld/mysqld.sock@/var/lib/mysql/mysql.sock@' $BUGZILLA_ROOT/localconfig


echo '[Restoring]  /usr/bin/mysql -uroot < /bak/alldb.sql......'
[ -f /bak/alldb.sql ] && /usr/bin/mysql -uroot < /bak/alldb.sql ||  echo '/bak/alldb.sql not found'


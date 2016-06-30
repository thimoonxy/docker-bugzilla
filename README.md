Docker Bugzilla
===============

Configure a running Bugzilla system using Docker

> This is forked from dklawren/docker-bugzilla

## Origin Features

* Running latest Centos
* Preconfigured with initial data 
* Running Apache2 and MySQL Community Server 5.6
* Code resides in `/home/bugzilla/devel/htdocs/bugzilla` and can be updated,
  diffed, and branched using standard git commands

## Extended Features

* Use Bugzilla v5.0.2 instead of v4.4.
* Add data Volume /bak, which used for importing/restoring data.

## Examples

- Clone the repor and build the image in the folder where holding Dockerfile

```
[simon.xie@centos-docker src]# docker build -t bugzilla:simon .
```

> It'll docker pull dklawren's v4.4 images if it's not exist and appending stuffs from this fork 

- Run a container that with host sharing in dameon:
```
[simon.xie@centos-docker ~]# docker run -d -p 80:80 -v /bak:/bak   bugzilla:simon  supervisord
7f93f61878efa356c6c33c9c21891f3b5d79090f9268372b7991c3ac446faf60
```

- Restoring existed bugzilla config files and mysql **all-databases**: 

> Make sure you have bugzilla tarball and the all-databases mysql bak file in your host sharing path:

```
[simon.xie@centos-docker ~]# ls /bak/{bugzilla_bak.tar.gz,alldb.sql} -lh
-rwxr-xr-x. 1 simon root 2.3M Jun 28 03:57 /bak/alldb.sql
-rwxr-xr-x. 1 simon root  18M Jun 29 03:16 /bak/bugzilla_bak.tar.gz

```

> It's a all-databases dump rather than a simple bak of bugs db.

```
[simon.xie@centos-docker ~]# grep -ia 'create database' /bak/alldb.sql  | head -n 2
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `bugs` /*!40100 DEFAULT CHARACTER SET utf8 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/ `mysql` /*!40100 DEFAULT CHARACTER SET latin1 */;
```

In this case, when call the /my_config.sh script with old ip/FQDN (the one in bak files) and new ip/FQDN (the one you want to use here), mysql root passwd and all expected datas will be restored.

```
[simon.xie@centos-docker ~]# docker exec -ti 7f9  /my_config.sh 10.9.0.187 192.168.141.11
[Using] /bak/bugzilla_bak.tar.gz .. 
[Restoring]  /usr/bin/mysql -uroot < /bak/alldb.sql......

```

If didn't put those 2x IPs, it prompts like this and don't change your datas:

```
[simon.xie@centos-docker ~]# docker exec -ti 7f9  /my_config.sh 
Need BAK_IP and NEW_IP in $1, $2.

```

[docker]: https://docs.docker.com/installation/


#!/bin/bash

docker run -ti \
--net=host \
-v /mnt/redmine/files:/opt/redmine/redmine-3.0.4/files \
-v /mnt/redmine/database.yml:/opt/redmine/redmine-3.0.4/config/database.yml \
-v /mnt/redmine/configuration.yml:/opt/redmine/redmine-3.0.4/config/configuration.yml \
-v /mnt/redmine/dav_svn.passwd:/etc/apache2/dav_svn.passwd \
-v /mnt/redmine/dav_svn.authz:/etc/apache2/dav_svn.authz \
-v /mnt/redmine/repo:/var/lib/svn \
-v /mnt/redmine/docker/start.sh:/opt/start.sh \
-v /mnt/redmine/mysql:/var/lib/mysql \
example/redmine
bash

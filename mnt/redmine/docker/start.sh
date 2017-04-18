#!/bin/bash

chown -R mysql:mysql /var/lib/mysql

/etc/init.d/mysql start
/etc/init.d/apache2 start

mysql -u root < /opt/init_redmine.sql
mysqladmin -u root password password

cd redmine/
rake generate_secret_token
RAILS_ENV=production rake db:migrate
RAILS_ENV=production rake redmine:load_default_data

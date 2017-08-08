FROM ubuntu:14.04

# installing dependencies
RUn apt-get update && apt-get upgrade -y
RUN apt-get install -y apache2 php5 libapache2-mod-php5 mysql-server php5-mysql
RUN apt-get install -y libapache2-mod-perl2 libcurl4-openssl-dev libssl-dev apache2-prefork-dev libapr1-dev libaprutil1-dev libmysqlclient-dev libmagickcore-dev libmagickwand-dev
RUN apt-get install -y curl git-core gitolite patch build-essential bison zlib1g-dev libssl-dev libxml2-dev libxml2-dev
RUN apt-get install -y sqlite3 libsqlite3-dev autotools-dev libxslt1-dev libyaml-0-2 autoconf automake libreadline6-dev libyaml-dev libtool imagemagick
RUN apt-get install -y apache2-utils ssh zip libicu-dev libssh2-1 libssh2-1-dev cmake libgpg-error-dev subversion libapache2-svn

# configure subversion
RUN mkdir -p /var/lib/svn
RUN chown -R www-data:www-data /var/lib/svn
RUN a2enmod dav_svn

# uncomment svn
RUN sed -i 's|#<Location /svn>|<Location /svn>|g' /etc/apache2/mods-enabled/dav_svn.conf
RUN sed -i 's|#DAV svn|DAV svn|g' /etc/apache2/mods-enabled/dav_svn.conf
RUN sed -i 's|#SVNParentPath /var/lib/svn|SVNParentPath /var/lib/svn|g' /etc/apache2/mods-enabled/dav_svn.conf
RUN sed -i 's|#AuthType Basic|AuthType Basic|g' /etc/apache2/mods-enabled/dav_svn.conf
RUN sed -i 's|#AuthName "Subversion Repository"|AuthName "Subversion Repository"|g' /etc/apache2/mods-enabled/dav_svn.conf
RUN sed -i 's|#AuthUserFile /etc/apache2/dav_svn.passwd|AuthUserFile /etc/apache2/dav_svn.passwd|g' /etc/apache2/mods-enabled/dav_svn.conf
RUN sed -i 's|#AuthzSVNAccessFile /etc/apache2/dav_svn.authz|AuthzSVNAccessFile /etc/apache2/dav_svn.authz|g' /etc/apache2/mods-enabled/dav_svn.conf
RUN sed -i 's|#<LimitExcept GET PROPFIND OPTIONS REPORT>|<LimitExcept GET PROPFIND OPTIONS REPORT>|g' /etc/apache2/mods-enabled/dav_svn.conf
RUN sed -i 's|#Require valid-user|Require valid-user|g' /etc/apache2/mods-enabled/dav_svn.conf
RUN sed -i 's|#</LimitExcept>|</LimitExcept>|g' /etc/apache2/mods-enabled/dav_svn.conf
RUN sed -i 's|#</Location>|</Location>|g' /etc/apache2/mods-enabled/dav_svn.conf
#RUN a2enmod authz_svn

# install ruby
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:brightbox/ruby-ng
RUN apt-get update
RUN apt-get -y install ruby2.1 ruby-switch ruby2.1-dev ri2.1 libruby2.1 libssl-dev zlib1g-dev
RUN ruby-switch --set ruby2.1

# users and ssh keys
RUN adduser --system --shell /bin/bash --gecos 'Git Administrator' --group --disabled-password --home /opt/gitolite git
RUN adduser --system --shell /bin/bash --gecos 'Redmine Administrator' --group --disabled-password --home /opt/redmine redmine
RUN sudo su - redmine; ssh-keygen -t rsa -N '' -f ~/.ssh/redmine_gitolite_admin_id_rsa; exit
#exit

# visudo configuration
RUN echo "# temp - *REMOVE* after installation" >> /etc/sudoers
RUN echo "redmine    ALL=(ALL)      NOPASSWD:ALL" >> /etc/sudoers
RUN echo "" >> /etc/sudoers
RUN echo "# redmine gitolite integration" >> /etc/sudoers
RUN echo "redmine    ALL=(git)      NOPASSWD:ALL" >> /etc/sudoers
RUN echo "git        ALL=(redmine)  NOPASSWD:ALL" >> /etc/sudoers

# install redmine
RUN gpg --keyserver hkp://pgp.mit.edu --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3;
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN /usr/local/rvm/bin/rvm-shell -c "rvm install 2.1.4"
#RUN rvm install 2.1.4
#USER redmine
RUN wget http://www.redmine.org/releases/redmine-3.0.4.tar.gz
RUN tar zxf redmine-3.0.4.tar.gz -C /opt/redmine
RUN rm redmine-3.0.4.tar.gz
RUN ln -s /opt/redmine/redmine-3.0.4 redmine
RUN chown -R redmine:redmine redmine
RUN chown -R redmine:redmine /opt/redmine
USER root
RUN chmod -R 777 /opt/redmine/redmine-3.0.4/tmp/cache

# Installing Phusion Passenger
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
RUN apt-get install -y apt-transport-https ca-certificates
RUN echo "deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main" >> /etc/apt/sources.list.d/passenger.list
RUN chown root: /etc/apt/sources.list.d/passenger.list
RUN chmod 600 /etc/apt/sources.list.d/passenger.list
RUN apt-get update
RUN apt-get install -y libapache2-mod-passenger
RUN echo "PassengerUserSwitching on" >> /etc/apache2/mods-available/passenger.conf
RUN echo "PassengerUser redmine" >> /etc/apache2/mods-available/passenger.conf
RUN echo "PassengerGroup redmine" >> /etc/apache2/mods-available/passenger.conf
RUN echo "<Directory /var/www/html/redmine>" >> /etc/apache2/sites-available/000-default.conf
RUN echo "    RailsBaseURI /redmine" >> /etc/apache2/sites-available/000-default.conf
RUN echo "    PassengerResolveSymlinksInDocumentRoot on" >> /etc/apache2/sites-available/000-default.conf
RUN echo "</Directory>" >> /etc/apache2/sites-available/000-default.conf
RUN a2enmod passenger
RUN ln -s /opt/redmine/redmine-3.0.4/public/ /var/www/html/redmine

RUN gem install bundler
#RUN cd redmine;
ADD database.yml /redmine/config/database.yml
RUN cd redmine;bundle install --without development test postgresql sqlite
ADD init_redmine.sql /opt
CMD ["/bin/bash", "/opt/start.sh"]

CREATE DATABASE redmine character SET utf8;
CREATE user 'redmine'@'localhost' IDENTIFIED BY 'my_password';
GRANT ALL privileges ON redmine.* TO 'redmine'@'localhost';

PHP CI/CD Build Docker Image
============================

PHP based Docker image to be used with CI/CD services like Bitbucket Pipelines.

Features
--------

* Starts from official PHP Docker image for non-CGI tags and from [jbboehr/php-cgi](https://hub.docker.com/r/jbboehr/php-cgi/) for CGI tags (jbboehr/php-cgi is a fork of the official PHP image with CGI support enabled).
* PHP Extensions installed: iconv mcrypt xsl intl zip pdo_mysql gd opcache imagick pcntl soap bcmath
* Other utilities installed: composer, git, mysql client, wget, zip, unzip, nodejs & npm

Credits
-------

[Webgriffe®](http://www.webgriffe.com/)
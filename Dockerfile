FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteract

RUN apt-get update && apt-get dist-upgrade -y \
    && apt-get install -y php7.4 apache2 libapache2-mod-php7.4

# Enable the php mod we just installed
RUN a2enmod php7.4
RUN a2enmod rewrite

# expose port 80 and 443 (ssl) for the web requests
EXPOSE 80

# Manually set the apache environment variables in order to get apache to work immediately.
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_RUN_DIR=/var/run/apache2

# It appears that the new apache requires these env vars as well
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid

# Turn on display errors. We will disable them based on environment 
RUN sed -i 's;display_errors = .*;display_errors = On;' /etc/php/7.4/apache2/php.ini

# Install the cron service to tie up the container's foreground process
RUN apt-get install cron -y

# Add the site's code to the container.
RUN rm -rf /var/www/html
COPY --chown=root:www-data site /var/www/html

# Set permissions
RUN chown root:www-data /var/www
RUN chmod 750 -R /var/www

# Add the startup script to the container
COPY startup.sh /root/startup.sh

# Execute the containers startup script which will start many processes/services
# The startup file was already added when we added "project"
CMD ["/bin/bash", "/root/startup.sh"]

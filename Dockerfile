FROM ubuntu:22.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential \
    wget \
    apache2 \
    ghostscript \
    libapache2-mod-php \
    mysql-server \
    curl \
    php \
    php-bcmath \
    php-curl \
    php-imagick \
    php-intl \
    php-json \
    php-mbstring \
    php-mysql \
    php-xml \
    php-zip \
    php-cli \
    dos2unix

RUN apt-get install -y net-tools

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN apt-get update \
    && apt-get install -y software-properties-common \
    && apt-get install -y vim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html/Wordpress 
COPY wordpress /var/www/html/Wordpress

# Install WordPress
#RUN curl -o wordpress.tar.gz -SL https://wordpress.org/latest.tar.gz && \
#    mkdir -p /var/www/html/Wordpress && \
#    tar -xzf wordpress.tar.gz -C /var/www/html/Wordpress --strip-components=1 && \
#    rm wordpress.tar.gz && \
#    chown -R www-data:www-data /var/www/html/Wordpress

RUN chown -R www-data:www-data /var/www/

COPY wordpress.conf /etc/apache2/sites-available/wordpress.conf

RUN a2dissite 000-default.conf
RUN a2ensite wordpress.conf && \
    a2enmod rewrite

COPY db-entrypoint.sh /root/db-entrypoint.sh

RUN dos2unix /root/db-entrypoint.sh

RUN chmod +x /root/db-entrypoint.sh

EXPOSE 80

entrypoint ["/root/db-entrypoint.sh"]

CMD ["apache2ctl", "-D", "FOREGROUND"]















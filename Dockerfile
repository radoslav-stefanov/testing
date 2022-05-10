FROM php:7.1.11-apache

LABEL org.opencontainers.image.source="https://github.com/radoslav-stefanov/testing"

RUN apt-get update

#installing dependencies
RUN apt-get install -y automake autoconf libtool git wget apache2-dev

#build and install libmaxminddb
RUN cd /tmp/ \
	&& git clone --recursive https://github.com/maxmind/libmaxminddb.git \
	&& cd libmaxminddb/ \
	&& ./bootstrap \
	&& ./configure \
	&& make \
	&& make check \
	&& make install \
	&& ldconfig

#build and install mod_maxminddb 
RUN cd /tmp/ \
	&& git clone https://github.com/maxmind/mod_maxminddb.git \
	&& cd mod_maxminddb/ \
	&& ./bootstrap \
	&& ./configure \
	&& make install

# download and install maxmind db
RUN mkdir -p /opt/maxmind/

RUN cd /tmp/ \
	&& wget -q -O GeoIP2-City.tar.gz "https://github.com/DocSpring/geolite2-city-mirror/raw/master/GeoLite2-City.tar.gz" \
	&& tar -zxf GeoIP2-City.tar.gz \
	&& find . -type f -name "*.mmdb" | xargs -I dbfile mv dbfile /opt/maxmind/

#enable mod_remoteip apache module and configure it to handle remote client ips via X-Forwarded-For header
COPY conf/ /etc/apache2/conf-available/
RUN a2enmod remoteip && a2enconf remoteip

#enable headers apache module to support setting http headers in the response (for CORS for example)
RUN a2enmod headers

# Copying source code
RUN rm -rf /var/www/html/*
COPY src/ /var/www/html/

# Clean up
RUN apt-get remove -y automake autoconf libtool git 
RUN rm -rf /tmp/*

RUN echo rado

CMD ["apache2-foreground"]

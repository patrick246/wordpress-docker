FROM ubuntu:24.04@sha256:440dcf6a5640b2ae5c77724e68787a906afb8ddee98bf86db94eea8528c2c076 as plugins
WORKDIR /usr/src/
RUN apt-get update && apt-get install unzip jq curl -y
COPY ./download-*.sh ./
RUN ./download-plugin.sh contact-form-7
RUN ./download-theme.sh twentyeleven

FROM wordpress:apache@sha256:15be4bea492a3f9ee5211d408290ef3638d325b804569fa0b3ade38567d6769e
WORKDIR /usr/src/wordpress
RUN set -eux; \
	find /etc/apache2 -name '*.conf' -type f -exec sed -ri -e "s!/var/www/html!$PWD!g" -e "s!Directory /var/www/!Directory $PWD!g" '{}' +; \
	cp -s wp-config-docker.php wp-config.php
COPY --from=plugins /usr/src/contact-form-7 /usr/src/wordpress/wp-content/plugins/contact-form-7
COPY --from=plugins /usr/src/twentyeleven /usr/src/wordpress/wp-content/themes/twentyeleven

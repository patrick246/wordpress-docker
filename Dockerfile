FROM ubuntu:24.04@sha256:72297848456d5d37d1262630108ab308d3e9ec7ed1c3286a32fe09856619a782 as plugins
WORKDIR /usr/src/
RUN apt-get update && apt-get install unzip jq curl -y
COPY ./download-*.sh ./
RUN ./download-plugin.sh contact-form-7
RUN ./download-theme.sh twentyeleven

FROM wordpress:apache@sha256:8b0ffd461bfaf8e74ab98481f45d1b2596986767faf2dc65bb47c875076f8a14
WORKDIR /usr/src/wordpress
RUN set -eux; \
	find /etc/apache2 -name '*.conf' -type f -exec sed -ri -e "s!/var/www/html!$PWD!g" -e "s!Directory /var/www/!Directory $PWD!g" '{}' +; \
	cp -s wp-config-docker.php wp-config.php
COPY --from=plugins /usr/src/contact-form-7 /usr/src/wordpress/wp-content/plugins/contact-form-7
COPY --from=plugins /usr/src/twentyeleven /usr/src/wordpress/wp-content/themes/twentyeleven

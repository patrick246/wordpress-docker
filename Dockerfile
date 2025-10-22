FROM ubuntu:24.04@sha256:66460d557b25769b102175144d538d88219c077c678a49af4afca6fbfc1b5252 as plugins
WORKDIR /usr/src/
RUN apt-get update && apt-get install unzip jq curl -y
COPY ./download-*.sh ./
RUN ./download-plugin.sh contact-form-7
RUN ./download-theme.sh twentyeleven

FROM wordpress:apache@sha256:4046f5595cb7a9a094edfbecaaf0c5703d5d1773b8da2901a85c8d9e2b8fcef7
WORKDIR /usr/src/wordpress
RUN set -eux; \
	find /etc/apache2 -name '*.conf' -type f -exec sed -ri -e "s!/var/www/html!$PWD!g" -e "s!Directory /var/www/!Directory $PWD!g" '{}' +; \
	cp -s wp-config-docker.php wp-config.php
COPY --from=plugins /usr/src/contact-form-7 /usr/src/wordpress/wp-content/plugins/contact-form-7
COPY --from=plugins /usr/src/twentyeleven /usr/src/wordpress/wp-content/themes/twentyeleven

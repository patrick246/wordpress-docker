FROM ubuntu:24.04@sha256:d1e2e92c075e5ca139d51a140fff46f84315c0fdce203eab2807c7e495eff4f9 as plugins
WORKDIR /usr/src/
RUN apt-get update && apt-get install unzip jq curl -y
COPY ./download-*.sh ./
RUN ./download-plugin.sh contact-form-7
RUN ./download-theme.sh twentyeleven

FROM wordpress:apache@sha256:1b5fee9f90d12c7fcba8b0bcb0f9d94166daa1086b7559def66d62e5c9b7c947
WORKDIR /usr/src/wordpress
RUN set -eux; \
	find /etc/apache2 -name '*.conf' -type f -exec sed -ri -e "s!/var/www/html!$PWD!g" -e "s!Directory /var/www/!Directory $PWD!g" '{}' +; \
	cp -s wp-config-docker.php wp-config.php
COPY --from=plugins /usr/src/contact-form-7 /usr/src/wordpress/wp-content/plugins/contact-form-7
COPY --from=plugins /usr/src/twentyeleven /usr/src/wordpress/wp-content/themes/twentyeleven

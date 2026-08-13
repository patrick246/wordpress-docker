FROM ubuntu:26.04@sha256:678c6550cc43645e08669028bc177f50be4e7c5b8cca677067b1914d4afc7a03 as plugins
WORKDIR /usr/src/
RUN apt-get update && apt-get install unzip jq curl -y
COPY ./download-*.sh ./
RUN ./download-plugin.sh contact-form-7
RUN ./download-theme.sh twentyeleven

FROM wordpress:apache@sha256:b427cec767f5de2aa649390cb8805aa1fe320e1e0d57fc1f467754edb6cc0a49
WORKDIR /usr/src/wordpress
RUN set -eux; \
	find /etc/apache2 -name '*.conf' -type f -exec sed -ri -e "s!/var/www/html!$PWD!g" -e "s!Directory /var/www/!Directory $PWD!g" '{}' +; \
	cp -s wp-config-docker.php wp-config.php
COPY --from=plugins /usr/src/contact-form-7 /usr/src/wordpress/wp-content/plugins/contact-form-7
COPY --from=plugins /usr/src/twentyeleven /usr/src/wordpress/wp-content/themes/twentyeleven

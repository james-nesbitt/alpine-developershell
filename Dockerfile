FROM quay.io/wunder/alpine-php
MAINTAINER aleksi.johansson@wunderkraut.com

## Global

### Common developer tools
RUN apk --update add \
curl \
wget \
git \
vim \
zsh \
tar \
gzip \
p7zip \
xz \
nodejs \
sudo \
openssh \
openssl \
ansible \
rsync && \
rm -rf /tmp/* && \
rm -rf /var/cache/apk/*
ADD etc/sudoers.d/app_nopasswd /etc/sudoers.d/app_nopasswd

### PHP and MySQL
RUN apk --no-cache --update add \
mysql-client \
php7-ast \
php7-openssl \
php7-pear \
php7-phar \
php7-zlib && \
ln -s /usr/bin/php7 /usr/bin/php && \
rm -rf /tmp/* && \
rm -rf /var/cache/apk/*
ADD etc/php7/conf.d/WK_date.ini /etc/php7/conf.d/WK_date.ini

### Common theming tools
RUN npm install -g gulp grunt

### Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
php composer-setup.php --install-dir=/usr/local/bin --filename=composer --version=1.1.1 && \
php -r "unlink('composer-setup.php');" && \
composer global require "hirak/prestissimo:^0.3"

## App user specific

USER app

### Drush
RUN composer global require drush/drush:8.x

### Drupal Console
RUN composer global require drupal/console:1.0.0-beta1 && \
export PATH=$HOME/.composer/vendor/bin:$PATH && \
drupal init --override && \
mkdir -p ~/.config/fish/completions && \
ln -s ~/.console/drupal.fish ~/.config/fish/completions/drupal.fish
ADD app/.console/phpcheck.yml /app/.console/phpcheck.yml

### PlatformSH CLI
# @TODO this should be build using composer. Composer builds currently fail, so we simulate it
#        RUN composer global require platformsh/cli
#
RUN curl -L -o /app/.composer/vendor/bin/platform https://github.com/platformsh/platformsh-cli/releases/download/v3.1.1/platform.phar && \
    chmod a+x /app/.composer/vendor/bin/platform

### oh-my-zsh
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
ADD app/.zshrc /app/.zshrc

USER root

RUN chown -R app:app /app

## Config

USER app
WORKDIR /app
ENTRYPOINT ["/usr/bin/ssh-agent","/bin/zsh"]

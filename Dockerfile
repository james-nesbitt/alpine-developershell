# wunder/fuzzy-alpine-devshell
#
# VERSION v7.0.12-0
#
FROM quay.io/wunder/fuzzy-alpine-php-dev:v7.0.12
MAINTAINER aleksi.johansson@wunder.io

## Global

### Common developer tools
RUN apk --no-cache add \
curl \
wget \
git \
vim \
zsh \
tar \
gzip \
p7zip \
py-yaml \
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
RUN apk --no-cache add \
mysql-client \
postgresql-client \
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
php composer-setup.php --install-dir=/usr/local/bin --filename=composer --version=1.1.2 && \
php -r "unlink('composer-setup.php');" && \
composer global require "hirak/prestissimo:0.3.2"

## App user specific

USER app

### Drush
RUN composer global require drush/drush:8.1.2

### Drupal Console
RUN composer global require drupal/console:1.0.0-rc3 && \
export PATH=$HOME/.composer/vendor/bin:$PATH && \
drupal init --override && \
mkdir -p ~/.config/fish/completions && \
ln -s ~/.console/drupal.fish ~/.config/fish/completions/drupal.fish
ADD app/.console/phpcheck.yml /app/.console/phpcheck.yml

### Drupal 8
# Prepare composer caches for Drupal 8 project creation.
RUN composer create-project drupal-composer/drupal-project:8.x-dev /tmp/tmp_drupal8 --stability dev --no-interaction && \
rm -rf /tmp/tmp_drupal8

### PlatformSH CLI
# @TODO this should be build using composer. Composer builds currently fail, so we simulate it
#        RUN composer global require platformsh/cli
#
RUN curl -L -o /app/.composer/vendor/bin/platform https://github.com/platformsh/platformsh-cli/releases/download/v3.2.2/platform.phar && \
    chmod a+x /app/.composer/vendor/bin/platform

### oh-my-zsh
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
ADD app/.zshrc /app/.zshrc
ADD app/.zshrc.d /app/.zshrc.d

USER root

RUN chown -R app:app /app

## Config

USER app
WORKDIR /app
ENTRYPOINT ["/usr/bin/ssh-agent","/bin/zsh"]

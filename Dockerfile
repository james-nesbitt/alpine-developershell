# wunder/fuzzy-alpine-devshell
#
# VERSION v7.1.5-0
#
FROM quay.io/wunder/fuzzy-alpine-php-dev:v7.1.5
MAINTAINER aleksi.johansson@wunder.io

# Set versions.
ENV COMPOSER_VERSION=1.3.1
ENV PLATFORMSH_CLI_VERSION=3.12.0
ENV TRAVIS_CI_CLI_VERSION=1.8.8

## Global

### Common developer tools
RUN apk --no-cache --update add \
      curl \
      docker \
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
      nodejs-npm \
      sudo \
      openssh \
      openssl \
      ansible \
      rsync && \
    # Cleanup
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
php7-tokenizer \
php7-zlib && \
rm -rf /tmp/* && \
rm -rf /var/cache/apk/*
ADD etc/php7/conf.d/WK_date.ini /etc/php7/conf.d/WK_date.ini

### Common theming tools
RUN npm install -g gulp grunt

### Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
php composer-setup.php --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} && \
php -r "unlink('composer-setup.php');"

## App user specific

USER app

### Install various composer packages globally, from app/.composer/composer.json
# This includes:
#   - drush
#   - drupal console
RUN mkdir /app/.composer
ADD app/.composer/composer.json /app/.composer/composer.json
RUN composer global update

### Drupal 8
# Prepare composer caches for Drupal 8 project creation and init Drupal Console.
RUN composer create-project drupal-composer/drupal-project:8.x-dev /tmp/tmp_drupal8 --stability dev --no-interaction && \
export PATH=$HOME/.composer/vendor/bin:$PATH && \
cd /tmp/tmp_drupal8 && \
composer install && \
# drupal init --override --no-interaction && \
mkdir -p ~/.config/fish/completions && \
ln -s ~/.console/drupal.fish ~/.config/fish/completions/drupal.fish && \
rm -rf /tmp/tmp_drupal8
ADD app/.console/phpcheck.yml /app/.console/phpcheck.yml

### PlatformSH CLI
# @TODO this should be built using composer. Composer builds currently fail, so we simulate it
# RUN composer global require platformsh/cli:${PLATFORMSH_CLI_VERSION}
#
RUN wget -O /app/.composer/vendor/bin/platform https://github.com/platformsh/platformsh-cli/releases/download/v${PLATFORMSH_CLI_VERSION}/platform.phar && \
chmod a+x /app/.composer/vendor/bin/platform

### Travis CI CLI
RUN gem install travis -v ${TRAVIS_CI_CLI_VERSION}

### oh-my-zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
ADD app/.zshrc /app/.zshrc
ADD app/.zshrc.d /app/.zshrc.d

USER root

RUN chown -R app:app /app

## Config

USER app
WORKDIR /app
ENTRYPOINT ["/usr/bin/ssh-agent","/bin/zsh"]

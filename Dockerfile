FROM quay.io/wunder/wunder-alpine-base:edge

#
# Developer tools
#

RUN apk --update add curl wget git vim zsh tar gzip p7zip xz nodejs sudo openssh openssl ansible && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*
ADD etc/sudoers.d/app_nopasswd /etc/sudoers.d/app_nopasswd

#
# PHP AND MySQL
#

# Update the package repository and install applications
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
apk --no-cache --update add mysql-client php7 php7-common php7-memcached php7-xml php7-xmlrpc php7-pdo php7-pdo_mysql php7-pdo_pgsql php7-pdo_sqlite php7-mysqlnd php7-mysqli php7-mcrypt php7-opcache php7-json php7-fpm php7-pear php7-mbstring php7-soap php7-ctype php7-gd php7-dom php7-phar php7-pear php7-ast php7-xdebug && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

#
# Some common nodejs tools
#

RUN npm install -g gulp grunt

#
# User specific tools
#

USER app

# Add oh-my-zsh
RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
ADD https://raw.githubusercontent.com/jeremyFreeAgent/oh-my-zsh-powerline-theme/master/powerline.zsh-theme /app/.oh-my-zsh/themes/powerline.zsh-theme
ADD app/.zshrc /app/.zshrc


#
# Cleanup
#

USER root

RUN chown -R app:app /app


#
# bootstrap configurations
#

USER app
WORKDIR /app
CMD ["/bin/zsh"]

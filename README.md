# wundertools-image-fuzzy-developershell
A developer shell and command image for Drupal Development

## Deploys to

https://quay.io/repository/wunder/wundertools-image-fuzzy-developershell

## Base

this image is based on a common alpine standard base: https://github.com/wunderkraut/wunder-alpine-base

## Purpose

This image is a single tool/command image, used to provide either run-tim command execution, or a styled running shell, that can connect to and interact with other containers.

It was written with the following goals:

1. include a bunch of usefull commands/programs that developers typically use
2. use a single image to reduce maintenance and effort (no separate drush/console/platform.sh/composer images needed)
3. concentrate non-production worthy elements here, to keep them out of production runtime service images
4. make something that is nice to use: looks good and is usefull
5. make something that someone else can steal, rework, replace, improve and/or laugh at.

* command containers should be something that any user can customize for their own preferences, but this is considered a good starting point.

## Contains

Containers

1. PHP CLI (without xdebug)
2. PHP Composer
3. NodeJS (& npm)
4. GruntJS (global)
5. GulpJS (global)
6. MariaDB Client
7. SSH/SSL
8. Git
9. Curl/Wget
10. Zip/p7zip/tar/xz/gz etc

Does not contain:
1. drush: should be a part of composer in your D8 app
2. drupal-console : should be a part of composer in your D8 app

## Usage

run this container, either as a shell or by specifying a command with flags, attach it to whatever volumes and containers you need, and get isolated command environments as you wish.

Consider binding:

1. your ssh keys
2. your .gitconfig (composer can get noisy if it doesn't have them)
3. your source code
4. drush/console/composer confs

* attach anything not disposable, as the container is meant to disappear when it is finished running.

## Notes

- You can get available php variables by running:
    docker run -ti --rm quay.io/wunder/wundertools-image-fuzzy-developershell
    php -r "phpinfo();"

## TODO

1. Add more toys
2. Maybe fork another image that includes xdebug

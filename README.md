# wundertools-image-fuzzy-developershell
A developer shell and command image for Drupal. Deploys to:

https://quay.io/repository/wunder/wundertools-image-fuzzy-developershell.

## Base

This image is based on "upstream" wunder/alpine-php image which means it shares the basic PHP configuration with other environment like production:

https://github.com/wunderkraut/wunder-alpine-base

## Purpose

This image is a single tool/command image, used to provide either run-tim command execution, or a styled running shell, that can connect to and interact with other containers.

It was written with the following goals:

1. include a bunch of useful commands/programs that developers typically use,
2. use a single image to reduce maintenance and effort (no separate drush/console/platform.sh/composer images needed),
3. concentrate non-production worthy elements here, to keep them out of production runtime service images,
4. make something that is nice to use: looks good and is useful,
5. make something that someone else can steal, rework, replace, improve and/or laugh at.

Note: Command containers should be something that any user can customize for their own preferences, but this is considered a good starting point.

## Tools

The image contains at least but not limited to the following tools:

1. PHP CLI (without xdebug),
2. PHP Composer,
3. NodeJS (& npm),
4. GruntJS (global),
5. GulpJS (global),
6. MariaDB Client,
7. SSH/SSL,
8. Git,
9. Curl/Wget,
10. Zip/p7zip/tar/xz/gz etc,
11. Drush (global),
12. and Drupal Console (global).

Note: Project specific versions of Drush and Drupal Console should be a part of composer in your Drupal 8 project.

## Usage

Run this container, either as a shell or by specifying a command with flags, attach it to whatever volumes and containers you need, and get isolated command environments as you wish.

Consider binding:

1. your ssh keys etc. in `~/.ssh`,
2. your `~/.gitconfig` (composer can get noisy if it doesn't have them),
3. your source code,
4. drush/console/composer confs.

Note: Attach anything not disposable, as the container is meant to disappear when it is finished running.

## Tips

### Console experience

You can customize the console experience to your liking or to match your host console experience easily if you use zsh as your shell.

Here is an example how to run the container with your own configuration:
~~~
docker run --rm -it -v ~/.zshrc:/app/.zshrc ~/.oh-my-zsh:/app/.oh-my-zsh quay.io/wunder/wundertools-image-fuzzy-developershell
~~~
Note: This maps your hosts `~/.zshrc` and `~/.oh-my-zsh` to the container which means that if you change them inside the container, they are changed on the host too.

You can find more examples in the `scripts` folder of this project.

## Development

- If you want to change the configuration of this image and build it locally for testing you can do that by running:
~~~
docker build --no-cache -t quay.io/wunder/wundertools-image-fuzzy-developershell .
~~~

- You can get available php variables by running:
~~~
docker run --rm -it quay.io/wunder/wundertools-image-fuzzy-developershell php -r "phpinfo();"
~~~

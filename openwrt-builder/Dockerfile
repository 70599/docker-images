FROM  alpine

RUN   set -ex \
      && apk add --update --no-cache \
      asciidoc bash bc binutils bzip2 cdrkit coreutils diffutils \
      findutils flex g++ gawk gcc gettext git grep intltool libxslt \
      linux-headers make ncurses-dev openssl-dev patch perl python2-dev \
      python3-dev rsync tar unzip util-linux wget zlib-dev

RUN   adduser -D --uid 12345 user

USER     user
WORKDIR  /home/user

RUN  git config --global user.name "user" \
     && git config --global user.email "user@openwrt-builder-in-docker"

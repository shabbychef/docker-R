# 
# Dockerfile for R.3.2.4 in alpine
#
# Based on (read _stolen from_) Dockerfiles from rocker, 
# written by Carl Boettiger and Dirk Eddelbuettel.
#
# docker build --rm -t shabbychef/rapk . 
#
# Created: 2016.03.20
# Copyright: Steven E. Pav, 2016
# Author: Steven E. Pav
# Comments: Steven E. Pav

# alpine: grrr
# http://forum.alpinelinux.org/forum/general-discussion/why-cant-i-apk-add-package-runit
# https://bugs.alpinelinux.org/issues/3920
# how to get glibc: https://github.com/gliderlabs/docker-alpine/issues/11
#
# tex mlsr.pl problems: https://bugs.alpinelinux.org/issues/4514
# possibly fixed by this: https://github.com/vvakame/docker-review/issues/3


FROM alpine:edge
#FROM alpine:latest

MAINTAINER Steven E. Pav, shabbychef@gmail.com

WORKDIR /tmp

RUN echo "@testing http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN (apk add --update \
  bash wget ca-certificates \
  autoconf automake zlib-dev \
  binutils \ 
  bison \
  g++ \
  gcc \
  gfortran \
  java-common \ 
  openjdk7-jre \
  libintl \ 
  make \ 
  m4 \ 
  xpdf \ 
  readline \
  readline-dev \
  cairo-dev \
  pango-dev \
  texinfo \ 
  poppler-dev \
  texlive@testing \ 
  texlive-dev@testing \ 
  texlive-full@testing \ 
  xz-dev \
  subversion ; \
  wget --no-check-certificate "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk" ; \
  wget --no-check-certificate "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-bin-2.21-r2.apk" ; \
  apk add --allow-untrusted glibc-2.21-r2.apk glibc-bin-2.21-r2.apk ; \
  /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib )

  #rm -rf /var/cache/apk/* )

#RUN echo $PATH  ;
#RUN echo $LD_LIBRARY_PATH ;

# Hotfix for glibc hack that fixes the order of DNS resolving (i.e. check /etc/hosts first and then lookup DNS-servers).
# To fix this we just create /etc/nsswitch.conf and add the following line:
RUN echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV R_BASE_VERSION R.3.2.4
ENV R_SVN_TAG R-3-2-4
ENV TEXI2DVI_USE_RECORDER yes

# cf https://github.com/vvakame/docker-review/issues/3
RUN (cd /usr/share ; \
  rm -rf texmf-dist ; \
  svn co svn://tug.org/texlive/trunk/Master/texmf-dist ; \
  mktexlsr ; \
  fmtutil-sys --all )

RUN (mkdir -p /usr/local/lib ; \
  mkdir -p /tmp/build ; \
  cd /tmp/build ; \
  svn co http://svn.r-project.org/R/tags/R-3-2-4/ Rsrc ; \
  cd /tmp/build/Rsrc ; \
    R_PAPERSIZE=letter \
    R_BATCHSAVE="--no-save --no-restore" \
    R_BROWSER=xdg-open \
    PAGER=/usr/bin/pager \
    PERL=/usr/bin/perl \
    R_UNZIPCMD=/usr/bin/unzip \
    R_ZIPCMD=/usr/bin/zip \
    R_PRINTCMD=/usr/bin/lpr \
    LIBnn=lib \
    AWK=/usr/bin/awk \
    CFLAGS="-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -D_FORTIFY_SOURCE=2 -g" \
    CXXFLAGS="-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -D_FORTIFY_SOURCE=2 -g" \
    ./configure --enable-R-shlib \
            --without-blas \
            --without-lapack \
            --with-readline \
            --without-recommended-packages \
            --without-x \ 
            --program-suffix=dev ; \
  cd /tmp/build/Rsrc ; \
  make ; \
  make install ; \
  cd /tmp ; \
  rm -rf /tmp/build /tmp/downloaded_packages/ /tmp/*.rds ; \
  echo "R_LIBS=\${R_LIBS-'/usr/local/lib/R/site-library:/usr/local/lib/R/library:/usr/lib/R/library'}" >> /usr/local/lib/R/etc/Renviron ; \
  echo 'options("repos"="https://cran.rstudio.com")' >> /usr/local/lib/R/etc/Rprofile.site ; \
  /usr/local/bin/R --version )

ENTRYPOINT ["/usr/local/bin/R"]

#for vim modeline: (do not edit)
# vim:et:nu:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=Dockerfile:ft=Dockerfile:fo=croql

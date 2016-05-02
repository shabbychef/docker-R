# 
# Dockerfile for R.3.1.3
#
# with a view towards shared common base with other versions?
#
# Based on (read _stolen from_) Dockerfiles from rocker, 
# written by Carl Boettiger and Dirk Eddelbuettel.
#
# docker build --rm -t shabbychef/maximalr313 . 
#
# Created: 2016.04.27
# Copyright: Steven E. Pav, 2016
# Author: Steven E. Pav
# Comments: Steven E. Pav

FROM debian:testing

MAINTAINER Steven E. Pav, shabbychef@gmail.com

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

RUN (apt-get update -qq ; \
  DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true apt-get install -q -y --no-install-recommends \
  ed locales wget ca-certificates ; \
  echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen ; \
  locale-gen en_US.utf8 ; \
  /usr/sbin/update-locale LANG=en_US.UTF-8 )

RUN (apt-get update -qq ; \
  DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true apt-get install -q -y --no-install-recommends \
  bash-completion \
  bison \
  curl \
  debhelper \
  default-jdk \
  g++ \
  gcc \
  gfortran \
  groff-base \
  libblas-dev \
  libbz2-dev \
  libcairo2-dev \
  libcurl3 \
  libcurl4-openssl-dev \
  libfreetype6-dev \
  libharfbuzz-dev \
  libjpeg-dev \
  liblapack-dev \
  liblzma-dev \
  libncurses5-dev \
  libpango1.0-dev \
  libpcre3-dev \
  libpng-dev \
  libreadline-dev \
  libtiff5-dev \
  libx11-dev \
  libxcb1-dev \
  libxdmcp-dev \
  libxt-dev \
  mpack \
  subversion \ 
  tcl8.6-dev \
  texinfo \
  texlive-base \
  texlive-fonts-recommended \
  texlive-generic-recommended \
  texlive-latex-base \
  texlive-latex-recommended \
  tk8.6-dev \
  x11proto-core-dev \
  xauth \
  xdg-utils \
  xfonts-base \
  xvfb \
  zlib1g-dev \
  curl \
  libxml2-dev \
  libssl-dev \
  pkg-config \
  libssh2-1-dev \
  pandoc \
  ghostscript \
  qpdf ;)

ENV R_BASE_VERSION R.3.1.3
ENV R_SVN_TAG R-3-1-3
ENV R_LIBS_SITE /usr/lib/R/site-library

RUN (mkdir -p /tmp/build ; \
  cd /tmp/build ; \
  svn co http://svn.r-project.org/R/tags/R-3-1-3/ Rsrc ; \
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
            --program-suffix=dev ; \
  cd /tmp/build/Rsrc ; \
  make ; \
  make install ; \
  cd /tmp ; \
  rm -rf /tmp/build /tmp/downloaded_packages/ /tmp/*.rds ; \
  mkdir -p /usr/local/lib/R/site-library /usr/local/lib/R/library /usr/lib/R/library ; \
  echo "R_LIBS=\${R_LIBS-'/usr/local/lib/R/site-library:/usr/local/lib/R/library:/usr/lib/R/library'}" >> /usr/local/lib/R/etc/Renviron ; \
  echo "R_LIBS_USER=\${R_LIBS_USER-'~/R/x86_64-pc-linux-gnu-library/%V'}" >> /usr/local/lib/R/etc/Renviron ; \
  echo "R_LIBS_SITE=\${R_LIBS_SITE-'/usr/local/lib/R/site-library:/usr/lib/R/site-library:/usr/lib/R/library'}" >> /usr/local/lib/R/etc/Renviron ; \
  echo 'options("repos"="https://cran.rstudio.com")' >> /usr/local/lib/R/etc/Rprofile.site ; \
  R --version ; \
  dpkg --purge  \
  adwaita-icon-theme \
  bash-completion\
  dash         \
  gnupg      \
  gpgv       \
  iproute2 \
  mawk       \
  mpack      \
  perl       \
  perl-base  \
  perl-modules-5 \
  python         \
  python2.7-minimal \
  subversion    \
  wget ; \
  apt-get autoremove -qy ; \
  dpkg-query -l ; \
  rm -rf /var/lib/apt/lists/* ; \
  R --version )

ENV RINST_LIBLOC /usr/local/lib/R/site-library

RUN (echo "install littler" ; \
  mkdir -p $R_LIBS_SITE ; \
  R -e 'install.packages("littler")' ; \
  [ -f /usr/local/bin/r ] || ln -s ${RINST_LIBLOC}/littler/bin/r /usr/local/bin/r ; \
  [ -f /usr/local/bin/install.r ] || ln -s ${RINST_LIBLOC}/littler/examples/install.r /usr/local/bin/install.r ; \
  [ -f /usr/local/bin/install2.r ] || ln -s ${RINST_LIBLOC}/littler/examples/install2.r /usr/local/bin/install2.r ; \
  [ -f /usr/local/bin/installGithub.r ] || ln -s ${RINST_LIBLOC}/littler/examples/installGithub.r /usr/local/bin/installGithub.r )

ENTRYPOINT ["/usr/local/bin/R"]

#for vim modeline: (do not edit)
# vim:et:nu:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=Dockerfile:ft=Dockerfile:fo=croql

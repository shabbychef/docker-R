dnl FML m4 edition
dnl this gets translated into a Dockerfile
dnl with the TAG filled in.
dnl do not overdefine anything else
dnl without quoting it first.
dnl
define(`DOTTAG',TAG)dnl
define(`DASHTAG',patsubst(DOTTAG,`\.',`-'))dnl
define(`SQUASHTAG',translit(patsubst(DOTTAG,`\.',`'),`A-Z',`a-z'))dnl
define(`LOCAL_CFLAGS',esyscmd(sh -c "R CMD config CFLAGS | tr -d '\n'"))dnl
define(`LOCAL_CXXFLAGS',esyscmd(sh -c "R CMD config CXXFLAGS | tr -d '\n'"))dnl
# 
`#' Dockerfile for DOTTAG
#
# Based on (read _stolen from_) Dockerfiles from rocker, 
# written by Carl Boettiger and Dirk Eddelbuettel.
#
`#' docker build --rm -t shabbychef/SQUASHTAG . 
changequote(`<<<',`>>>')dnl
#
# Created: 2016.03.20
# Copyright: Steven E. Pav, 2016
# Author: Steven E. Pav
# Comments: Steven E. Pav

FROM debian:testing

MAINTAINER Steven E. Pav, shabbychef@gmail.com

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV R_BASE_VERSION DOTTAG
ENV R_SVN_TAG DASHTAG

RUN (apt-get update -qq ; \
  DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true apt-get install -q -y --no-install-recommends \
  ed locales wget ca-certificates ; \
  echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen ; \
  locale-gen en_US.utf8 ; \
  /usr/sbin/update-locale LANG=en_US.UTF-8 ; \
  DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true apt-get install -q -y --no-install-recommends \
  bash-completion \
  bison \
  debhelper \
  default-jdk \
  g++ \
  gcc \
  gfortran \
  groff-base \
  libblas-dev \
  libbz2-dev \
  libcairo2-dev \
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
  zlib1g-dev ; \
  mkdir -p /tmp/build ; \
  cd /tmp/build ; \
  svn co http://svn.r-project.org/R/tags/DASHTAG/ Rsrc ; \
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
    CFLAGS="LOCAL_CFLAGS" \
    CXXFLAGS="LOCAL_CXXFLAGS" \
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
  echo "R_LIBS=\${R_LIBS-'/usr/local/lib/R/site-library:/usr/local/lib/R/library:/usr/lib/R/library'}" >> /usr/local/lib/R/etc/Renviron ; \
  echo 'options("repos"="https://cran.rstudio.com")' >> /usr/local/lib/R/etc/Rprofile.site ; \
  R --version ; \
  dpkg --purge  \
  libblas-dev \
  libbz2-dev  \
  libcairo2-dev \
  libfontconfig1-dev \
  libfreetype6-dev \
  libglib2.0-dev \
  libharfbuzz-dev \
  libjpeg-dev \
  liblapack-dev  \
  liblzma-dev \
  libncurses5-dev \
  libpango1.0-dev \
  libpcre3-dev \
  libpng12-dev \
  libreadline-dev \
  libtiff5-dev \
  libxft-dev \
  tcl8.6-dev \
  texlive-base \
  texlive-fonts-recommended \
  texlive-generic-recommended \
  texlive-latex-base \
  texlive-latex-recommended \
  tk8.6-dev \
  adwaita-icon-theme \
  bash-completion\
  binutils      \
  bison        \
  bzip2 \
  cpp          \
  cpp-5        \
  dash         \
  default-jdk  \
  default-jre  \
  default-jre-headless \
  diffutils \
  ed          \
  file       \
  findutils  \
  fontconfig \
  g++        \
  g++-5      \
  gcc        \
  gcc-4.8-base\
  gcc-4.9-base\
  gcc-5     \
  gcc-5-base\
  gnupg      \
  gpgv       \
  grep \
  inetutils-ping \ 
  iproute2 \
  m4         \
  make       \
  man-db     \
  mawk       \
  mpack      \
  perl       \
  perl-base  \
  perl-modules-5 \
  python         \
  python2.7-minimal \
  sed           \
  subversion    \
  tar           \
  tcl8.6        \
  tex-common    \
  texinfo       \
  tk8.6         \
  wget          \
  x11-common    \
  x11-utils     \
  x11-xkb-utils \
  xdg-utils     \
  x11proto-core-dev \
  x11proto-input-dev \
  x11proto-kb-dev \
  xauth \
  xkb-data \
  xorg-sgml-doctools \
  xtrans-dev \
  xfonts-base   \
  xfonts-encoding\
  xfonts-utils  \
  xvfb \
  xserver-common ;\
  apt-get autoremove -qy ; \
  R --version ; \
  dpkg-query -l ; \
  rm -rf /var/lib/apt/lists/* )

ENTRYPOINT ["/usr/local/bin/R"]

#for vim modeline: (do not edit)
# vim:et:nu:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:syn=Dockerfile:ft=Dockerfile:fo=croql

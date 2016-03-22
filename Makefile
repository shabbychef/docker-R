######################
# 
# Created: 2016.03.20
# Copyright: Steven E. Pav, 2016
# Author: Steven E. Pav
######################

############### FLAGS ###############

R_DOTVERSIONS 		 = 3.2.1 3.2.2 3.2.3 3.2.4
R_VERSIONS 				 = $(subst .,,$(R_DOTVERSIONS))
DOCKERFILES 			:= $(patsubst %,r%/Dockerfile,$(R_VERSIONS))
BUILDFILES 				:= $(patsubst %/Dockerfile,%/.built,$(DOCKERFILES))
VERSFILES 				:= $(patsubst %/Dockerfile,%/.version,$(DOCKERFILES))

############## DEFAULT ##############

default : all 

############## MARKERS ##############

.PHONY   : all build versions
.SUFFIXES: 
.PRECIOUS: %.built

############ BUILD RULES ############

all : $(DOCKERFILES)

r321/Dockerfile : Dockerfile.m4
	@mkdir -p $(@D)
	m4 -DTAG=R.3.2.1 $< > $@

r322/Dockerfile : Dockerfile.m4
	@mkdir -p $(@D)
	m4 -DTAG=R.3.2.2 $< > $@

r323/Dockerfile : Dockerfile.m4
	@mkdir -p $(@D)
	m4 -DTAG=R.3.2.3 $< > $@

r324/Dockerfile : Dockerfile.m4
	@mkdir -p $(@D)
	m4 -DTAG=R.3.2.4 $< > $@

$(BUILDFILES) : %/.built : %/Dockerfile
	docker build --rm -t shabbychef/$* $(@D)

build : $(BUILDFILES)

$(VERSFILES) : %/.version : %/.built
	docker run -it --rm shabbychef/$* "--version" > $@

versions : $(VERSFILES)

#for vim modeline: (do not edit)
# vim:ts=2:sw=2:tw=79:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:tags=.tags;:syn=make:ft=make:ai:si:cin:nu:fo=croqt:cino=p0t0c5(0:

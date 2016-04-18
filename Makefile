######################
# 
# Created: 2016.03.20
# Copyright: Steven E. Pav, 2016
# Author: Steven E. Pav
######################

############### FLAGS ###############

R_DOTVERSIONS 		 = 3.2.1 3.2.2 3.2.3 3.2.4 3.2.5
R_VERSIONS 				 = $(subst .,,$(R_DOTVERSIONS))
DOCKERFILES 			:= $(patsubst %,r%/Dockerfile,$(R_VERSIONS))
BUILDFILES 				:= $(patsubst %/Dockerfile,%/.built,$(DOCKERFILES))
VERSFILES 				:= $(patsubst %/Dockerfile,%/.version,$(DOCKERFILES))

############## DEFAULT ##############

default : dockerfiles

############## MARKERS ##############

.PHONY   : help
.PHONY   : dockerfiles buildfiles versions
.SUFFIXES: 
.PRECIOUS: %.built

############ BUILD RULES ############

help:  ## generate this help message
	@grep -P '^(([^\s]+\s+)*([^\s]+))\s*:.*?##\s*.*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

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
	
r325/Dockerfile : Dockerfile.m4
	@mkdir -p $(@D)
	m4 -DTAG=R.3.2.5 $< > $@

dockerfiles : $(DOCKERFILES)  ## make all dockerfiles

$(BUILDFILES) : %/.built : %/Dockerfile
	docker build --rm -t shabbychef/$* $(@D)

buildfiles : $(BUILDFILES)  ## build all docker images

$(VERSFILES) : %/.version : %/.built
	docker run -it --rm shabbychef/$* "--version" > $@

versions : $(VERSFILES)  ## run all docker images, dumping R version numbers

#for vim modeline: (do not edit)
# vim:ts=2:sw=2:tw=79:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:tags=.tags;:syn=make:ft=make:ai:si:cin:nu:fo=croqt:cino=p0t0c5(0:

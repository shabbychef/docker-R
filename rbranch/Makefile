######################
# 
# Created: 2016.03.20
# Copyright: Steven E. Pav, 2016
# Author: Steven E. Pav
######################

############### FLAGS ###############

# c.f. https://cran.r-project.org/bin/windows/base/old/
R_DOTVERSIONS 		 = 3.5 3.4 3.3 3.2 3.1 3.0
R_VERSIONS 				 = $(subst .,,$(R_DOTVERSIONS))
DOCKERFILES 			:= $(patsubst %,r%/Dockerfile,$(R_VERSIONS))
DOCKERIGNOREFILES 	:= $(patsubst %,r%/.dockerignore,$(R_VERSIONS))
BUILDFILES 				:= $(patsubst %/Dockerfile,%/.built,$(DOCKERFILES))
PUSHFILES 				:= $(patsubst %/Dockerfile,%/.pushed,$(DOCKERFILES))
VERSFILES 				:= $(patsubst %/Dockerfile,%/.version,$(DOCKERFILES))


DOCKER 						?= docker

UPSTREAM_NAME 		 = rbranch

############## DEFAULT ##############

.DEFAULT_GOAL 	:= help

############## MARKERS ##############

.PHONY   : help
.PHONY   : dockerfiles dockerignorefiles buildfiles versions
.SUFFIXES: 
.PRECIOUS: %.built

############ BUILD RULES ############

help:  ## generate this help message
	@grep -P '^(([^\s]+\s+)*([^\s]+))\s*:.*?##\s*.*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# R 3.0.X
r30/Dockerfile : Dockerfile.m4
	@mkdir -p $(@D)
	m4 -DTAG=R.3.0.branch $< > $@

# R 3.1.X
r31/Dockerfile : Dockerfile.m4
	@mkdir -p $(@D)
	m4 -DTAG=R.3.1.branch $< > $@

# R 3.2.X
r32/Dockerfile : Dockerfile.m4
	@mkdir -p $(@D)
	m4 -DTAG=R.3.2.branch $< > $@

# R 3.3.X
r33/Dockerfile : Dockerfile.m4
	@mkdir -p $(@D)
	m4 -DTAG=R.3.3.branch $< > $@

# R 3.4.X
r34/Dockerfile : Dockerfile.m4
	@mkdir -p $(@D)
	m4 -DTAG=R.3.4.branch $< > $@

# R 3.5.X
r35/Dockerfile : Dockerfile.m4
	@mkdir -p $(@D)
	m4 -DTAG=R.3.5.branch $< > $@

dockerfiles : $(DOCKERFILES) ## generate the Dockerfiles from macro 

%/.dockerignore :
	@-/bin/echo -e ".built\n.version\n.pushed" > $@

dockerignorefiles : $(DOCKERIGNOREFILES) ## generate all the .dockerignore files

#$(DOCKER) build --rm -t shabbychef/$* $(@D)

$(BUILDFILES) : %/.built : %/Dockerfile
	$(DOCKER) build --rm -t shabbychef/$(UPSTREAM_NAME):$$(echo '$*' | perl -pe 's/^.+(\d)(\d)/$$1.$$2/;') $(@D)
	touch $@

buildfiles : $(BUILDFILES) ## build the Docker images

$(PUSHFILES) : %/.pushed : %/.built
	$(DOCKER) push shabbychef/$(UPSTREAM_NAME):$$(echo '$*' | perl -pe 's/^.+(\d)(\d)/$$1.$$2/;') 
	touch $@

pushfiles : $(PUSHFILES) ## push the Docker images to docker hub

$(VERSFILES) : %/.version : %/.built
	$(DOCKER) run -it --rm shabbychef/$* "--version" > $@

versions : $(VERSFILES) ## run the Docker images to get R versions

#for vim modeline: (do not edit)
# vim:ts=2:sw=2:tw=129:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:tags=.tags;:syn=make:ft=make:ai:si:cin:nu:fo=croqt:cino=p0t0c5(0:

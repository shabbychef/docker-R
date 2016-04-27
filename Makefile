######################
# 
# Created: 2016.03.20
# Copyright: Steven E. Pav, 2016
# Author: Steven E. Pav
######################

############### FLAGS ###############

# c.f. https://cran.r-project.org/bin/windows/base/old/
R_DOTVERSIONS 		 = 3.0.0 3.0.1 3.0.2 3.0.3 
R_DOTVERSIONS 		+= 3.1.0 3.1.1 3.1.2 3.1.3 
R_DOTVERSIONS 		+= 3.2.0 3.2.1 3.2.2 3.2.3 3.2.4 3.2.5
R_VERSIONS 				 = $(subst .,,$(R_DOTVERSIONS))
DOCKERFILES 			:= $(patsubst %,r%/Dockerfile,$(R_VERSIONS))
BUILDFILES 				:= $(patsubst %/Dockerfile,%/.built,$(DOCKERFILES))
PUSHFILES 				:= $(patsubst %/Dockerfile,%/.pushed,$(DOCKERFILES))
VERSFILES 				:= $(patsubst %/Dockerfile,%/.version,$(DOCKERFILES))

############## DEFAULT ##############

.DEFAULT_GOAL 	:= help

############## MARKERS ##############

.PHONY   : help
.PHONY   : dockerfiles buildfiles versions
.SUFFIXES: 
.PRECIOUS: %.built

############ BUILD RULES ############

help:  ## generate this help message
	@grep -P '^(([^\s]+\s+)*([^\s]+))\s*:.*?##\s*.*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


# R 3.0.X
r300/Dockerfile : Dockerfile.m4
	@mkdir -p $(@D)
	m4 -DTAG=R.3.0.0 $< > $@

r301/Dockerfile : Dockerfile.m4
	@mkdir -p $(@D)
	m4 -DTAG=R.3.0.1 $< > $@

r302/Dockerfile : Dockerfile.m4
	@mkdir -p $(@D)
	m4 -DTAG=R.3.0.2 $< > $@

r303/Dockerfile : Dockerfile.m4
	@mkdir -p $(@D)
	m4 -DTAG=R.3.0.3 $< > $@

# R 3.1.X
r310/Dockerfile : Dockerfile.m4
	@mkdir -p $(@D)
	m4 -DTAG=R.3.1.0 $< > $@

r311/Dockerfile : Dockerfile.m4
	@mkdir -p $(@D)
	m4 -DTAG=R.3.1.1 $< > $@

r312/Dockerfile : Dockerfile.m4
	@mkdir -p $(@D)
	m4 -DTAG=R.3.1.2 $< > $@

r313/Dockerfile : Dockerfile.m4
	@mkdir -p $(@D)
	m4 -DTAG=R.3.1.3 $< > $@

# R 3.2.X
r320/Dockerfile : Dockerfile.m4
	@mkdir -p $(@D)
	m4 -DTAG=R.3.2.0 $< > $@

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


dockerfiles : $(DOCKERFILES) ## generate the Dockerfiles from macro 

$(BUILDFILES) : %/.built : %/Dockerfile
	docker build --rm -t shabbychef/$* $(@D)
	docker build --rm -t shabbychef/rminimal:$$(echo '$*' | perl -pe 's/^.+(\d)(\d)(\d)/$$1.$$2.$$3/;') $(@D)
	touch $@

buildfiles : $(BUILDFILES) ## build the Docker images

$(PUSHFILES) : %/.pushed : %/.built
	docker push shabbychef/rminimal:$$(echo '$*' | perl -pe 's/^.+(\d)(\d)(\d)/$$1.$$2.$$3/;') 
	touch $@

pushfiles : $(PUSHFILES) ## push the Docker images to docker hub

$(VERSFILES) : %/.version : %/.built
	docker run -it --rm shabbychef/$* "--version" > $@

versions : $(VERSFILES) ## run the Docker images to get R versions

#for vim modeline: (do not edit)
# vim:ts=2:sw=2:tw=79:fdm=marker:fmr=FOLDUP,UNFOLD:cms=#%s:tags=.tags;:syn=make:ft=make:ai:si:cin:nu:fo=croqt:cino=p0t0c5(0:

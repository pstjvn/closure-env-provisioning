
### Directories
SRC_DIR = src/
LIB_DIR = library/
COMPILER_DIR = compiler/
TEMPLATES_DIR = templates/
STYELSHEETS_DIR = stylesheets/
POLYMER_RENAMER_DIR = polymerrenamer/
GJSLINT_DIR = linter/

### Repos
POLYMER_RENAMER_REPO="git@github.com:PolymerLabs/PolymerRenamer.git"


all: env lib soy gss gcc pr gjslint deps

# The closure js library.
lib:
	if [ ! -d "$(LIB_DIR)" ]; then \
	git clone git@github.com:google/closure-library.git $(LIB_DIR); \
	else cd $(LIB_DIR) && git pull; fi

# The jscompiler (aka closure compiler).
gcc:
	if [ ! -d "$(COMPILER_DIR)" ]; then \
		mkdir $(COMPILER_DIR); fi && \
	cd $(COMPILER_DIR) && \
	if [ ! -d "$(SRC_DIR)" ]; then \
		git clone git@github.com:google/closure-compiler.git $(SRC_DIR); \
	fi && \
	cd $(SRC_DIR) && \
	git remote update && \
	if [ $(shell git rev-parse @) != $(shell git rev-parse @{u}) ]; then \
		git pull && \
		ant clean && \
		ant jar && \
		cp build/compiler.jar ../ ; \
	fi

# The closure stylesheet related jars.
gss:
	if [ ! -d "$(STYELSHEETS_DIR)" ]; then \
		mkdir $(STYELSHEETS_DIR); fi && \
	cd $(STYELSHEETS_DIR) && \
	if [ ! -d "$(SRC_DIR)" ]; then \
		git clone git@github.com:google/closure-stylesheets.git $(SRC_DIR); \
	fi && \
	cd $(SRC_DIR) && \
	git remote update && \
	if [ $(shell git rev-parse @) != $(shell git rev-parse @{u}) ]; then \
		git pull && \
		ant clean && \
		ant jar && \
		cp build/closure-stylesheets.jar ../ ; \
	fi

# The closure templates related jars.
soy: library
	if [ ! -d "$(TEMPLATES_DIR)" ]; then \
		mkdir $(TEMPLATES_DIR); fi && \
	cd $(TEMPLATES_DIR) && \
	if [ ! -d "$(SRC_DIR)" ]; then \
		git clone git@github.com:google/closure-templates.git $(SRC_DIR); \
	fi && \
	cd $(SRC_DIR) && \
	git remote update && \
	if [ $(shell git rev-parse @) != $(shell git rev-parse @{u}) ]; then \
		git pull && \
		mvn clean && \
		mvn package -Dmaven.test.skip=true && \
		cp target/*SoyToJsSrcCompiler.jar ../SoyToJsSrcCompiler.jar && \
		cp target/*SoyMsgExtractor.jar ../SoyMsgExtractor.jar && \
		cp target/soyutils_usegoog.js ../ && \
		cd ../ && \
		python ../library/closure/bin/build/depswriter.py \
		--path_with_depspath="soyutils_usegoog.js ../../../templates/soyutils_usegoog.js" \
		--output_file=deps.js ; \
	fi

# The Google JS linter
gjslint:
	if [ ! -d "$(GJSLINT_DIR)" ]; then \
		git clone git@github.com:google/closure-linter.git $(GJSLINT_DIR); \
	fi && \
	cd $(GJSLINT_DIR) && \
	git remote update && \
	if [ $(shell git rev-parse @) != $(shell git rev-parse @{u}) ]; then \
		git pull && \
		python ./setup.py install --user ; \
	fi


# PolymerRenamer
pr:
	if [ ! -d "$(POLYMER_RENAMER_DIR)" ]; then \
		mkdir $(POLYMER_RENAMER_DIR); \
	fi && \
	cd $(POLYMER_RENAMER_DIR) && \
	if [ ! -d "$(SRC_DIR)" ]; then \
		git clone $(POLYMER_RENAMER_REPO) $(SRC_DIR); \
	fi && \
	cd $(SRC_DIR) && \
	git remote update && \
	if [ $(shell git rev-parse @) != $(shell git rev-parse @{u}) ]; then \
		git pull && ant clean && ant jar && \
		cp PolymerRenamer.jar ../ ; \
	fi

# Siple recipe to check for the needed prerequisits before attempting
# a real build of the environment.
env:
	@which java python node git mvn ant npm &> /dev/null


# Groups the third party deps into a single recipe.
deps: pstjlib externs smjslib

# Creates the apps directory, used to all non-google dependecnies.
apps/:
	mkdir apps/

# Pulls in the pstj library as dependency. We assume that most projects will need that.
pstjlib: apps/
	cd apps/ && \
	if [ ! -d "pstj" ]; then git clone git@github.com:pstjvn/pstj-closure.git pstj; \
	else cd pstj && git pull; fi

# Pulls in the latest externs
externs: apps/
	cd apps/ && \
	if [ ! -d "externs" ]; then git clone git@github.com:pstjvn/gcc-externs.git externs; \
	else cd externs && git pull; fi

# Pulls in the smjs library. Most projects will not use that, but it is included in the
# default Makefile of the seed project, so we pull it for now. Once that dependency is
# removed it can be removed from here as well.
smjslib: apps/
	cd apps/ && \
	if [ ! -d "smjs" ]; then git clone git@github.com:pstjvn/smjslib.git smjs; \
	else cd pstj && git pull; fi


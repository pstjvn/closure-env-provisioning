
# Variables
SRC_DIR = src/
LIB_DIR = library/
COMPILER_DIR = compiler/
TEMPLATES_DIR = templates/
STYELSHEETS_DIR = stylesheets/

all: env lib soy gss gcc

# Targets
lib:
	if [ ! -d "$(LIB_DIR)" ]; then \
	git clone git@github.com:google/closure-library.git $(LIB_DIR); \
	else cd $(LIB_DIR) && git pull; fi

gcc:
	if [ ! -d "$(COMPILER_DIR)" ]; then mkdir $(COMPILER_DIR); fi && \
	cd $(COMPILER_DIR) && \
	if [ -d "$(SRC_DIR)" ]; then rm -rf $(SRC_DIR); fi && \
	git clone git@github.com:google/closure-compiler.git $(SRC_DIR) && \
	cd $(SRC_DIR) && \
	ant clean && \
	ant jar && \
	cp build/compiler.jar ../ && \
	cd ../ && \
	rm -rf $(SRC_DIR)

gss:
	if [ ! -d "$(STYELSHEETS_DIR)" ]; then mkdir $(STYELSHEETS_DIR); fi && \
	cd $(STYELSHEETS_DIR) && \
	if [ -d "$(SRC_DIR)" ]; then rm -rf $(SRC_DIR); fi && \
	git clone git@github.com:google/closure-stylesheets.git $(SRC_DIR) && \
	cd $(SRC_DIR) && \
	ant clean && \
	ant jar && \
	cp build/closure-stylesheets.jar ../ && \
	cd ../ && \
	rm -rf $(SRC_DIR)

soy: library
	if [ ! -d "$(TEMPLATES_DIR)" ]; then mkdir $(TEMPLATES_DIR); fi && \
	cd $(TEMPLATES_DIR) && \
	if [ -d "$(SRC_DIR)" ]; then rm -rf $(SRC_DIR); fi && \
	git clone git@github.com:google/closure-templates.git $(SRC_DIR) && \
	cd $(SRC_DIR) && \
	mvn clean && \
	mvn package -Dmaven.test.skip=true && \
	cp target/*SoyToJsSrcCompiler.jar ../SoyToJsSrcCompiler.jar && \
	cp target/*SoyMsgExtractor.jar ../SoyMsgExtractor.jar && \
	cp target/soyutils_usegoog.js ../ && \
	cd ../ && \
	rm -rf $(SRC_DIR) && \
	python ../library/closure/bin/build/depswriter.py \
	--path_with_depspath="soyutils_usegoog.js ../../../templates/soyutils_usegoog.js" \
	--output_file=deps.js

env:
	@which java python node git mvn ant npm &> /dev/null
	if [ ! -d "apps" ]; then mkdir "apps"; fi
	cd apps/ && \
	if [ ! -d "pstj" ]; then git clone git@github.com:pstjvn/pstj-closure.git pstj; \
	else cd pstj && git pull; fi
	cd apps/ && \
	if [ ! -d "smjs" ]; then git clone git@github.com:pstjvn/smjslib.git smjs; \
	else cd pstj && git pull; fi



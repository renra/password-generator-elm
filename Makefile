APP_NAME=PasswordGenerator

JS_INPUT=src/elm/${APP_NAME}.elm
JS_OUTPUT=src/app.js
JS_MIN_OUTPUT=${JS_OUTPUT}.min
JS_MIN_GZIPPED_OUTPUT=${JS_MIN_OUTPUT}.gz

CSS_INPUT=src/scss/${APP_NAME}.scss
CSS_OUTPUT=src/app.css
CSS_MIN_OUTPUT=${CSS_OUTPUT}.min
CSS_MIN_GZIPPED_OUTPUT=${CSS_MIN_OUTPUT}.gz

ELM='node_modules/elm/bin/elm'
ELM_FORMAT='node_modules/elm-format/unpacked_bin/elm-format'
SASS='node_modules/sass/sass.js'

.DEFAULT_GOAL := dev
.PHONY: clean
.PHONY: clean_js
.PHONY: clean_css

clean: clean_js clean_css

clean_js:
	rm -rf ${JS_OUTPUT} ${JS_MIN_OUTPUT} ${JS_MIN_GZIPPED_OUTPUT}

clean_css:
	rm -rf ${CSS_OUTPUT} ${CSS_MIN_OUTPUT} ${CSS_MIN_GZIPPED_OUTPUT}


# Development #

dev: compile_to_js_for_development compile_to_css_for_development

compile_to_js_for_development: clean_js
	${ELM} make ${JS_INPUT} --output=${JS_OUTPUT}

compile_to_css_for_development: clean_js
	${SASS} --no-source-map ${CSS_INPUT}:${CSS_OUTPUT}


# Production #

build: clean compile_to_js uglify_js gzip_js compile_to_css gzip_css

compile_to_js:
	elm make ${JS_INPUT} --optimize --output=${JS_OUTPUT}

uglify_js:
	uglifyjs ${JS_OUTPUT} --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output=${JS_MIN_OUTPUT}

gzip_js:
	yes | gzip --keep --best --force ${JS_MIN_OUTPUT} > ${JS_MIN_GZIPPED_OUTPUT}

compile_to_css:
	sass --no-source-map ${CSS_INPUT}:${CSS_MIN_OUTPUT} --style compressed

gzip_css:
	yes | gzip --keep --best --force ${CSS_MIN_OUTPUT} > ${CSS_MIN_GZIPPED_OUTPUT}

format:
	${ELM_FORMAT} src/elm --yes

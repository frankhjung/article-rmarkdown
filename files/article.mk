#!/usr/bin/make

SHELL := /bin/bash
PROJECT := $(notdir $(CURDIR))
HTML_OUT := public/article.html
PDF_OUT := public/$(PROJECT).pdf

.PHONY: default article.html pdf clean

.DEFAULT_GOAL := article.html

# HTML target

default: article.html

article.html: article.Rmd make.R files/article.css
	@mkdir -p public
	@R --quiet --slave --vanilla --file=make.R --args article.Rmd $(HTML_OUT)

# PDF target

pdf: $(PDF_OUT)

$(PDF_OUT): article.Rmd make.R files/preamble.tex
	@mkdir -p public
	@R --quiet --slave --vanilla --file=make.R --args article.Rmd $(PDF_OUT)

$(PROJECT).pdf: $(PDF_OUT)

.PHONY: clean
clean:
	@$(RM) *.log
	@$(RM) -rf public/

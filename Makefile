CXX = clang++
CXX = g++-4.7.2
CXXFLAGS = $(shell root-config --cflags) --std=c++11 -Wall -Werror -include code/decls.h
LDFLAGS  = $(shell root-config --libs)
SHELL := bash

#slides.pdf: slides.pdci check
slides.pdf: slides.pdc check
	pandoc -o $@ $< \
	  -V colortheme:whale \
	  -t beamer \
	  -H <(echo '\setbeamertemplate{navigation symbols}{}') \
	  -H <(echo '\setbeamertemplate{footline}[page number]') \
	  -H <(echo '\setbeamertemplate{items}[circle]') \
	  -H <(echo '\usefonttheme{structurebold}') \
	  -V fontsize:xcolor=dvipsnames \
	  -H <(echo '\usecolortheme[named=RoyalBlue]{structure}') \
	  -H <(echo '\usepackage[]{pxfonts}') \
	  -H <(echo '\usepackage[default]{cantarell}') \
	  -H <(echo '\usepackage{microtype}') \
	  -H <(echo '\usepackage{inconsolata}') \
	  -H <(echo '\definecolor{links}{HTML}{646464}') \
	  -H <(echo '\hypersetup{colorlinks,linkcolor=,urlcolor=links}') \
	  -H <(echo '\subtitle{ROOT Users Workshop 2013}') \
	  -H <(echo '\institute{Stony Brook University}') \
	  --highlight-style=tango \
	  --highlight-style=zenburn \
	  --highlight-style=haddock \
	  --highlight-style=kate \
	  --highlight-style=pygments \
	  --indented-code-class=Cpp,numberLines

slides.pdci: slides.pdc get_code $(wildcard code/*.cpp)
	cat $< | ./get_code > $@

check: slides.pdc
	@(set -e; \
	  for f in `grep '\{include' $^ | cut -d'"' -f2 | grep cpp$$`; do \
	  newname=`dirname $$f`/`basename $$f .cpp`.o; \
	  make $$newname; \
	  done)

get_code: get_code.hs
	@ghc -O2 $@

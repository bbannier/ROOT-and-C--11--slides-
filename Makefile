CXX = clang++
CXX = g++-4.7.2
CXXFLAGS = $(shell root-config --cflags) --std=c++11 -Wall -Werror -include code/decls.h
LDFLAGS  = $(shell root-config --libs)
SHELL := bash

slides.pdf: slides.pdci
	pandoc -o slides.pdf $< \
	  -V graphics \
	  -t beamer \
	  -H <(echo '\setbeamertemplate{navigation symbols}{}\setbeamertemplate{footline}[page number]') \
	  --highlight-style=tango \
	  --indented-code-class=Cpp,numberLines

slides.pdci: slides.pdc get_code
	cat $< | ./get_code > $@

check: slides.pdc
	@(set -e; \
	  for f in `grep '\{include' $^ | cut -d'"' -f2 | grep cpp$$`; do \
	  newname=`dirname $$f`/`basename $$f .cpp`.o; \
	  make $$newname; \
	  done)

get_code: get_code.hs
	@ghc -O2 $@

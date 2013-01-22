CXX = clang++
CXX = g++-4.7.2
CXXFLAGS = $(shell root-config --cflags) --std=c++11 -Wall
LDFLAGS  = $(shell root-config --libs)
SHELL := bash

#SRC = test.cpp promise.cpp
SRC = $(wildcard *.cpp)
BIN = $(SRC:.cpp=)

slides.pdf: slides.pdci
	pandoc -o slides.pdf $< \
	  -V graphics \
	  -t beamer \
	  -H <(echo '\setbeamertemplate{navigation symbols}{}\setbeamertemplate{footline}[page number]') \
	  --highlight-style=tango \
	  --indented-code-class=Cpp,numberLines

slides.pdci: slides.pdc
	cat $^ | runhaskell get_code.hs > $@

test_samples: slides.pdc
	@(for f in `grep '\{include' $^ | cut -d'"' -f2`; do \
	  cat $$f > sample.cpp; \
	  make sample; \
	  ./sample; \
	  done)

all: slides.pdc $(BIN)

check: $(BIN)
	@(for b in $(BIN); do ./$$b; done)

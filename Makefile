CXX = clang++
CXX = g++-4.7.2
CXXFLAGS = $(shell root-config --cflags) --std=c++11 -Wall
LDFLAGS  = $(shell root-config --libs)
SHELL := bash

#SRC = test.cpp promise.cpp
SRC = $(wildcard *.cpp)
BIN = $(SRC:.cpp=)

all: slides.pdc $(BIN)
	pandoc -o slides.pdf $< \
	  -V graphics \
	  -t beamer \
	  -H <(echo '\setbeamertemplate{navigation symbols}{}\setbeamertemplate{footline}[page number]') \
	  --highlight-style=tango \
	  --indented-code-class=Cpp,numberLines

check: $(BIN)
	@(for b in $(BIN); do ./$$b; done)

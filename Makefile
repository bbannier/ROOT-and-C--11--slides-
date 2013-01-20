CXX = clang++
CXX = g++-4.7.2
CXXFLAGS = $(shell root-config --cflags) --std=c++11 -Wall -fpermissive
LDFLAGS  = $(shell root-config --libs)

#SRC = test.cpp promise.cpp
SRC = $(wildcard *.cpp)
BIN = $(SRC:.cpp=)

check: $(BIN)
	@(for b in $(BIN); do ./$$b; done)

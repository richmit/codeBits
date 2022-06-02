
# Fix for local needs
FC       = g77
CC       = gcc
CXX      = g++
FFLAGS   = -Wall -Wimplicit
CFLAGS   = -Wall
CXXFLAGS = -Wall

# Uncomment to build all when make file changes
#SPECDEP=makefile

# Put targets here
TARGETS = 

all : $(TARGETS)
	@echo Make Complete

clean :
	rm -rf a.out *~ *.bak $(TARGETS)
	@echo Make Complete

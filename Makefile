# File Name:            Makefile
# Project Name: 	hello-world
# Date:                 02/24/2021
# Author:               Karinabob
# Version:              1.0
# Copyright:            2021, All Rights Reserved
#
# Description:
#	Makefile for basic C++ hello world program

#compiler, compiler flags
CXX = g++
CXXFLAGS = -Wall 

#project name for backup target
PROJECTNAME = hello-world

#executable name
EXEC = helloworld

#define files needed to build executable (source, headers, and object files)
SRCS = $(wildcard *.cc)
HEADERS = $(wildcard *.h)
OBJS := $(patsubst %.cc,%.o,$(SRCS))

#these targets don't create files that Make should inspect
.PHONY: all clean backup

#default target
all: $(EXEC)

# remove unnecessary files
clean:
	rm -f $(OBJS) *.d *.d* *~ $(EXEC) \#*

# Create "dependency" files via the preprocessor. The dependency files include all header
# files that any given .cc file #includes. If any header file changes, it will recompile
# all the .cc files that included the header file. 

# Pattern for .d files.
%.d:%.cc
	@echo
	@echo Updating .d Dependency File
	@set -e; rm -f $@; \
	$(CXX) -MM $(CPPFLAGS) $< > $@.$$$$; \
	sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
	rm -f $@.$$$$
	@echo

#links the files
$(EXEC): $(OBJS)
	$(CXX) -o $(EXEC) $(OBJS)
	@echo
	@echo Linking $(OBJS) into $(EXEC)
	@echo

# make "restarts" if it had to change (or create) any .d files.  The "restart" allows make
# make to re-read the dependency files after that were created or changed.
Makefile: $(SRCS:.cc=.d)

#backup target
backup: clean
	@echo
	@mkdir -p /BACKUP FILE PATH; chmod 700 /BACKUP FILE PATH
	@$(eval CURDIRNAME := $(shell basename `pwd`))
	@$(eval MKBKUPNAME := /BACKUP FILE PATH/$(PROJECTNAME)-$(shell date +'%Y.%m.%d-%H:%M:%S').tar.gz)
	@echo Writing Backup file to: $(MKBKUPNAME)
	@-tar zcfv $(MKBKUPNAME) ../$(CURDIRNAME)
	@chmod 600 $(MKBKUPNAME)
	@echo Done!
	@echo

# Include the dependency files created by the PreProcessor. The dash in front of 
# the command keeps the system from complaining if the files do not exist. This 
# rule is used in conjunction with the "Makefile" target above.
-include $(SRCS:.cc=.d)

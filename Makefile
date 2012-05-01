# makefile discription.
# basic build file for mruby

# compiler, linker (gcc)
CC = gcc
LL = gcc

TARGET_CC = $(CC)
TARGET_LL = $(LL)
TARGET_CFLAGS =

# Compiler and Linker for Android ARM
android: TARGET_CC = arm-linux-androideabi-gcc
android: TARGET_LL = arm-linux-androideabi-gcc

# Compiler Flags for Android armeabi-v7a
android: TARGET_CFLAGS = -march=armv7-a -mfloat-abi=softfp

DEBUG_MODE = 1
ifeq ($(DEBUG_MODE),1)
CFLAGS = -g -O3
else
CFLAGS = -O3
endif
ALL_CFLAGS = -Wall -Werror-implicit-function-declaration $(CFLAGS)
ifeq ($(OS),Windows_NT)
  MAKE_FLAGS = --no-print-directory CC=$(CC) LL=$(LL) ALL_CFLAGS='$(ALL_CFLAGS)'
else
  MAKE_FLAGS = --no-print-directory CC='$(CC)' LL='$(LL)' ALL_CFLAGS='$(ALL_CFLAGS)'
endif

##############################
# generic build targets, rules
.PHONY : all
all :
	@$(MAKE) -C src $(MAKE_FLAGS)

.PHONY : android
android :
	@$(MAKE) -C tools/mrbc $(MAKE_FLAGS)
	rm tools/mrbc/*.o
	rm src/*.o
	@$(MAKE) -C mrblib $(MAKE_FLAGS) TARGET_CC='$(TARGET_CC)' TARGET_LL='$(TARGET_LL)' TARGET_CFLAGS='$(TARGET_CFLAGS)'
	@$(MAKE) -C src $(MAKE_FLAGS) TARGET_CC='$(TARGET_CC)' TARGET_LL='$(TARGET_LL)' TARGET_CFLAGS='$(TARGET_CFLAGS)'

# clean up
.PHONY : clean
clean :
	@$(MAKE) clean -C src $(MAKE_FLAGS)
	@$(MAKE) clean -C tools/mruby $(MAKE_FLAGS)

# parameters:
CC   = gcc
CPP  = g++

INCS = -Iinclude -Ilib
CFLAGS = $(INCS) -Os
CPPFLAGS = $(INCS) -Os

LDFLAGS = -lz -pthread -lexpat
CFLAGS += -fPIC -shared -Wl,-soname,$@ $(STRIPFLAG) -DUSE_MINIZIP
XLSXIO_OBJ = lib/xlsxio_read.o lib/xlsxio_read_sharedstrings.o lib/xlsxio_write.o  lib/unzip.o lib/ioapi.o lib/zip.o
EXAMPLES_OBJ = examples
EXAMPLES_BIN =

LIBLIST = libxlsxio.so
TOOLS_BIN = xlsxio_xlsx2csv$(BINEXT) xlsxio_csv2xlsx$(BINEXT)

EXAMPLES_BIN_LIST = example_xlsxio_write$(BINEXT) \
				example_xlsxio_read$(BINEXT) \
				example_xlsxio_write_getversion$(BINEXT) \
				example_xlsxio_read_advanced$(BINEXT) \
				xlsxio_read_main$(BINEXT) \
				xlsxio_csv2xlsx$(BINEXT) \
				xlsxio_xlsx2csv$(BINEXT)
SOURCE_PACKAGE_FILES = Makefile include/*.h lib/*.c lib/*.h  examples/*.c

default: all

all: shared-lib examples install

%.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS)

%.o: %.c
	$(CC) -c -o $@ $< $(CFLAGS)

shared-lib: $(LIBLIST)

$(LIBLIST): $(XLSXIO_OBJ)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS) $(LIBS)

examples: $(EXAMPLES_BIN_LIST)

example_xlsxio_write_getversion$(BINEXT): $(EXAMPLES_OBJ)/example_xlsxio_write_getversion.o
	$(CC) -o $@ $^ $(LIBLIST)

example_xlsxio_write$(BINEXT): $(EXAMPLES_OBJ)/example_xlsxio_write.o
	$(CC) -o $@ $^ $(LIBLIST)

example_xlsxio_read$(BINEXT): $(EXAMPLES_OBJ)/example_xlsxio_read.o
	$(CC) -o $@ $^ $(LIBLIST)

example_xlsxio_read_advanced$(BINEXT): $(EXAMPLES_OBJ)/example_xlsxio_read_advanced.o
	$(CC) -o $@ $^ $(LIBLIST)

xlsxio_read_main$(BINEXT): $(EXAMPLES_OBJ)/xlsxio_read_main.o
	$(CC) -o $@ $^ $(LIBLIST)

xlsxio_xlsx2csv$(BINEXT): $(EXAMPLES_OBJ)/xlsxio_xlsx2csv.o
	$(CC) -o $@ $^ $(LIBLIST)

xlsxio_csv2xlsx$(BINEXT): $(EXAMPLES_OBJ)/xlsxio_csv2xlsx.o
	$(CC) -o $@ $^ $(LIBLIST)

install:
	mkdir -p build
	mv $(EXAMPLES_BIN_LIST) build/
	mv $(LIBLIST) build/
	$(RM) lib/*.o examples/*.o

.PHONY: clean
clean:
	$(RM) lib/*.o examples/*.o build/$(EXAMPLES_BIN_LIST)


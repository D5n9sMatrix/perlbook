## Process this file with automake to produce Makefile.in

## Created by Anjuta


uidir = $(pkgdatadir)/ui
ui_DATA = book.ui


AM_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\" \
	$(BOOK_CFLAGS)

AM_CFLAGS =\
	 -Wall\
	 -g

bin_PROGRAMS = book

book_SOURCES = \
	main.c \
	book.h \
	book.c	


book_LDFLAGS =

book_LDADD = $(BOOK_LIBS)


if PLATFORM_WIN32
book_LDFLAGS += -Wl,--export-all-symbols
else
book_LDFLAGS += -Wl,--export-dynamic
endif

if NATIVE_WIN32
book_LDFLAGS += -mwindows
endif


EXTRA_DIST = $(ui_DATA)

# Remove ui directory on uninstall
uninstall-local:
	-rm -r $(uidir)
	-rm -r $(pkgdatadir)


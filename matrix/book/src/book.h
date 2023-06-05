/* -*- Mode: C; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * book.h
 * Copyright (C) 2021 denis <denis@denis-Inspiron-15-3567>
 * 
 * book is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * book is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef _BOOK_
#define _BOOK_

#include <gtk/gtk.h>

G_BEGIN_DECLS

#define BOOK_TYPE_APPLICATION             (book_get_type ())
#define BOOK_APPLICATION(obj)             (G_TYPE_CHECK_INSTANCE_CAST ((obj), BOOK_TYPE_APPLICATION, Book))
#define BOOK_APPLICATION_CLASS(klass)     (G_TYPE_CHECK_CLASS_CAST ((klass), BOOK_TYPE_APPLICATION, BookClass))
#define BOOK_IS_APPLICATION(obj)          (G_TYPE_CHECK_INSTANCE_TYPE ((obj), BOOK_TYPE_APPLICATION))
#define BOOK_IS_APPLICATION_CLASS(klass)  (G_TYPE_CHECK_CLASS_TYPE ((klass), BOOK_TYPE_APPLICATION))
#define BOOK_APPLICATION_GET_CLASS(obj)   (G_TYPE_INSTANCE_GET_CLASS ((obj), BOOK_TYPE_APPLICATION, BookClass))

typedef struct _BookClass BookClass;
typedef struct _Book Book;
typedef struct _BookPrivate BookPrivate;

struct _BookClass
{
	GtkApplicationClass parent_class;
};

struct _Book
{
	GtkApplication parent_instance;

	BookPrivate *priv;

};

GType book_get_type (void) G_GNUC_CONST;
Book *book_new (void);

/* Callbacks */

G_END_DECLS

#endif /* _APPLICATION_H_ */


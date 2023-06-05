/* -*- Mode: C; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * book.c
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
#include "book.h"

#include <glib/gi18n.h>



/* For testing propose use the local (not installed) ui file */
/* #define UI_FILE PACKAGE_DATA_DIR"/ui/book.ui" */
#define UI_FILE "src/book.ui"
#define TOP_WINDOW "window"


G_DEFINE_TYPE (Book, book, GTK_TYPE_APPLICATION);

/* ANJUTA: Macro BOOK_APPLICATION gets Book - DO NOT REMOVE */
struct _BookPrivate
{
	/* ANJUTA: Widgets declaration for book.ui - DO NOT REMOVE */
};

/* Create a new window loading a file */
static void
book_new_window (GApplication *app,
                           GFile        *file)
{
	GtkWidget *window;

	GtkBuilder *builder;
	GError* error = NULL;

	BookPrivate *priv = BOOK_APPLICATION(app)->priv;

	/* Load UI from file */
	builder = gtk_builder_new ();
	if (!gtk_builder_add_from_file (builder, UI_FILE, &error))
	{
		g_critical ("Couldn't load builder file: %s", error->message);
		g_error_free (error);
	}

	/* Auto-connect signal handlers */
	gtk_builder_connect_signals (builder, app);

	/* Get the window object from the ui file */
	window = GTK_WIDGET (gtk_builder_get_object (builder, TOP_WINDOW));
        if (!window)
        {
		g_critical ("Widget \"%s\" is missing in file %s.",
				TOP_WINDOW,
				UI_FILE);
        }

	
	/* ANJUTA: Widgets initialization for book.ui - DO NOT REMOVE */

	g_object_unref (builder);
	
	
	gtk_window_set_application (GTK_WINDOW (window), GTK_APPLICATION (app));
	if (file != NULL)
	{
		/* TODO: Add code here to open the file in the new window */
	}

	gtk_widget_show_all (GTK_WIDGET (window));
}


/* GApplication implementation */
static void
book_activate (GApplication *application)
{
	book_new_window (application, NULL);
}

static void
book_open (GApplication  *application,
                     GFile        **files,
                     gint           n_files,
                     const gchar   *hint)
{
	gint i;

	for (i = 0; i < n_files; i++)
		book_new_window (application, files[i]);
}

static void
book_init (Book *object)
{
	object->priv = G_TYPE_INSTANCE_GET_PRIVATE (object, BOOK_TYPE_APPLICATION, BookPrivate);
}

static void
book_finalize (GObject *object)
{
	G_OBJECT_CLASS (book_parent_class)->finalize (object);
}

static void
book_class_init (BookClass *klass)
{
	G_APPLICATION_CLASS (klass)->activate = book_activate;
	G_APPLICATION_CLASS (klass)->open = book_open;

	g_type_class_add_private (klass, sizeof (BookPrivate));

	G_OBJECT_CLASS (klass)->finalize = book_finalize;
}

Book *
book_new (void)
{
	return g_object_new (book_get_type (),
	                     "application-id", "org.gnome.book",
	                     "flags", G_APPLICATION_HANDLES_OPEN,
	                     NULL);
}


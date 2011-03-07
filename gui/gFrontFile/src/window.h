#ifndef _WINDOW_H_
#define _WINDOW_H_

#include <gtk/gtk.h>
#include <gtksourceview/gtksourceview.h>

GtkWidget *window;
GtkWidget *create_main_window();

/* Window's widgets */
/* entries */
GtkWidget *entPatterns;

/* buttons */
GtkWidget *btnSearch;

/* others */
GtkWidget *scwResult;
GtkWidget *scvResult;

/* Callbacks */
gboolean program_quit(GtkWidget *widget, GdkEvent *event, gpointer data);

#endif /*_WINDOW_H_*/

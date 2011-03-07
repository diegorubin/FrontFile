#ifndef _WINDOW_H_
#define _WINDOW_H_

#include <gtk/gtk.h>

GtkWidget *window;
GtkWidget *create_main_window();

/* Window's widgets */
/* buttons */
GtkWidget *btnSearch;

/* Callbacks */
gboolean program_quit(GtkWidget *widget, GdkEvent *event, gpointer data);

#endif /*_WINDOW_H_*/

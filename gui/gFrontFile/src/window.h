#ifndef _WINDOW_H_
#define _WINDOW_H_

#include <pthread.h>
#include <gtk/gtk.h>
#include <gtksourceview/gtksourceview.h>

GtkWidget *window;
GtkWidget *create_main_window();

/* Window's widgets */
/* labels */
GtkWidget *lblDirectory;

/* entries */
GtkWidget *entPatterns;

/* buttons */
GtkWidget *btnSearch;
GtkWidget *btnChooseDirectory;

/* others */
GtkWidget *scwResult;
GtkWidget *scvResult;

/* Callbacks */
gboolean program_quit(GtkWidget *widget, GdkEvent *event, gpointer data);
void button_search_clicked(GtkWidget *widget, gpointer data);

/* Methods */
void *call_sentinel();

#endif /*_WINDOW_H_*/

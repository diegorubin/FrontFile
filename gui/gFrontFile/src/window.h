#ifndef _WINDOW_H_
#define _WINDOW_H_

#include <pthread.h>
#include <gtk/gtk.h>
#include <gtksourceview/gtksourceview.h>
#include <string.h>

GtkWidget *window;
GtkWidget *create_main_window();

/* Window's widgets */
/* labels */
GtkWidget *lblDirectory;
GtkWidget *lblPatterns;
GtkWidget *lblExtensions;
GtkWidget *lblExclude;

/* entries */
GtkWidget *entPatterns;
GtkWidget *entExtensions;
GtkWidget *entExclude;

/* buttons */
GtkWidget *btnSearch;
GtkWidget *btnChooseDirectory;
GtkWidget *ckbRecover;

/* others */
GtkWidget *scwResult;
GtkWidget *scvResult;

/* Callbacks */
gboolean program_quit(GtkWidget *widget, GdkEvent *event, gpointer data);
void button_search_clicked(GtkWidget *widget, gpointer data);

/* Methods */
void *call_sentinel();

#endif /*_WINDOW_H_*/

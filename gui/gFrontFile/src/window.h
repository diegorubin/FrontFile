#ifndef _WINDOW_H_
#define _WINDOW_H_

#include <pthread.h>
#include <gtk/gtk.h>
#include <gtksourceview/gtksourceview.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/mman.h>

GtkWidget *window;
GtkWidget *create_main_window();

GIOChannel *pipeline;
int file_output;

/* threads */
pthread_t t_sentinel;
pthread_t t_result;

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
GtkTextBuffer *buffer;

/* Callbacks */
gboolean program_quit(GtkWidget *widget, GdkEvent *event, gpointer data);
void button_search_clicked(GtkWidget *widget, gpointer data);

/* Methods */
void *call_sentinel();
void *get_result();

#endif /*_WINDOW_H_*/

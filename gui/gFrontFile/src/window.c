#include "window.h"

GtkWidget *create_main_window()
{
    window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gtk_window_set_title(GTK_WINDOW(window), "gFrontFile");
    gtk_window_set_position(GTK_WINDOW(window),GTK_WIN_POS_CENTER_ALWAYS);

    GtkWidget *table = gtk_table_new(2,2,FALSE);

    /* signals connect */
    g_signal_connect(G_OBJECT(window),"delete_event",G_CALLBACK(program_quit),NULL);
}

gboolean program_quit(GtkWidget *widget, GdkWvent *event, gpointer data)
{
    gtk_main_quit();
    return TRUE;
}

#include "window.h"

GtkWidget *create_main_window()
{
    window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gtk_window_set_title(GTK_WINDOW(window), "gFrontFile");
    gtk_window_set_position(GTK_WINDOW(window),GTK_WIN_POS_CENTER_ALWAYS);
    gtk_window_set_default_size(GTK_WINDOW(window), 800, 600);

    GtkWidget *vbxWindow = gtk_vbox_new (FALSE, 0);
    GtkWidget *tblMenu = gtk_table_new(2,2,FALSE);

    gtk_box_pack_start (GTK_BOX (vbxWindow), 
                        tblMenu,
                        FALSE,
                        FALSE,
                        0); 

    entPatterns = gtk_entry_new();
    btnSearch = gtk_button_new_with_label("Pesquisar");

    gtk_table_attach(GTK_TABLE(tblMenu), entPatterns, 0, 1, 0, 1, GTK_SHRINK,GTK_SHRINK,0,0);  
    gtk_table_attach(GTK_TABLE(tblMenu), btnSearch, 1, 2, 0, 1, GTK_SHRINK,GTK_SHRINK,0,0);  


    scwResult = gtk_scrolled_window_new (NULL, 
                                         NULL); 
    gtk_scrolled_window_set_policy (GTK_SCROLLED_WINDOW (scwResult), 
                                  GTK_POLICY_AUTOMATIC, 
                                  GTK_POLICY_AUTOMATIC); 

    scvResult = gtk_source_view_new(); 
    gtk_source_view_set_show_line_numbers (GTK_SOURCE_VIEW (scvResult), TRUE); 

    gtk_container_add (GTK_CONTAINER (scwResult), scvResult); 

    gtk_box_pack_start (GTK_BOX (vbxWindow), 
                      scwResult, 
                      TRUE, // vbox gives widget all remaining space 
                      TRUE, // widget expands to fill given space 
                      0); // pixel of padding around the widget 


    gtk_container_add(GTK_CONTAINER(window), vbxWindow);

    /* signals connect */
    g_signal_connect(G_OBJECT(window),
                     "delete_event",
                     G_CALLBACK(program_quit),
                     NULL);
    
    return window;
}

gboolean program_quit(GtkWidget *widget, GdkEvent *event, gpointer data)
{
    gtk_main_quit();
    return TRUE;
}

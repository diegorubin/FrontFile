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

    lblDirectory = gtk_label_new("Directory:");
    btnChooseDirectory = gtk_file_chooser_button_new ("Select a directory",
                                                      GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER); 

    entPatterns = gtk_entry_new();
    btnSearch = gtk_button_new_with_label("Search");

    gtk_table_attach(GTK_TABLE(tblMenu), lblDirectory, 0, 1, 0, 1, GTK_EXPAND,GTK_SHRINK,0,0);  
    gtk_table_attach(GTK_TABLE(tblMenu), btnChooseDirectory, 1, 2, 0, 1, GTK_SHRINK,GTK_SHRINK,0,0);  
    gtk_table_attach(GTK_TABLE(tblMenu), entPatterns, 0, 1, 1, 2, GTK_EXPAND,GTK_SHRINK,0,0);  
    gtk_table_attach(GTK_TABLE(tblMenu), btnSearch, 1, 2, 1, 2, GTK_EXPAND,GTK_SHRINK,0,0);  


    scwResult = gtk_scrolled_window_new (NULL, 
                                         NULL); 
    gtk_scrolled_window_set_policy (GTK_SCROLLED_WINDOW (scwResult), 
                                  GTK_POLICY_AUTOMATIC, 
                                  GTK_POLICY_AUTOMATIC); 

    scvResult = gtk_source_view_new(); 
    gtk_text_view_set_editable(GTK_TEXT_VIEW(scvResult), FALSE);
    gtk_container_add (GTK_CONTAINER (scwResult), scvResult); 
    gtk_box_pack_start (GTK_BOX (vbxWindow), 
                      scwResult, 
                      TRUE, 
                      TRUE,
                      0); 

    gtk_container_add(GTK_CONTAINER(window), vbxWindow);

    /* signals connect */
    g_signal_connect(G_OBJECT(window),
                     "delete_event",
                     G_CALLBACK(program_quit),
                     NULL);
    g_signal_connect(G_OBJECT(btnSearch),
                     "clicked",
                     G_CALLBACK(button_search_clicked),
                     NULL);
    
    return window;
}

gboolean program_quit(GtkWidget *widget, GdkEvent *event, gpointer data)
{
    gtk_main_quit();
    return TRUE;
}

void button_search_clicked(GtkWidget *widget, gpointer data)
{
    gtk_widget_set_sensitive(GTK_WIDGET(btnSearch),FALSE);
    pthread_t sentinel;
    pthread_create(&sentinel,NULL,call_sentinel,NULL);
    
}

void *call_sentinel()
{
    char **arguments;
    int pid;

    pid = fork();
    if(pid){
        gtk_widget_set_sensitive(GTK_WIDGET(btnSearch),TRUE);
    }
    else{
        execv("/usr/bin/sentinel",arguments);
    }
}

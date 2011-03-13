#include "window.h"

const char *fifo = "/tmp/gfrontfile";

GtkWidget *create_main_window()
{
    window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gtk_window_set_title(GTK_WINDOW(window), "gFrontFile");
    gtk_window_set_position(GTK_WINDOW(window),GTK_WIN_POS_CENTER_ALWAYS);
    gtk_window_set_default_size(GTK_WINDOW(window), 800, 600);
    gtk_container_set_border_width(GTK_CONTAINER(window),5);

    GtkWidget *vbxWindow = gtk_vbox_new (FALSE, 0);
    GtkWidget *tblMenu = gtk_table_new(4,2,FALSE);

    gtk_box_pack_start (GTK_BOX (vbxWindow),tblMenu, FALSE, FALSE, 0); 

    lblDirectory = gtk_label_new("Directory:");
    btnChooseDirectory = gtk_file_chooser_button_new ("Select a directory",
                                                      GTK_FILE_CHOOSER_ACTION_SELECT_FOLDER); 

    lblPatterns = gtk_label_new("Patterns:");
    entPatterns = gtk_entry_new();

    lblExtensions = gtk_label_new("Extensions:");
    entExtensions = gtk_entry_new();

    lblExclude = gtk_label_new("Exclude:");
    entExclude = gtk_entry_new();

    ckbRecover = gtk_check_button_new_with_label("Recover Mode");

    btnSearch = gtk_button_new_with_label("Search");
    
    gtk_table_attach(GTK_TABLE(tblMenu), lblPatterns, 0, 1, 0, 1, GTK_SHRINK,GTK_SHRINK,0,0);  
    gtk_table_attach(GTK_TABLE(tblMenu), entPatterns, 1, 2, 0, 1, GTK_EXPAND,GTK_SHRINK,0,0);  

    gtk_table_attach(GTK_TABLE(tblMenu), lblDirectory, 2, 3, 0, 1, GTK_SHRINK,GTK_SHRINK,0,0);  
    gtk_table_attach(GTK_TABLE(tblMenu), btnChooseDirectory, 3, 4, 0, 1, GTK_EXPAND,GTK_SHRINK,0,0);  
    gtk_table_attach(GTK_TABLE(tblMenu), lblExtensions, 0, 1, 1, 2, GTK_SHRINK,GTK_SHRINK,0,0);  
    gtk_table_attach(GTK_TABLE(tblMenu), entExtensions, 1, 2, 1, 2, GTK_EXPAND,GTK_SHRINK,0,0);  
    gtk_table_attach(GTK_TABLE(tblMenu), lblExclude, 2, 3, 1, 2, GTK_SHRINK,GTK_SHRINK,0,0);  
    gtk_table_attach(GTK_TABLE(tblMenu), entExclude, 3, 4, 1, 2, GTK_EXPAND,GTK_SHRINK,0,0);  
    gtk_table_attach(GTK_TABLE(tblMenu), ckbRecover, 4, 5, 1, 2, GTK_EXPAND,GTK_SHRINK,0,0);  
    gtk_table_attach(GTK_TABLE(tblMenu), btnSearch, 4, 6, 0, 1, GTK_SHRINK,GTK_SHRINK,0,0);  


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
    
    buffer = gtk_text_view_get_buffer(GTK_TEXT_VIEW(scvResult)); 

    gtk_container_add(GTK_CONTAINER(window), vbxWindow);
   
    if(access(fifo,F_OK) == -1){
        if(mkfifo(fifo,0666) != 0){
            g_print("error creating pipeline\n");
            gtk_main_quit();
        }
    }


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
    unlink(fifo);
    return TRUE;
}

void button_search_clicked(GtkWidget *widget, gpointer data)
{
    gtk_widget_set_sensitive(GTK_WIDGET(btnSearch),FALSE);
    gtk_text_buffer_set_text(buffer,"\0",-1);

    pthread_create(&t_sentinel,NULL,call_sentinel,NULL);
    pthread_create(&t_result,NULL,get_result,NULL);
}

void *call_sentinel()
{
    char *arguments[10];
    int pid; 

    pid = fork();
    if(!pid){
        arguments[0] = strdup("/usr/bin/sentinel");
        if(strcmp(gtk_entry_get_text(GTK_ENTRY(entPatterns)),"")){
            arguments[1] = strdup("--patterns");
            arguments[2] = (char*) gtk_entry_get_text(GTK_ENTRY(entPatterns));
        }else{
            arguments[1] = strdup("");
            arguments[2] = strdup("");
        }

        arguments[3] = strdup("--directory");
        arguments[4] = gtk_file_chooser_get_current_folder(GTK_FILE_CHOOSER(btnChooseDirectory));

        if(strcmp(gtk_entry_get_text(GTK_ENTRY(entExtensions)),"")){
            arguments[5] = strdup("--extensions");
            arguments[6] = (char*) gtk_entry_get_text(GTK_ENTRY(entExtensions));
        }else{
            arguments[5] = strdup("");
            arguments[6] = strdup("");
        }
        if(strcmp(gtk_entry_get_text(GTK_ENTRY(entExclude)),"")){
            arguments[7] = strdup("--exclude");
            arguments[8] = (char*) gtk_entry_get_text(GTK_ENTRY(entExclude));
        }else{
            arguments[7] = strdup("");
            arguments[8] = strdup("");
        }
        if(gtk_toggle_button_get_active(GTK_TOGGLE_BUTTON(ckbRecover))){
            arguments[9] = "--recover";
        }else{
            arguments[9] = "";
        }
        
        file_output = open(fifo,O_WRONLY,0600);
        close(1);
        dup2(file_output,1);
        close(file_output);
        execv("/usr/bin/sentinel",arguments);
        close(1);
    }else{
        wait(0);
        sleep(1);
        pthread_cancel(t_result);
        gtk_widget_set_sensitive(GTK_WIDGET(btnSearch),TRUE);
    }
}

void *get_result()
{

    char m_result[PIPE_BUF+1];
    gchar *g_result;
    int file_input;


    for(;;){
        file_input = open(fifo, O_RDONLY, 0600);
        read(file_input,m_result,PIPE_BUF);
        m_result[PIPE_BUF+1] = '\0';
        
        g_result = g_strdup(g_locale_to_utf8(m_result,-1,0,0,0));
        
        gtk_text_buffer_insert_at_cursor(buffer,g_result,-1);
        close(file_input);
    }

    free(m_result);
    free(g_result);
}


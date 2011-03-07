#include "window.h"

int main(int argc, char **argv){
    gtk_init(&argc,&argv);

    GtkWidget *winMain;
    winMain = create_main_window();
    gtk_widget_show_all(winMain);

    gtk_main();

    return 0;
}

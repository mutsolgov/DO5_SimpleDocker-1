#include <stdlib.h>
#include <fcgi_stdio.h>


int main() {
    while (FCGI_Accept() >= 0) {
        printf("Content-type: text/html\r\n\r\n");
        printf("<html><head><title>Hello</title></head>");
        printf("<body><h1>Hello World!</h1></body>");
        printf("</html>\n");
    }
    return 0;
}


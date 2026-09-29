#include <stdlib.h>

char *make_message(void)
{
    char *message = malloc(16);
    if (message == NULL) return NULL;
    message[0] = 'o';
    free(message);
    return message; /* dangling pointer; caller may also free it */
}

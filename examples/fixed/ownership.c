#include <stdlib.h>
#include <string.h>

char *make_message(void);

char *make_message(void)
{
    char *message = malloc(16);
    if (message == NULL) return NULL;
    memcpy(message, "owned by caller", 16);
    return message; /* ownership transfers to caller */
}

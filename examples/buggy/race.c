#include <pthread.h>

static int counter;
static void *increment(void *unused)
{
    (void)unused;
    ++counter;
    return NULL;
}
int main(void)
{
    pthread_t thread;
    if (pthread_create(&thread, NULL, increment, NULL) != 0) return 1;
    ++counter;
    return pthread_join(thread, NULL);
}

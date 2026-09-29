#include <pthread.h>

static pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
static int counter;
static void *increment(void *unused)
{
    (void)unused;
    if (pthread_mutex_lock(&lock) != 0) return NULL;
    ++counter;
    (void)pthread_mutex_unlock(&lock);
    return NULL;
}
int main(void)
{
    pthread_t thread;
    if (pthread_create(&thread, NULL, increment, NULL) != 0) return 1;
    if (pthread_mutex_lock(&lock) != 0) return 2;
    ++counter;
    (void)pthread_mutex_unlock(&lock);
    return pthread_join(thread, NULL);
}

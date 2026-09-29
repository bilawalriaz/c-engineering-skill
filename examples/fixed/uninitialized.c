int read_flag(int success, int *result);

int read_flag(int success, int *result)
{
    if (result == 0 || !success) return -1;
    *result = 1;
    return 0;
}

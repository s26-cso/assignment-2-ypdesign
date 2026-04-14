#include <stdio.h>
#include <dlfcn.h>

int main()
{
    // input taken
    char op[6];
    int num1, num2;
    // while loop used to take input till EOF
    while (scanf("%5s %d %d", op, &num1, &num2) == 3)
    {

        char path[16];
        // the path of op is written into to the char array and constructs a lib path from op->libop.so
        snprintf(path, sizeof(path), "./lib%s.so", op);
        // load the library
        void *load = dlopen(path, RTLD_LAZY);
        if (!load)
        {
            // if there is an error the error is reflected in std err and we go to next input
            fprintf(stderr, "ERROR %s:%s\n", path, dlerror());
            continue;
        }
        // function pointer type for the operation
        typedef int (*fptr)(int, int);
        // get the symbol from the library
        fptr fn = (fptr)dlsym(load, op);
        if (!fn)
        {
            fprintf(stderr, "ERROR %s:%s\n", path, dlerror());
            continue;
        }
        // call the function and print result
        printf("%d\n", fn(num1, num2));
        // unload the library immediately — each .so can be up to 1.5GB,
        // so we must free it before loading the next one to stay under 2GB
        dlclose(load);
    }

    return 0;
}
#include <stdio.h>
#include <dlfcn.h>

int main() {
    char op[6];
    int num1, num2;

    while (scanf("%5s %d %d", op, &num1, &num2) == 3) {

        char path[16];
        snprintf(path, sizeof(path), "./lib%s.so", op);
        void* load = dlopen(path, RTLD_LAZY);
        typedef int (*fptr)(int, int);
        fptr fn = (fptr) dlsym(load, op);

        printf("%d\n", fn(num1, num2));
        dlclose(load);
    }

    return 0;
}
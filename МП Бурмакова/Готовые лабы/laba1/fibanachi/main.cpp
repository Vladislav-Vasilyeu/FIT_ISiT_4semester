#include "Fibonacci.h"
#include <iostream>
#include <ctime>

int main() {
    setlocale(LC_ALL, "rus");
    clock_t t1 = 0, t2 = 0;

    std::cout << "\nИсследование рекурсивного Фибоначчи:\n";
    for (int n = 10; n <= 40; n += 5) {
        t1 = clock();
        long long result = fibonacci(n);
        t2 = clock();

        std::cout << "\nФибоначчи(" << n << ") = " << result;
        std::cout << "\nВремя (у.е): " << (t2 - t1);
        std::cout << "\nВремя (сек): " << ((double)(t2 - t1)) / CLOCKS_PER_SEC;
    }

    std::cout << std::endl;
    system("pause");
    return 0;
}

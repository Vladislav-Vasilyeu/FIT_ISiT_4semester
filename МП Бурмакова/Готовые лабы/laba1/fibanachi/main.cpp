#include "Fibonacci.h"
#include <iostream>
#include <ctime>

int main() {
    setlocale(LC_ALL, "rus");
    clock_t t1 = 0, t2 = 0;

    std::cout << "\n������������ ������������ ���������:\n";
    for (int n = 10; n <= 40; n += 5) {
        t1 = clock();
        long long result = fibonacci(n);
        t2 = clock();

        std::cout << "\n���������(" << n << ") = " << result;
        std::cout << "\n����� (�.�): " << (t2 - t1);
        std::cout << "\n����� (���): " << ((double)(t2 - t1)) / CLOCKS_PER_SEC;
    }

    std::cout << std::endl;
    system("pause");
    return 0;
}

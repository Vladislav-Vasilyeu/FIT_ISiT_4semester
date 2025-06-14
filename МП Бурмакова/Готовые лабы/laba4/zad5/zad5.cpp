#include <chrono>
#include <iostream>
#include "MultyMatrix.h"   

#define N 6 // Количество матриц

int main() {
    setlocale(LC_ALL, "rus");
    // Размерности матриц
    int Mc[N + 1] = { 20, 15, 30, 53, 10, 20, 11 }; // обновленный массив размерностей
    int Ms[N][N], r = 0, rd = 0;

    memset(Ms, 0, sizeof(int) * N * N);
    auto start = std::chrono::high_resolution_clock::now();
    r = OptimalM(1, N, N, Mc, OPTIMALM_PARM(Ms));
    auto end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> elapsed = end - start;
    std::cout << "Время (рекурсивное решение): " << elapsed.count() << " секунд" << std::endl;

  
    std::cout << std::endl;
    std::cout << "-- расстановка скобок (рекурсивное решение) " << std::endl;
    std::cout << "размерности матриц: ";
    for (int i = 1; i <= N; i++) std::cout << "(" << Mc[i - 1] << "," << Mc[i] << ") ";
    std::cout << std::endl << "минимальное количество операций умножения: " << r;
    std::cout << std::endl << "матрица S" << std::endl;
    for (int i = 0; i < N; i++) {
        std::cout << std::endl;
        for (int j = 0; j < N; j++) std::cout << Ms[i][j] << "  ";
    }
    std::cout << std::endl;

    memset(Ms, 0, sizeof(int) * N * N);
    start = std::chrono::high_resolution_clock::now();
    rd = OptimalMD(N, Mc, OPTIMALM_PARM(Ms));
    end = std::chrono::high_resolution_clock::now();
    elapsed = end - start;
    std::cout << "Время (динамическое программирование): " << elapsed.count() << " секунд" << std::endl;
    std::cout << std::endl << "-- расстановка скобок (динамическое программирование) " << std::endl;
    std::cout << "размерности матриц: ";
    for (int i = 1; i <= N; i++)
        std::cout << "(" << Mc[i - 1] << "," << Mc[i] << ") ";
    std::cout << std::endl << "минимальное количество операций умножения: " << rd;
    std::cout << std::endl << "матрица S" << std::endl;
    for (int i = 0; i < N; i++) {
        std::cout << std::endl;
        for (int j = 0; j < N; j++) std::cout << Ms[i][j] << "  ";
    }
    std::cout << std::endl;

    system("pause");
    return 0;
}
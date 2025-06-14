#include <iostream>
#include <cstdlib>
#include <ctime>

// Функция для генерации случайной строки заданной длины
std::string generateRandomString(int length) {
    std::string str;
    static const char alphabet[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    for (int i = 0; i < length; ++i) {
        str += alphabet[rand() % (sizeof(alphabet) - 1)];
    }
    return str;
}

int main() {
    srand(time(0)); // Инициализация генератора случайных чисел

    std::string S1 = generateRandomString(300);
    std::string S2 = generateRandomString(200);

    std::cout << "S1: " << S1 << "\n";
    std::cout << "S2: " << S2 << "\n";

    return 0;
}

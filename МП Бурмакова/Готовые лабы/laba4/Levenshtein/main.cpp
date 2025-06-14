#include <iostream>
#include <vector>
#include <string>
#include <ctime>
#include <chrono>

using namespace std;
using namespace std::chrono;

// Функция для вычисления расстояния Левенштейна (рекурсивный метод)
int levenshteinRecursive(const string& s1, int len1, const string& s2, int len2) {
    if (len1 == 0) return len2;
    if (len2 == 0) return len1;

    int cost = (s1[len1 - 1] == s2[len2 - 1]) ? 0 : 1;

    return min({
        levenshteinRecursive(s1, len1 - 1, s2, len2) + 1,   // Удаление
        levenshteinRecursive(s1, len1, s2, len2 - 1) + 1,   // Вставка
        levenshteinRecursive(s1, len1 - 1, s2, len2 - 1) + cost // Замена
        });
}

// Функция для вычисления расстояния Левенштейна (динамическое программирование)
int levenshteinDP(const string& s1, const string& s2) {
    int len1 = s1.size(), len2 = s2.size();
    vector<vector<int>> dp(len1 + 1, vector<int>(len2 + 1));

    for (int i = 0; i <= len1; i++) dp[i][0] = i;
    for (int j = 0; j <= len2; j++) dp[0][j] = j;

    for (int i = 1; i <= len1; i++) {
        for (int j = 1; j <= len2; j++) {
            int cost = (s1[i - 1] == s2[j - 1]) ? 0 : 1;
            dp[i][j] = min({ dp[i - 1][j] + 1, dp[i][j - 1] + 1, dp[i - 1][j - 1] + cost });
        }
    }

    return dp[len1][len2];
}

// Функция для генерации случайной строки из латинских букв
string generateRandomString(int length) {
    string result;
    for (int i = 0; i < length; i++)
        result += 'A' + rand() % 26;
    return result;
}

int main() {
    setlocale(LC_ALL, "RU");
    srand(time(0));
    string S1 = generateRandomString(300);
    string S2 = generateRandomString(200);

    vector<double> k_values = { 1.0 / 25, 1.0 / 20, 1.0 / 15, 1.0 / 10, 1.0 / 7, 1.0 / 5, 1.0 / 2, 1.0 };
    vector<double> timeRecursive, timeDP;

    for (double k : k_values) {
        int len1 = S1.size() * k;
        int len2 = S2.size() * k;
        string subS1 = S1.substr(0, len1);
        string subS2 = S2.substr(0, len2);

        // Измерение времени рекурсивного метода
        auto start = high_resolution_clock::now();
        int resultRecursive = levenshteinRecursive(subS1, len1, subS2, len2);
        auto stop = high_resolution_clock::now();
        double durationRecursive = duration_cast<milliseconds>(stop - start).count();
        timeRecursive.push_back(durationRecursive);

        // Измерение времени динамического программирования
        start = high_resolution_clock::now();
        int resultDP = levenshteinDP(subS1, subS2);
        stop = high_resolution_clock::now();
        double durationDP = duration_cast<milliseconds>(stop - start).count();
        timeDP.push_back(durationDP);

        cout << "k = " << k << " | Rec = " << durationRecursive << "ms | DP = " << durationDP << "ms" << endl;
    }

    // Вывод данных для графика
    cout << "K values:\n";
    for (double k : k_values) cout << k << " ";
    cout << "\nRecursive times:\n";
    for (double t : timeRecursive) cout << t << " ";
    cout << "\nDP times:\n";
    for (double t : timeDP) cout << t << " ";

    return 0;
}

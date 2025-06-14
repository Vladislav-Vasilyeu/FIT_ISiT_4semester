number1 = int(input("Введите целое число: "))
number2 = float(input("Введите вещественное число: "))

print(f"Сумма чисел: {number1 + number2}")
print(f"Разность чисел: {number1 - number2}")
print(f"Произведение чисел: {number1 * number2}")
print(f"Частное чисел: {number1 / number2}")

print(f"Округлённое деление до 2х знаков: {round(number1/number2, 2) }")

if number1 %2 == 0:
        print(f"Число {number1} чётное")
else:
    print(f"Число {number1} нечётное")

if number2 %2 == 0:
        print(f"Число {number2} чётное")
else:
    print(f"Число {number2} нечётное")



string = input("Введите какую-нибудь строку: ")
print(f"Длинна строки: {len(string)}")
print(f"Стока в верхнем регистре: {string.upper()}")
print(f"Есть ли в строке числа: {any(char.isnumeric() for char in string)}")
mingle = len(string) // 2
print(f"Вторая половина строки: {string[:mingle]}")



numbers = [1, 2, 3, 2, 4, 5, 67, 89, 222, 453, 673738, 0]
print(f"Изначальный список: {numbers}")
print(f"Последний элемент массива: {numbers[-1]}")
numbers.append(6784)
print(f"Список после добавления элемента: {numbers}")
print(f"Сколько встречается число 2 в списке: {numbers.count(2)}")
numbers.sort()
print(f"Отсортированный список: {numbers}")

sentence = input("Введите предложение: ")
splitSentence = sentence.split()
print(f"Список из предложения: {splitSentence}")
print(f"Длинна списка: {len(splitSentence)}")

numbers2 = []
for i in range(11, 20):
    numbers2.append(i)
print(f"Список из чисел в диапазоне от 11 до 20: {numbers2}")
sqrnumbers2 = []
for i in numbers2:
    sqrnumbers2.append(i ** 2)
print(f"Список из их квадратов: {sqrnumbers2}")
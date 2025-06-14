import random
import math

random_list = [random.randint(1,100) for _ in range(10)]
random_tuple = tuple(random_list)
print(random_tuple)
print(min(random_tuple))
print(max(random_tuple))
print(sum(random_tuple))
print(sum(random_tuple) / len(random_tuple))

new_random_list = list(random_tuple)
print(new_random_list)
print(new_random_list.__sizeof__())
print(random_tuple.__sizeof__())
if random_tuple.__sizeof__() < new_random_list.__sizeof__():
    print("Кортеж занимает меньше места")
else:
    print("Список занимает меньше места")

tuple_1 = (11, 12, 13, [10,20, 30])
print(tuple_1)
print(tuple_1[-1][0])
print(tuple_1[-1][-1])

a, b, c, dictionary = tuple_1
print(a)
print(b)
print(c)
print(dictionary)


employees = {
    'Иванов' : 15000,
    'Петров' : 25000,
    'Сидоров' : 5000,
}
print(employees)
print(employees['Петров'])
print(employees.get('Васильев', 'Такого работника нет'))
employees['Новиков'] = 30000
print(employees)
print(len(employees))
print(employees.keys())
print(sum(employees.values()) / len(employees))



order1 = {'apple', 'orange', 'banana'}
order2 = {'apple', 'pear', 'orange'}
print(order1 & order2)
print((order2 - order1) | (order1 - order2))
new_order = order2 | order1
print(new_order)


def square(a):
    perimetr = a * 4
    area = a ** 2
    diagonal = a * math.sqrt(2)
    return perimetr, area, diagonal
value = int(input("Введите сторону квадрата: "))
func = square(value)
print(func)

def is_year_leap(year):
    if(year % 4 == 0 and year % 100 != 0) or (year % 400 == 0):
        return True
    else:
        return False
year = int(input("Введите год: "))
if is_year_leap(year):
    print(f"Год {year} является високосным")
else:
    print(f"Год {year} не является високосным")
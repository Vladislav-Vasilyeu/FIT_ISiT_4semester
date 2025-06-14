
class Car:
    def __init__(self, speed, volume):
        self.speed = speed
        self.volume = volume
    def move(self):
        print("Еду на машине.")
    def __str__(self):
        return f"Скорость: {self.speed}, Объём: {self.volume}"




class Honda(Car):
    def __init__(self, speed, model, volume):
        super().__init__(speed, volume)
        self.__model = model
    def get_model(self):
        return self.__model
    def set_model(self, model):
        if isinstance(model, str) and model:
            self.__model = model
        else:
            print("Ошибка: модель не может быть пустой строкой")

    def move(self):
        super().move()
        print(f"Еду на {self.__model}")
    def __str__(self):
        return f"Марка: Honda, Модель: {self.__model}, {super().__str__()}"




class Volvo(Car):
    def __init__(self, speed, model, volume):
        super().__init__(speed, volume)
        self.__model = model
    def get_model(self):
        return self.__model
    def set_model(self, model):
        if isinstance(model, str) and model:
            self.__model = model
        else:
            print("Ошибка: модель не может быть пустой строкой")

    def move(self):
        super().move()
        print(f"Еду на {self.__model}")
    def __str__(self):
        return f"Марка: Volvo, Модель: {self.__model}, {super().__str__()}"




class BMW(Car):
    def __init__(self, speed, model, volume):
        super().__init__(speed, volume)
        self.__model = model
    def get_model(self):
        return self.__model
    def set_model(self, model):
        if isinstance(model, str) and model:
            self.__model = model
        else:
            print("Ошибка: модель не может быть пустой строкой")

    def move(self):
        super().move()
        print(f"Еду на {self.__model}")
    def __str__(self):
        return f"Марка: BMW, Модель: {self.__model}, {super().__str__()}"




cars = [
    Honda(100, "Civic", 350),
    Volvo(120, "XC90", 320),
    BMW(190, "X5", 400),
    Honda(150, "Accord", 380),
    BMW(200, "M5", 450)
]
for car in cars:
    print(car)

for car in cars:
    car.move()
max_volume_car = cars[0]


for car in cars:
    if car.volume > max_volume_car.volume:
        max_volume_car = car

max_car = max()
print(max_car)

print(f"Машина с самым большим объёмом: {max_volume_car.get_model()}, Объём: {max_volume_car.volume}")

def __add__(a,b)
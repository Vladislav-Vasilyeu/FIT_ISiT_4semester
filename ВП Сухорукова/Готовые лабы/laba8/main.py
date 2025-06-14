def uppercase(func):
    def wrapper(*args, **kwargs):
        result = func(*args, **kwargs)
        if isinstance(result, str):
            return result.upper()
        return result
    return wrapper

@uppercase
def greet(name):
    return f"Hello, {name}!"

print(greet("Vlad"))


def count_calls(func):
    def wrapper(*args, **kwargs):
        wrapper.call_count +=1
        return func(*args, **kwargs)
    wrapper.call_count = 0
    return wrapper

@count_calls
def greet(name):
    print(f"Hello, {name}!")

greet("Tom")
greet("Denis")
print(f"Функция greet вызвана {greet.call_count} раз(а)")


def html_tag(tag):
    def decorator(func):
        def wrapper(*args, **kwargs):
            result = func(*args, **kwargs)
            return f"<{tag}>{result}<{tag}>"
        return wrapper
    return decorator

@html_tag("div")
def get_text():
    return "Hello, World!"

print(get_text())
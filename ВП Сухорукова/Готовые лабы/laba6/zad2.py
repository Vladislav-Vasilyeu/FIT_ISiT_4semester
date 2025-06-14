import telebot
from telebot.types import InlineKeyboardMarkup, InlineKeyboardButton

TOKEN = '8016026644:AAGgeyhf92bR-qyPeEnzrXtZ0XDiM9aesqg'

bot = telebot.TeleBot(TOKEN)

user_inputs = {}

@bot.message_handler(commands=['start'])
def send_welcome(message):
    bot.send_message(message.chat.id, 'Введите строку или число')

@bot.message_handler(func=lambda message: True)
def check_input(message):
    user_input = message.text
    user_inputs[message.chat.id] = user_input
    markup = InlineKeyboardMarkup()

    if user_input.isdigit():
        markup.add(InlineKeyboardButton("Двоичный код", callback_data='binary'))
        markup.add(InlineKeyboardButton("Четное/нечетное", callback_data='even_odd'))
        markup.add(InlineKeyboardButton("Факториал", callback_data='factorial'))

        bot.send_message(message.chat.id, f'Вы ввели число: {user_input}, выберите действие:', reply_markup=markup)
    else:
        markup.add(InlineKeyboardButton("Количество символов", callback_data='char_count'))
        markup.add(InlineKeyboardButton("Верхний регистр", callback_data='upper_case'))
        markup.add(InlineKeyboardButton("Убрать пробелы", callback_data='remove_spaces'))

        bot.send_message(message.chat.id, f'Вы ввели строку: {user_input}, выберите действие:', reply_markup=markup)

@bot.callback_query_handler(func=lambda call: True)
def handle_query(call):
    user_input = user_inputs.get(call.message.chat.id)

    

    if call.data == 'binary':
        binary_representation = bin(int(user_input))[2:]
        bot.send_message(call.message.chat.id, f'Двоичный код числа {user_input}: {binary_representation}')
    elif call.data == 'even_odd':
        number = int(user_input)
        result = "четное" if number % 2 == 0 else "нечетное"
        bot.send_message(call.message.chat.id, f'Число {user_input} является {result}.')
    elif call.data == 'factorial':
        from math import factorial
        fact = factorial(int(user_input))
        bot.send_message(call.message.chat.id, f'Факториал числа {user_input}: {fact}.')
    elif call.data == 'char_count':
        char_count = len(user_input)
        bot.send_message(call.message.chat.id, f'Количество символов в строке: {char_count}.')
    elif call.data == 'upper_case':
        upper_text = user_input.upper()
        bot.send_message(call.message.chat.id, f'Верхний регистр: {upper_text}.')
    elif call.data == 'remove_spaces':
        no_spaces = user_input.replace(" ", "")
        bot.send_message(call.message.chat.id, f'Строка без пробелов: {no_spaces}.')

    bot.answer_callback_query(call.id)

bot.polling()
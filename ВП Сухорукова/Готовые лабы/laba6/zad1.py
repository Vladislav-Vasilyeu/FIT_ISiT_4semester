import telebot

TOKEN = "7647380514:AAE7VTqg72H7a8gekqJROL4Yc7Ie3o2T15s"

bot = telebot.TeleBot(TOKEN)


@bot.message_handler(commands=['start', 'help'])
def start_handler(message):
    text = (
        "<b>Привет!</b> Я бот и умею вот что:\n\n"
        "🟢 /start или /help — показать справку\n"
        "💬 Напиши 'привет' — я поздороваюсь\n"
        "📷 Отправь фото — я замечу\n"
        "📁 Отправь файл — я скажу, что это файл\n"
        "🎭 Отправь стикер — я прокомментирую\n"
        "❓ Всё остальное — скажу 'Я не понимаю...'"
    )
    bot.send_message(message.chat.id, text, parse_mode='HTML')


@bot.message_handler(func=lambda message: 'привет' in message.text.lower())
def hello_handler(message):
    bot.send_message(message.chat.id, "Привет-привет! 👋")


@bot.message_handler(content_types=['photo'])
def photo_handler(message):
    bot.send_message(message.chat.id, "Красивое фото! 📸")


@bot.message_handler(content_types=['document'])
def document_handler(message):
    bot.send_message(message.chat.id, "Это файл, я вижу! 📁")


@bot.message_handler(content_types=['sticker'])
def sticker_handler(message):
    bot.send_message(message.chat.id, "Классный стикер! 😄")


@bot.message_handler(func=lambda message: True)
def fallback_handler(message):
    bot.send_message(message.chat.id, "Я не понимаю, что ты хочешь 😕")


bot.polling(none_stop=True)
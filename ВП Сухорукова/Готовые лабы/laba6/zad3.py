import telebot
from telebot import types
import sqlite3
from sqlite3 import Error


API_TOKEN = '8051613423:AAGAW7GYuENei9ValYDsdzfMCi75E0sRQWs'
bot = telebot.TeleBot(API_TOKEN)



def create_connection(db_file):
    conn = None
    try:
        conn = sqlite3.connect(db_file)
    except Error as e:
        print(e)
    return conn



def create_table(conn):
    sql_create_transactions_table = """ CREATE TABLE IF NOT EXISTS transactions (
                                            id integer PRIMARY KEY,
                                            type text NOT NULL,
                                            amount real NOT NULL,
                                            description text,
                                            date text NOT NULL
                                        ); """
    sql_create_balance_table = """ CREATE TABLE IF NOT EXISTS balance (
                                        id integer PRIMARY KEY,
                                        amount real NOT NULL
                                    ); """
    try:
        c = conn.cursor()
        c.execute(sql_create_transactions_table)
        c.execute(sql_create_balance_table)
        # Инициализация баланса, если он еще не установлен
        c.execute("INSERT INTO balance (amount) SELECT 0 WHERE NOT EXISTS (SELECT 1 FROM balance);")
        conn.commit()
    except Error as e:
        print(e)



def get_balance(conn):
    cur = conn.cursor()
    cur.execute("SELECT amount FROM balance WHERE id = 1")
    return cur.fetchone()[0]



def update_balance(conn, new_amount):
    cur = conn.cursor()
    cur.execute("UPDATE balance SET amount = ? WHERE id = 1", (new_amount,))
    conn.commit()



@bot.message_handler(commands=['start'])
def start(message):
    bot.send_message(message.chat.id, "Привет! Я личный менеджер. Выберите действие:", reply_markup=main_menu())


def main_menu():
    markup = types.ReplyKeyboardMarkup(resize_keyboard=True)
    item1 = types.KeyboardButton("Добавить транзакцию")
    item2 = types.KeyboardButton("История транзакций")
    item3 = types.KeyboardButton("Показать баланс")
    markup.add(item1, item2, item3)
    return markup



@bot.message_handler(func=lambda message: message.text == "Добавить транзакцию")
def add_transaction(message):
    msg = bot.send_message(message.chat.id,
                           "Введите тип (доход/расход), сумму и описание через запятую (например: доход,1000,зарплата).")
    bot.register_next_step_handler(msg, process_transaction)


def process_transaction(message):
    try:
        transaction_type, amount, description = message.text.split(',')
        amount = float(amount)
        date = message.date

        conn = create_connection('transactions.db')
        create_table(conn)

        # Обновление баланса
        current_balance = get_balance(conn)

        if transaction_type.lower() == 'доход':
            new_balance = current_balance + amount
        elif transaction_type.lower() == 'расход':
            new_balance = current_balance - amount
        else:
            bot.send_message(message.chat.id, "Неверный тип транзакции. Используйте 'доход' или 'расход'.",
                             reply_markup=main_menu())
            return

        # Сохранение транзакции и обновление баланса
        sql = ''' INSERT INTO transactions(type, amount, description, date)
                  VALUES(?,?,?,?) '''
        cur = conn.cursor()
        cur.execute(sql, (transaction_type, amount, description, str(date)))
        update_balance(conn, new_balance)
        conn.commit()
        conn.close()

        bot.send_message(message.chat.id, "Транзакция добавлена! Новый баланс: " + str(new_balance),
                         reply_markup=main_menu())
    except Exception as e:
        bot.send_message(message.chat.id, "Ошибка при добавлении транзакции. Пожалуйста, попробуйте еще раз.",
                         reply_markup=main_menu())



@bot.message_handler(func=lambda message: message.text == "История транзакций")
def history(message):
    conn = create_connection('transactions.db')
    create_table(conn)

    cur = conn.cursor()
    cur.execute("SELECT * FROM transactions")
    rows = cur.fetchall()

    if rows:
        response = "История транзакций:\n"
        for row in rows:
            response += f"{row[1]}: {row[2]} - {row[3]} (Дата: {row[4]})\n"
    else:
        response = "Нет транзакций."

    conn.close()
    bot.send_message(message.chat.id, response, reply_markup=main_menu())



@bot.message_handler(func=lambda message: message.text == "Показать баланс")
def show_balance(message):
    conn = create_connection('transactions.db')
    create_table(conn)

    current_balance = get_balance(conn)
    conn.close()

    bot.send_message(message.chat.id, "Текущий баланс: " + str(current_balance), reply_markup=main_menu())



bot.polling()
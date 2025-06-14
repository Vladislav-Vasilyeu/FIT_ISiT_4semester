import re
from wordcloud import WordCloud, STOPWORDS
import matplotlib.pyplot as plt
from nltk.corpus import stopwords
import nltk
from PIL import Image
import numpy as np
import pymorphy2



# Загрузим русский стоп-слова из nltk и добавим свои, если нужно
russian_stopwords = set(stopwords.words('russian'))
custom_stopwords = {'это', 'вот', 'так', 'быть', 'ещё'}  # Можно добавить свои стоп-слова
stop_words = russian_stopwords.union(custom_stopwords)

# Создаём объект для лемматизации
morph = pymorphy2.MorphAnalyzer()


# Функция для очистки и лемматизации текста
def preprocess_text(text):
    # Убираем знаки препинания и цифры
    text = re.sub(r'[^\w\s]', '', text)
    text = re.sub(r'\d+', '', text)

    words = text.lower().split()

    # Убираем стоп-слова и лемматизируем
    lemmas = []
    for w in words:
        if w not in stop_words:
            lemma = morph.parse(w)[0].normal_form
            lemmas.append(lemma)
    return ' '.join(lemmas)


# Читаем текст из файла (замени 'text.txt' на свой файл)
with open('text.txt', encoding='utf-8') as f:
    text = f.read()

cleaned_text = preprocess_text(text)

# Загружаем маску с контуром фигуры (например, сердечко)
mask_image = np.array(Image.open('heart.png'))  # Подготовь картинку с маской

# Генерируем облако слов
wordcloud = WordCloud(
    width=800, height=600,
    background_color='white',
    stopwords=stop_words,
    mask=mask_image,
    contour_width=3,
    contour_color='firebrick',
    font_path='Montserrat-Regular.ttf'  # Можно указать путь к шрифту с поддержкой кириллицы
).generate(cleaned_text)

# Отображаем облако слов
plt.figure(figsize=(10, 8))
plt.imshow(wordcloud, interpolation='bilinear')
plt.axis('off')
plt.show()

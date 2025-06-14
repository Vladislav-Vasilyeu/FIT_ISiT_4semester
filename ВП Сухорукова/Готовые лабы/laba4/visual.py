import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

df = pd.read_csv('books_data.csv')


df['Price'] = (
    df['Price']
    .str.replace('\xa0', '', regex=True)
    .str.replace(',', '.', regex=True)
    .str.replace('р.', '', regex=True)
    .astype(float)
)


plt.style.use('seaborn-v0_8-darkgrid')


plt.figure(figsize=(10, 5))
sns.histplot(df['Price'], bins=15, kde=True, color='blue')
plt.xlabel('Цена (руб.)')
plt.ylabel('Количество книг')
plt.title('Распределение цен на книги')
plt.show()


plt.figure(figsize=(8, 5))
sns.boxplot(x=df['Price'], color='orange')
plt.xlabel('Цена (руб.)')
plt.title('Box-Plot цен книг')
plt.show()

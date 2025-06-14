import pandas as pd



df = pd.read_csv('books_data.csv')


df['Price'] = (
    df['Price']
    .str.replace('\xa0', '', regex=True)
    .str.replace(',', '.', regex=True)
    .str.replace('р.', '', regex=True)
    .astype(float)
)


df_sorted = df.sort_values(by='Price', ascending=False)


print("Первые 5 книг:")
print(df_sorted.head())


print("\nСтатистика цен:")
print(df_sorted['Price'].describe())


df_grouped = df.groupby('Book Title')['Price'].mean().reset_index()
print("\nСредняя цена по книгам:")
print(df_grouped)

import pandas as pd
#Load data 

df = pd.read_csv("E:Amazon dataset (1).csv",encoding='latin-1',low_memory=False)
print(df.info())
#Identifying missing values
#print(df.isnull().sum())
# Fill numeric
df['Qty'] = df['Qty'].fillna(df['Qty'].median())
df['Amount'] = df['Amount'].fillna(df['Amount'].median())

# Fill categorical
df['ship-city'] = df['ship-city'].fillna('Unknown')
df['ship-state'] = df['ship-state'].fillna('Unknown')
df['ship-country'] = df['ship-country'].fillna('Unknown')
df['Courier Status'] = df['Courier Status'].fillna('Unknown')

# Fill others
df['promotion-ids'] = df['promotion-ids'].fillna('None')
df['fulfilled-by'] = df['fulfilled-by'].fillna('Unknown')
df['currency'] = df['currency'].fillna(df['currency'].mode()[0])
df['B2B'] = df['B2B'].fillna('No')
df['ship-postal-code'] = df['ship-postal-code'].fillna('Unknown')

# Drop critical missing
df = df.dropna(subset=['SKU', 'Date'])

# Drop unnamed columns
df = df.loc[:, ~df.columns.str.contains('^Unnamed')]

print(df.isnull().sum())
print(df.info())
print(df.duplicated().sum())
#Drop unnecessary column
df = df.drop(columns=['index'])
print(df.info())
# Standardize column names
df.columns = df.columns.str.strip().str.lower().str.replace(' ', '_').str.replace('-', '_')
print(df.info())
#Correct inconsistent formatting in columns
text_cols = ['ship_city', 'ship_state', 'category', 'size', 'status','b2b']
for col in text_cols:
    df[col] = df[col].astype(str).str.strip().str.title()
df['qty'] = df['qty'].astype(int)
df['amount'] = pd.to_numeric(df['amount'], errors='coerce')
df['currency'] = df['currency'].str.upper().str.strip()
df['amount'] = df['amount'].astype(str).str.replace(r'[^\d.]', '', regex=True)
df['amount'] = pd.to_numeric(df['amount'], errors='coerce')
df['date'] = pd.to_datetime(df['date'], errors='coerce')
df['ship_postal_code'] = df['ship_postal_code'].astype(str)
df['fulfilled_by'] = df['fulfilled_by'].astype('category')
print(df.info())

#Handle Outliers 
Q1 = df['amount'].quantile(0.25)
Q3 = df['amount'].quantile(0.75)

IQR = Q3 - Q1

df = df[(df['amount'] >= Q1 - 1.5 * IQR) & 
        (df['amount'] <= Q3 + 1.5 * IQR)]
# Create derived column
df['order_month'] = df['date'].dt.month_name()
print(df.info())

#save cleaned dataset
df.to_csv("E:/Cleaned_Amazon_Orders_2.csv", index=False)




import requests
import pandas as pd
import time

from newspaper import Article
import torch
import scipy.special
from transformers import AutoTokenizer, AutoModelForSequenceClassification

import yfinance as yf
from ta.momentum import RSIIndicator
import datetime

# Initialize BERT model and tokenizer
tokenizer = AutoTokenizer.from_pretrained("ProsusAI/finbert")
model = AutoModelForSequenceClassification.from_pretrained("ProsusAI/finbert")

def fetch_article_content(url):
    try:
        article = Article(url)
        article.download()
        time.sleep(1)  
        article.parse()
        article.nlp()
        article_summary = article.summary.lower()
        keywords = ["price",'crypto',"Bull","coin","bear",'fall','fed','interest rate ','economy']
        for keyword in keywords:
            if keyword.lower() in article_summary:
                print("Article Summary:", article_summary)
                return str(article.summary)
    except Exception as e:
        print(f"Error fetching article content: {e}")
    return ""

current_datetime = datetime.datetime.now()
current_date = current_datetime.date()
print("Today's date is:", current_date)

def news(start_date):
    StartDate=start_date
    text='bitcoin'
    main_url=f'https://newsapi.org/v2/everything?q={text}  &from{current_date}=&to={current_date}&sortBy=relevancy&apiKey=bd976089ac4b4b3797005becb9cb1caf'
 
    try:
        news_data = requests.get(main_url).json()
        articles = news_data['articles']
        print(articles)
        article_summary = []
        article_count = 0
        for arti in articles:
            if article_count >= 5:
                break
            url = arti['url']
            full_summary = fetch_article_content(url)
            if full_summary:
                article_summary.append(full_summary)
                article_count += 1
    except Exception as e:
        print(f"Error fetching news: {e}")
    return article_summary


def bert_sentiment(x):
    with torch.no_grad():
        input_sequence = tokenizer(str(x), return_tensors="pt", padding=True, truncation=True, max_length=512)
        logits = model(**input_sequence).logits
        scores = {
            k: v
            for k, v in zip(
                model.config.id2label.values(),
                scipy.special.softmax(logits.numpy().squeeze()),
            )
        }
        sentiment_finbert = max(scores, key=scores.get)
        probability_finbert = max(scores.values())
        return sentiment_finbert



def getNewsSignal(end_date):
    article_summary = news(end_date)
    news_df = pd.DataFrame({'Article Summary': article_summary}) 
    news_df['bert pred'] = news_df['Article Summary'].apply(bert_sentiment)
    sentiment_counts = news_df['bert pred'].value_counts()
    if sentiment_counts.get('neutral', 0) + sentiment_counts.get('positive', 0) > sentiment_counts.get('negative', 0):
        news_signal = True
    else:
        news_signal = False

    print("Buy Signal:", news_signal)      
    
    return news_signal  





start_date = '2024-02-05'  
end_date = datetime.datetime.now()


max_iterations = 5  

iteration = 0
while True:
    iteration += 1
    if end_date >= datetime.datetime.now():
        break
    
    ticker_symbol = "BTC-USD"
    bitcoin_data = yf.download(ticker_symbol, start=start_date, end=end_date, interval="1d")

    rsi_period = 14 
    bitcoin_data['RSI'] = RSIIndicator(bitcoin_data['Close'], window=rsi_period).rsi()

    def simulate_trading(bitcoin_data):
    
        position = None
        balance = 10000  # Initial balance
        holdings = 0
        transactions = []

        for index, row in bitcoin_data.iterrows():
            # Get RSI value and news signal for the current date
            rsi_value = row['RSI']
            news_signal = getNewsSignal(start_date)  # Assume this function is defined and returns True or False

            # Trading logic
            # if news_signal and rsi_value < 30 and position != 'BUY':
            if news_signal and position !='BUY':
                # Buy signal
                position = 'BUY'
                price = row['Close']
                holdings = balance / price
                balance = 0
                transactions.append({'Date': index, 'Action': 'BUY', 'Price': price})

            elif not news_signal and rsi_value > 75 and position != 'SELL':
                # Sell signal
                position = 'SELL'
                price = row['Close']
                balance = holdings * price
                holdings = 0
                transactions.append({'Date': index, 'Action': 'SELL', 'Price': price})

        # Calculate final balance and return transactions
        final_balance = balance + (holdings * bitcoin_data['Close'].iloc[-1])
        return final_balance, pd.DataFrame(transactions)
               
       

    # Run simulation
    final_balance, transactions = simulate_trading(bitcoin_data)

    # Print final balance and transactions
    print("Iteration:", iteration)
    print("Final Balance:", final_balance)
    print(transactions)

    # Update start_date for next iteration
    start_date = start_date + datetime.timedelta(days=1)

    # Optionally, break if max_iterations is reached
    if iteration >= max_iterations:
        break
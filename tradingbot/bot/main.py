from flask import Flask, request, jsonify
from datetime import datetime, timedelta
import pandas as pd
import yfinance as yf
from ta.momentum import RSIIndicator




import requests
import pandas as pd
import numpy as np 
import time
from newspaper import Article
import torch
import scipy.special
from transformers import AutoTokenizer, AutoModelForSequenceClassification

import pandas as pd
import numpy as np
import yfinance as yf
from ta.momentum import RSIIndicator

import asyncio
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore


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

current_datetime = datetime.now()
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
        news_signal = False
    else:
        news_signal = True

    print("Buy Signal:", news_signal)      
    
    return news_signal  






cred = credentials.Certificate("cred.json")
firebase_admin.initialize_app(cred)

db = firestore.client()




async def add_trade_data_async(uid, trade_data,ticker):
    
    doc_ref = db.collection('trade_history').document(uid)

    coin_collection_ref = doc_ref.collection('coins')


    coin_collection_ref.add({
        'Date': trade_data['Date'],
        'Action': trade_data['Action'],
        'Price': trade_data['Price'],
        'coin_amount': trade_data['coin_amount'],
        'ticker':trade_data['ticker']
    })


async def UpdateBalance(uid,total_balance,liquidity,Portfolio):
    doc_ref=db.collection('users').document(uid)
    doc_data = doc_ref.get().to_dict()
    previous_value = doc_data["Portfolio"]
    
    print("prev value...")
    print(previous_value)
    
    
    new_value = float(previous_value + Portfolio)
    doc_ref.update({
        # 'totalamount': total_balance,
         'liquidity':float(liquidity),
          'Portfolio':float(new_value)

    })
    


async def portfolio(uid,ticker,holding):
    
    doc_ref = db.collection('users').document(uid)

    coin_doc_ref = doc_ref.collection('coins').document(ticker)
    data= coin_doc_ref.get()
    if(data.exists):
        data= coin_doc_ref.get().to_dict()

        old_holding=data['holding']
        holding=int(old_holding+holding)
    coin_doc_ref.set({
        'holding': holding,
      
    })




app = Flask(__name__)
ticker_symbol = None
initial_balance = None
trading_paused = False



@app.route('/get_holding_map', methods=['POST'])
def get_holding_map():
    uid = request.json.get('uid')
    print(uid)
    if uid:     
        ref = db.collection('users').document(uid).collection('coins')

        coins_docs = ref.stream()

        doc_holding_map = {}

        for doc in coins_docs:
            data = doc.to_dict()
            
            coin_holding = data.get('holding')
            coin_name = doc.id

            doc_holding_map[coin_name] = coin_holding

        return jsonify(doc_holding_map), 200
    else:
        return jsonify({'error': 'No UID provided'}), 400








@app.route('/remove_asset', methods=['POST'])
async def remove_assset():
    try:
        data = request.get_json()
        uid = data.get('uid')
        ticker = data.get('ticker')

        if not uid or not ticker:
            return jsonify({'error': 'Missing uid or ticker in request'}), 400

        doc_ref = db.collection('users').document(uid)

        coin_doc_ref = doc_ref.collection("coins").document(ticker)

        coin_doc = coin_doc_ref.get()
        if coin_doc.exists:
            dataa = coin_doc.to_dict()
            data=dataa['holding']
            print('data....')
            print(data)
            # ydata = yf.download(ticker)
            end_date = datetime.now().strftime('%Y-%m-%d')
            start_date = (datetime.now() - timedelta(days=30)).strftime('%Y-%m-%d')
            ydata = yf.download(ticker, start=start_date, end=end_date)
            closing_price = float(ydata['Close'].iloc[-1])
            
            
            
            print('closing price ....')
            print(closing_price)
            
            amount =float(closing_price*data)
            print("amount ....")
            print(amount)
            doc_ref=db.collection('users').document(uid)
            doc_data = doc_ref.get().to_dict()
            
            portfolio = doc_data["Portfolio"]
            portfolio=abs(portfolio-amount)
            print('portfolio ...')
            print(portfolio)
            liquidity=doc_data['liquidity']
            liquidity=liquidity+amount
            
            total_amount=doc_data['totalamount']
            total_amount=liquidity+portfolio
            
            doc_ref.update({
                'totalamount':total_amount,
                'Portfolio': portfolio,
                'liquidity':liquidity
                
            })
            trade_data = {
                'Action': 'SELL',
                'Price': closing_price,
                'coin_amount': amount,
                'Date': end_date, 
                'ticker':ticker
            }
            await add_trade_data_async(uid=uid,ticker=ticker,trade_data=trade_data)
            try:
                coin_doc = doc_ref.collection('coins').document(ticker)
                coin_doc.delete()
            
            except Exception as e:
                print(e)
            
            return jsonify(data), 200
        else:
            return jsonify({'error': 'Document not found'}), 404
    except Exception as e:
        return jsonify({'error': str(e)}), 500





@app.route('/start_bot', methods=['POST'])
async def set_params():
        data = request.get_json()
        global ticker_symbol, initial_balance
        ticker_symbol = data.get('ticker_symbol')
        initial_balance = data.get('initial_balance')
        amount = data.get('amount')
        uid=data.get('uid')
        global trading_paused
        trading_paused = False
        if ticker_symbol=="btc":
            ticker_symbol="BTC-USD"
            
        if ticker_symbol=='eth':
            ticker_symbol="ETH-USD"
            
        if ticker_symbol =='usdt':
            ticker_symbol='USDT-USD'
            
        asyncio.create_task(simulate_trading(ticker_symbol, initial_balance, amount, uid))
    
        
        return jsonify({'message': 'Parameters set successfully.'}), 200



@app.route('/exit_trading', methods=['POST'])
def exit_trading():
    global trading_paused
    
    bool_value = request.json.get('bool_value')
    if bool_value is not None:
        
        trading_paused = bool(bool_value)
        
        return jsonify({'message': 'Boolean value updated successfully', 'bool_value': trading_paused}), 200
    
    else:
        return jsonify({'error': 'Missing bool_value in request data'}), 400





async def simulate_trading(ticker_symbol, initial_balance, amount, uid):
    ticker = ticker_symbol
    position = None
    liquidity = float(initial_balance)
    balance=float(liquidity)
    holdings = amount
    print(amount)
    transactions = []
    max_iterations = 20
    iteration = 0
    uid = uid
    print(ticker_symbol)
    print(initial_balance)
    print(amount)
    print(uid)

    while trading_paused == False:
        iteration += 1
        print(iteration)
        print(trading_paused)

        end_date = datetime.now().strftime('%Y-%m-%d')
        start_date = (datetime.now() - timedelta(days=30)).strftime('%Y-%m-%d')
        data = yf.download(ticker, start=start_date, end=end_date)
        rsi_period = 20  
        data['RSI'] = RSIIndicator(data['Close'], window=rsi_period).rsi()

        current_rsi = data['RSI'].iloc[-1]
        print("current rsi........")
        print(current_rsi)
        
        
        news_signal = getNewsSignal(start_date)
        print(f"{news_signal}........")

       
        trade_data = {}  
        
        print("data ....")
        print(data['Close'].iloc[-1])
        
        if liquidity<float(data['Close'].iloc[-1]*amount):
            break
        
        if news_signal and position != 'BUY':
            # Buy signal
            position = 'BUY'
            price = float(data['Close'].iloc[-1])  
            print("price.....")
            print(price)
            holdings = amount
            liquidity = liquidity-(amount*price)
            transactions.append({'Date': end_date, 'Action': 'BUY', 'Price': price, 'coin_amount': holdings})
            print("buy.....")
            print(liquidity)
            print(holdings)

            trade_data = {
                'Action': 'BUY',
                'Price': price,
                'coin_amount': holdings,
                'Date': end_date, 
                'ticker':ticker
            }
            

        elif not news_signal and current_rsi > 75 and position != 'SELL':
            # Sell signal
            position = 'SELL'
            price = data['Close'].iloc[-1]  
            liquidity = liquidity+(holdings * price)
            print(balance)
            holdings = 0
            transactions.append({'Date': current_rsi, 'Action': 'SELL', 'Price': price, 'coin_amount': holdings})
            print("sell....")
            print(liquidity)

            trade_data = {
                'Action': 'SELL',
                'Price': price,
                'coin_amount': amount,
                'Date': end_date, 
                'ticker':ticker
            }

        balance_with_assets = liquidity + (holdings * price)
        balance_without_assets=balance -(holdings*price) 
        Portfolio =holdings*price
        print("total balance ...")
        print(balance_with_assets)
        
        print("total liquidity ...")
        print(balance_without_assets)
        print(trade_data)
        
        if(trading_paused==True):
                break
        await add_trade_data_async(uid, trade_data,ticker)
        await UpdateBalance(uid=uid,total_balance=balance_with_assets,liquidity=balance_without_assets,Portfolio=Portfolio)
        await portfolio(uid=uid,holding=holdings,ticker=ticker)
        time.sleep(24 * 60 * 60)  


if __name__ == '__main__':
    app.run(debug=True,host="0.0.0.0")
















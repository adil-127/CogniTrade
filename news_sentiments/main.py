from urllib.error import URLError
from flask import Flask, jsonify,request

import pandas as pd
import requests
import scipy
import torch
from transformers import AutoTokenizer, AutoModelForSequenceClassification
from newspaper import Article

import requests
import pandas as pd
from datetime import datetime
import requests

import time
from newspaper import Article



app = Flask(__name__)
tokenizer = AutoTokenizer.from_pretrained("ProsusAI/finbert")
model = AutoModelForSequenceClassification.from_pretrained("ProsusAI/finbert")

def bert_sentiment(x):
    with torch.no_grad():
        input_sequence = tokenizer(str(x), return_tensors="pt", padding=True, truncation=True, max_length=512)
        logits = model(**input_sequence).logits
        scores = {k: v for k, v in zip(model.config.id2label.values(), scipy.special.softmax(logits.numpy().squeeze()))}
        sentiment_finbert = max(scores, key=scores.get)
        probability_finbert = max(scores.values())
        return sentiment_finbert




def fetch_article_content(url,source,date,img,title):
    column={}
    article = Article(url)
    article.download()
    time.sleep(1)
    article.parse()
    article.nlp()
    article_summary = article.summary.lower()
    keywords = ["price", 'crypto', "Bull", "coin", 'bear', 'fall', 'fed', 'interest rate ', 'economy']
    for keyword in keywords:
        if keyword.lower() in article_summary:
            column={"Article Summary":article.summary,
                    "source":source,
                    "date":date,
                    "img":img,
                    'url':url,
                    'title':title
                    }
            return column
        


@app.route('/sentiment_analysis', methods=['POST'])
def get_user_input():
    data = request.json
    text = data.get('text')  
    return analyze_sentiment(text)





@app.route('/sentiment_analysis/<text>', methods=['GET'])
def analyze_sentiment(text):
    print(text)
    article_summary = []
    current_datetime = datetime.now()

    current_date = current_datetime.date()

    print("Today's date is:", current_date)


    main_url=f'https://newsapi.org/v2/everything?q={text}  &from{current_date}=&to={current_date}&sortBy=relevancy&apiKey=bd976089ac4b4b3797005becb9cb1caf'
   
    try:
        news_data = requests.get(main_url).json()
        
        articles = news_data['articles']
        
        article_count = 0
       
        for arti in articles:
            if article_count >= 5:
                break
            key=arti.keys()
            print(key)
            url = arti['url']
            source=arti['source']
            date=arti['publishedAt']
            img=arti['urlToImage']
            title=arti['title']
            try:
                full_summary = fetch_article_content(url,source,date,img,title)
                # print(full_summary)
                article_summary.append(full_summary)
                # print(article_summary)
                article_count += 1
            except URLError as e:
                if isinstance(e.reason, ConnectionResetError):
                    print("Connection was reset. Retrying...")
                    time.sleep(5)
                else:
                    raise
            except Exception as e:
                print(f"Error fetching news: {e}")

        # df = pd.DataFrame({'Article Summary': article_summary})
        print("")
        
        article_summary = [item for item in article_summary if item is not None]
      
        df = pd.DataFrame(article_summary)
    
        df['Sentiment'] = df['Article Summary'].apply(bert_sentiment)
        json_data = df.to_json(orient='records')
        print(json_data)
        return json_data
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5001,host="0.0.0.0")

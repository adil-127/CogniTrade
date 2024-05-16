# # import yfinance as yf

# # btc = yf.Ticker("BTC-USD")

# # # Get the current price
# # current_price = btc.info['regularMarketPrice']

# # print(f"The current Bitcoin price is: ${current_price:.2f}")

# import asyncio
# import firebase_admin
# from firebase_admin import credentials
# from firebase_admin import firestore

# cred = credentials.Certificate("cred.json")
# firebase_admin.initialize_app(cred)

# db = firestore.client()
# doc_ref = db.collection('users').document("c6C1TB2E1OZI615yzZ9WHkI1orM2")

# # Get all subcollections under the document
# subcollections = doc_ref.collections()

# for subcollection in subcollections:
#     print("Subcollection name:", subcollection.id)



import requests
import json

api_url = 'http://127.0.0.1:5000/remove_asset'

test_data = {
    'uid': 'pYunp1RdLIX0PJwO6g7K4cizocp1',
    'ticker': 'BTC-USD'
}

response = requests.post(api_url, json=test_data)

if response.status_code == 200:
    print("Response Data:")
    print(response.json())
else:
    print("Error:", response.text)

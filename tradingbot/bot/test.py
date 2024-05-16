import requests
import json

base_url = "http://127.0.0.1:5000"  

start_bot_url = f"{base_url}/start_bot"


params_data = {
    "ticker_symbol": "btc",
    "initial_balance": 100000,
    "amount": 1,
    'uid':"c6C1TB2E1OZI615yzZ9WHkI1orM2",
}


response = requests.post(start_bot_url, json=params_data)
print(response.json()) 

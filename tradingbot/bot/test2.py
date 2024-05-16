import requests


base_url = "http://127.0.0.1:5000" 
exit_trading_url = f"{base_url}/exit_trading"

exit_data = {
    "bool_value": True
}

response = requests.post(exit_trading_url, json=exit_data)
print(response.json())  
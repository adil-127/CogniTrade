# import asyncio
# import firebase_admin
# from firebase_admin import credentials
# from firebase_admin import firestore

# cred = credentials.Certificate("cred.json")
# firebase_admin.initialize_app(cred)

# db = firestore.client()
# ref = db.collection('users').document("pYunp1RdLIX0PJwO6g7K4cizocp1").collection('coins')
# coins_docs = ref.stream()
# doc_holding_map = {}
# for doc in coins_docs:
#         # Retrieve the data of each document
#         data = doc.to_dict()
        
#         # Access specific fields in the document data
#         coin_holding = data.get('holding')
#         coin_name = doc.id
#         doc_holding_map[coin_name] = coin_holding
#         print(doc_holding_map)
import requests

def test_get_holding_map():
    url = 'http://localhost:5000/get_holding_map'

    payload = {'uid': 'pYunp1RdLIX0PJwO6g7K4cizocp1'}

    response = requests.post(url, json=payload)

    print('Response Status Code:', response.status_code)
    print('Response Content:')
    print(response.json())

if __name__ == '__main__':
    test_get_holding_map()
        
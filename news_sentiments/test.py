
import requests

base_url = 'http://127.0.0.1:5000'

text_data = {'text': 'bitcoin'}

post_response = requests.post(f'{base_url}/sentiment_analysis', json=text_data)
if post_response.status_code == 200:
    print("Text provided successfully for sentiment analysis.")
else:
    print(f"Failed to provide text for sentiment analysis. Status code: {post_response.status_code}")

get_response = requests.get(f'{base_url}/sentiment_analysis/{text_data["text"]}')
if get_response.status_code == 200:
    sentiment_analysis_results = get_response.json()
    print("Sentiment analysis results:")
    print(sentiment_analysis_results)
else:
    print(f"Failed to retrieve sentiment analysis results. Status code: {get_response.status_code}")

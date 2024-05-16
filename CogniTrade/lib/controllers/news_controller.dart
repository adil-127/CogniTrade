import 'package:crypto/Model/news_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SentimentAnalysisController extends GetxController {
  // var sentimentAnalysisResult = NewsModel().obs;
  List<dynamic> NewsData=[];


  Future<List<NewsModel>?> fetchData(String text) async {
    print("fetch");
    // final baseUrl = 'http://10.0.2.2:5001';

  final String baseUrl = "http://192.168.100.119:5001"; // Change this to your Flask app's URL
    try {
      final postResponse = await http.post(
        Uri.parse('$baseUrl/sentiment_analysis'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{'text': text}),
      );
      print("1");
      if (postResponse.statusCode == 200) {
        final getResponse = await http.get(Uri.parse('$baseUrl/sentiment_analysis/bitcoin'),headers:
           {
          "Content-Type": "application/json",
          "Accept": "application/json",
        });
    


        print("2");
        if (getResponse.statusCode == 200) {
          try {
            print("3");
          var x= getResponse.body;
          // print(x);
        
         var data = json.decode(x);
         print(data);

         print(data.runtimeType);
          print("4");
          print(data[0]['Article Summary']);
          for (int i = 0; i < data.length; i++){
          //    print("asdasdasdada");
           NewsData.add(NewsModel.fromJson(data[i])) ;
          
           
          print(NewsData[i].sentiment);

          }
          print("newsData");
          print(NewsData[0].sentiment);
          } catch (e) {
            print(e);
          }
          
        } else {
          throw Exception('Failed to retrieve sentiment analysis results. Status code: ${getResponse.statusCode}');
        }
      } else {
        throw Exception('Failed to provide text for sentiment analysis. Status code: ${postResponse.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }





  void disposeVariables() {
    // Dispose of each variable here
    NewsData=[];
  }

  @override
  void dispose() {
    disposeVariables();
    super.dispose();
  }
}
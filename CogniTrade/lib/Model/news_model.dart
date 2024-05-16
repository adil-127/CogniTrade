import 'dart:convert';

// List<NewsModel> NewsModelFromJson(String str) => List<NewsModel>.from(json.decode(str).map((x) => NewsModel.fromJson(x)));



class NewsModel {
  String? tittle;
  String? url;
  String? articleSummary;
  // String? source;
  String? date;
  String? img;
  String? sentiment;

  NewsModel({
    this.articleSummary = '',
    // this.source = '',
    this.date = '',
    this.img = '',
    this.sentiment = '',
  });

  //  factory NewsModel.fromJson(Map<String, dynamic> json) =>(
  //    NewsModel(
  //     articleSummary: json['Article Summary'] ?? '',
  //     source: json['source'] ?? '',
  //     date: json['date'] ?? '',
  //     img: json['img'] ?? '',
  //     sentiment: json['Sentiment'] ?? '',
  //   )
  // );
   
  NewsModel.fromJson(Map<String, dynamic> json) {
    tittle=json['title'];
    url=json['url'];
    articleSummary=json['Article Summary'];
    // source=json['source']['name'];
    date=json['date'];
    img=json['img'];
    sentiment=json['Sentiment'];
  }

   Map<String, dynamic> toJson() => {
    'Article Summary':articleSummary,
    // 'source':source,
    'date':date,
    'img':img,
    'Sentiment':sentiment
   };
}
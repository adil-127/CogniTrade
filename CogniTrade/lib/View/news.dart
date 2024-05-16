import 'package:crypto/controllers/news_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'package:url_launcher/url_launcher.dart';
// class news extends StatelessWidget {
  
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: NewsListScreen(),
//     );
//   }
// }


class NewsListScreen extends StatelessWidget {

  SentimentAnalysisController newsController=Get.put(SentimentAnalysisController());

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto News',style: TextStyle(color: Colors.black)),
         backgroundColor: Colors.amber[200],
         centerTitle: true,
      ),
      body:
      
FutureBuilder(
  future: newsController.fetchData("crypto"),
  builder: (BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (newsController.NewsData.isEmpty) {
      return Center(child: Text('No data available'));
    } else {
      return ListView.builder(
        itemCount: newsController.NewsData.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(8.0),
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  newsController.NewsData[0].date,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 8.0),
                
                 InkWell(
                  onLongPress: () async{
                                  // launchUrl(Uri.parse(newsController.NewsData[index].url.toString()) );
                                      // await launch(Uri.parse(url).toString()); // Convert string URL to Uri objectx  
                  },
                   child: Text(
                    newsController.NewsData[index].tittle,
                    style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold),

                    
                                 ),
                 ),
                                SizedBox(height: 8.0),

                Text(
                  newsController.NewsData[index].articleSummary,
                  style: TextStyle(fontSize: 16.0),
                  
                ),
                SizedBox(height: 8.0),
                Text(
                  'Sentiment: ${newsController.NewsData[index].sentiment}',
                  style: TextStyle(fontSize: 17.5,color:
                               newsController.NewsData[0].sentiment == 'negative'
            ? Colors.red
            :  Colors.green,),
                ),
                SizedBox(height: 8.0),
                Image.network(
                  newsController.NewsData[index].img,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200.0,
                ),
              ],
            ),
          );
        },
      );
    }
  },
),


      //  ListView.builder(
      //   itemCount: newsList.length,
      //   itemBuilder: (context, index) {
      //     final newsItem = newsList[index];
      //     return Container(
      //       margin: EdgeInsets.all(8.0),
      //       padding: EdgeInsets.all(8.0),
      //       decoration: BoxDecoration(
      //         border: Border.all(color: Colors.grey),
      //         borderRadius: BorderRadius.circular(8.0),
      //       ),
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: <Widget>[
      //           Text(
      //             newsItem.title,
      //             style: TextStyle(
      //               fontWeight: FontWeight.bold,
      //               fontSize: 18.0,
      //             ),
      //           ),
      //           SizedBox(height: 8.0),
      //           Text(
      //             newsItem.summary,
      //             style: TextStyle(fontSize: 16.0),
      //           ),
      //           SizedBox(height: 8.0),
      //           Text(
      //             'Sentiment: ${newsItem.sentiment}',
      //             style: TextStyle(fontSize: 14.0),
      //           ),
      //           SizedBox(height: 8.0),
      //           Image.network(
      //             newsItem.image,
      //             fit: BoxFit.cover,
      //             width: double.infinity,
      //             height: 200.0,
      //           ),
      //         ],
      //       ),
      //     );
      //   },
      // ),
   
   
    );
  }
}

import 'package:flutter/material.dart';
import 'package:samachar/data/database/news_database.dart';
import 'package:samachar/data/database/offline_news.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:intl/intl.dart';

class NewsArticle extends StatefulWidget {
  final String title;
  final String urlToImage;
  final String publishedAt;
  final String url;
  final String content;
  final String description;

  const NewsArticle({
    super.key,
    required this.title,
    required this.urlToImage,
    required this.publishedAt,
    required this.url,
    required this.content,
    required this.description,
  });

  @override
  State<NewsArticle> createState() => _NewsArticleState();
}

class _NewsArticleState extends State<NewsArticle> {
  final NewsDatabase newsDatabase = NewsDatabase();

  // DateTime dateTime;

  // function to launch the URL
  _launchURL() async {
    await launchUrlString(widget.url);
  }

  _saveArticle(context) async {
    final offlineNews = OfflineNews();
    offlineNews.title = widget.title;
    offlineNews.urlToImage = widget.urlToImage;
    offlineNews.publishedAt = widget.publishedAt;
    offlineNews.url = widget.url;
    offlineNews.content = widget.content;
    offlineNews.description = widget.description;

    var result = await newsDatabase.saveOfflineNews(offlineNews);
    if (!result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          content: const Text("Article saved successfully",
              style: TextStyle(color: Colors.black)),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          content: const Text("Article already saved",
              style: TextStyle(color: Colors.black)),
        ),
      );
    }
  }

  Widget space() {
    return const SizedBox(
      height: 20,
    );
  }

  String getDateTime(String datetime) {
    // 01234567890123456789
    // 2024-03-01T08:28:56Z
    // print("datetime test : $datetime");
    Map monthMap = {
      '01': 'Jan',
      '02': 'Feb',
      '03': 'Mar',
      '04': 'Apr',
      '05': 'May',
      '06': 'Jun',
      '07': 'Jul',
      '08': 'Aug',
      '09': 'Sep',
      '10': 'Oct',
      '11': 'Nov',
      '12': 'Dec',
    };

    return "Published on : ${datetime.substring(8, 10)}, ${monthMap[datetime.substring(5, 7)]}, ${datetime.substring(0, 4)} - ${datetime.substring(11, 16)}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News Article"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              space(),
              Text(
                widget.title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1),
              ),
              space(),
              const Divider(
                thickness: 0.2,
              ),
              space(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getDateTime(widget.publishedAt),
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              space(),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Image.network(
                  widget.urlToImage,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return const Center(child: Text("Loading.."));
                  },
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Center(
                      child: Container(
                        height: MediaQuery.sizeOf(context).width * 0.5,
                        width: MediaQuery.sizeOf(context).width,
                        color: Theme.of(context).colorScheme.secondary,
                        child: const Padding(
                            padding: EdgeInsets.all(20),
                            child: Icon(
                              Icons.newspaper,
                              size: 100,
                            )),
                      ),
                    );
                  },
                ),
              ),
              space(),
              Text(
                widget.description.characters.length < 5
                    ? widget.content
                    : widget.description,
                style: const TextStyle(fontSize: 18),
              ),
              space(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () => _saveArticle(context),
                    icon: const Icon(Icons.bookmark, size: 30),
                  ),
                  IconButton(
                    onPressed: () => _launchURL(),
                    icon: const Icon(Icons.public, size: 30),
                  ),
                  IconButton(
                    onPressed: () {
                      Share.shareUri(Uri.parse(widget.url));
                    },
                    icon: const Icon(
                      Icons.share,
                      size: 30,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

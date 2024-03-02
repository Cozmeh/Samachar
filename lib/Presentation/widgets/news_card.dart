import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samachar/Logic/blocs/offlineNews/offline_news_bloc.dart';
import 'package:samachar/Presentation/screens/news_article.dart';

class NewsCard extends StatefulWidget {
  // below will be used to show the news in the main feed
  final bool isDownloads;
  final int id;
  final String title;
  final String urlToImage;
  final String publishedAt;
  // above and below will be used in the news article screen
  final String url;
  final String content;
  final String description;
  const NewsCard({
    super.key,
    required this.title,
    required this.urlToImage,
    required this.publishedAt,
    required this.url,
    required this.content,
    required this.description,
    this.isDownloads = false,
    this.id = 0,
  });

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // open the news article in a webview\
          print("Tapped on : ${widget.title}");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewsArticle(
                        title: widget.title,
                        urlToImage: widget.urlToImage,
                        publishedAt: widget.publishedAt,
                        url: widget.url,
                        content: widget.content,
                        description: widget.description,
                      )));
        },
        child: SizedBox(
          child: Column(
            children: [
              // shows the image of the news
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                child: Image.network(
                  fit: BoxFit.cover,
                  widget
                      .urlToImage, // lets the image clip to the rounded corners
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return const Center(child: Text("Loading.."));
                  },
                  // if the image fails to load, show a newspaper icon
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return const Center(
                      child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Icon(Icons.newspaper)),
                    );
                  },
                ),
              ),
              // the title and published at date
              ListTile(
                trailing: widget.isDownloads
                    ? IconButton(
                        onPressed: () {
                          // delete the news from the database
                          BlocProvider.of<OfflineNewsBloc>(context)
                              .add(DeleteOfflineNews(widget.id));
                          // print("Deleted : ${widget.title}");
                        },
                        icon: const Icon(Icons.delete),
                      )
                    : null,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                title: Text(
                  widget.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 19),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    "${widget.publishedAt.substring(0, 10)} ${widget.publishedAt.substring(11, 16)}",
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Divider(
                  color: Colors.grey[700],
                  thickness: 0.5,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

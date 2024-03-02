import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samachar/Logic/blocs/news/news_bloc.dart';
import 'package:samachar/Presentation/widgets/news_card.dart';

class NewsFeed extends StatefulWidget {
  const NewsFeed({super.key});

  @override
  State<NewsFeed> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  @override
  void initState() {
    BlocProvider.of<NewsBloc>(context).add(LoadNews());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        //print("Bro : ${state.props.first}");
        if (state is NewsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is NewsLoaded) {
          // state.newsList.forEach((element) {
          //   print(element.title);
          // });
          return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: state.newsList.length,
              itemBuilder: (context, index) {
                return NewsCard(
                    title: state.newsList[index].title,
                    urlToImage: state.newsList[index].urlToImage,
                    publishedAt: state.newsList[index].publishedAt,
                    content: state.newsList[index].content,
                    url: state.newsList[index].url,
                    description: state.newsList[index].description);
              });
        } else if (state is NewsError) {
          return const Center(
            child: Text(
                textAlign: TextAlign.justify,
                "There was an error loading the news. Please try again.\n\nPossible reasons:\nNo internet connection, server error, etc."),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

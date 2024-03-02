import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samachar/Logic/blocs/offlineNews/offline_news_bloc.dart';
import 'package:samachar/Presentation/widgets/news_card.dart';

class Downloads extends StatefulWidget {
  const Downloads({super.key});

  @override
  State<Downloads> createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  @override
  void initState() {
    BlocProvider.of<OfflineNewsBloc>(context).add(LoadOfflineNews());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfflineNewsBloc, OfflineNewsState>(
      builder: (context, state) {
        if (state is OfflineNewsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is OfflineNewsLoaded) {
          if (state.news.isEmpty) {
            return const Center(
              child: Text('No articles saved'),
            );
          } else {
            return Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<OfflineNewsBloc>(context)
                          .add(DeleteAllOfflineNews());
                    },
                    child: const Text("Delete All")),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.news.length,
                      itemBuilder: (context, index) {
                        return NewsCard(
                          isDownloads: true,
                          id: state.news[index].id,
                          title: state.news[index].title,
                          urlToImage: state.news[index].urlToImage,
                          publishedAt: state.news[index].publishedAt,
                          content: state.news[index].content,
                          url: state.news[index].url,
                          description: state.news[index].description,
                        );
                      }),
                ),
              ],
            );
          }
        }
        if (state is OfflineNewsError) {
          return Center(
            child: Text(state.message),
          );
        }
        return const Center(
          child: Text('Could not load news :('),
        );
      },
    );
  }
}

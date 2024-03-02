import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.insert_drive_file_outlined,
                    size: 40,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Nothing here . . .")
                ],
              ),
            );
          } else {
            return Column(
              children: [
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
                ElevatedButton(
                    style: const ButtonStyle(
                        foregroundColor: MaterialStatePropertyAll(Colors.red)),
                    onPressed: () {
                      var exitBar = SnackBar(
                        backgroundColor: Colors.redAccent,
                        content: const Text(
                          "Do you want to Clear downloads ?",
                          style: TextStyle(color: Colors.black),
                        ),
                        action: SnackBarAction(
                            label: "Yes",
                            textColor: Colors.black,
                            onPressed: () {
                              BlocProvider.of<OfflineNewsBloc>(context)
                                  .add(DeleteAllOfflineNews());
                            }),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(exitBar);
                    },
                    child: const Text("Clear Downloads")),
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

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samachar/Logic/blocs/news/news_bloc.dart';
import 'package:samachar/Presentation/widgets/news_card.dart';

class CategoryFeed extends StatefulWidget {
  List<String>? selectedCategories;
  CategoryFeed({super.key, required this.selectedCategories});

  @override
  State<CategoryFeed> createState() => _CategoryFeedState();
}

class _CategoryFeedState extends State<CategoryFeed>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // BlocProvider.of<NewsBloc>(context).add(LoadCategoricalNews());
    _tabController = TabController(
      length: widget.selectedCategories!.length,
      vsync: this,
    );
    _tabController.addListener(_handleTabChange);
    super.initState();
  }

  void _handleTabChange() {
    // Get the current category based on the index of the selected tab
    String currentCategory = widget.selectedCategories![_tabController.index];
    // Call the function to load news for the current category
    BlocProvider.of<NewsBloc>(context)
        .add(LoadCategoricalNews(currentCategory));
  }

  @override
  Widget build(BuildContext context) {
    // print("Selected Categories: ${widget.selectedCategories}");
    return DefaultTabController(
      length: widget.selectedCategories!.length,
      child: Scaffold(
        body: Column(
          children: [
            TabBar(
                unselectedLabelStyle: const  TextStyle(fontWeight: FontWeight.normal),
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.center,
                physics: const BouncingScrollPhysics(),
                dividerColor: Colors.transparent,
                tabs: widget.selectedCategories!
                    .map((e) => Tab(
                          text: e,
                        ))
                    .toList()),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: widget.selectedCategories!
                    .map((e) => buildTabView(e))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTabView(String category) {
    BlocProvider.of<NewsBloc>(context).add(LoadCategoricalNews(category));
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        //print("lool : $state");
        if (state is NewsLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is CategoriesLoaded) {
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
          return SizedBox();
        }
      },
    );
  }
}

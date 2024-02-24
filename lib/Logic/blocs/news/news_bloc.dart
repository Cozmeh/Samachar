import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:samachar/Data/models/news_model.dart';
import 'package:samachar/Data/repos/news_repo.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository newsRepository;

  NewsBloc(this.newsRepository) : super(NewsLoading()) {
    on<LoadNews>(_onLoadNews);
    on<LoadCategoricalNews>(_onLoadCategoricalNews);
  }

  void _onLoadNews(LoadNews event, Emitter<NewsState> emit) async {
    //emit(NewsLoading());
    try {
      final newsList = await newsRepository.getNews();
      print(newsList.length);
      emit(NewsLoaded(newsList));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  void _onLoadCategoricalNews(
      LoadCategoricalNews event, Emitter<NewsState> emit) async {
    //emit(NewsLoading());
    try {
      final newsList = await newsRepository.getCategoryNews(event.category);
      emit(CategoriesLoaded(newsList));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }
}

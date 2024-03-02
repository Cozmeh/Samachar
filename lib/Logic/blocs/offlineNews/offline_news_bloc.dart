import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:samachar/data/database/news_database.dart';
import 'package:samachar/data/database/offline_news.dart';

part 'offline_news_event.dart';
part 'offline_news_state.dart';

class OfflineNewsBloc extends Bloc<OfflineNewsEvent, OfflineNewsState> {
  final NewsDatabase newsDatabase;

  OfflineNewsBloc(this.newsDatabase) : super(OfflineNewsLoading()) {
    on<LoadOfflineNews>(_onLoadOfflineNews);
    on<DeleteOfflineNews>(_onDeleteOfflineNews);
    on<DeleteAllOfflineNews>(_onDeleteAllOfflineNews);
  }

  void _onLoadOfflineNews(
      LoadOfflineNews event, Emitter<OfflineNewsState> emit) async {
    try {
      final offlineNews = await newsDatabase.getOfflineNews();
      emit(OfflineNewsLoaded(offlineNews));
    } catch (e) {
      emit(OfflineNewsError(e.toString()));
    }
  }

  void _onDeleteOfflineNews(
      DeleteOfflineNews event, Emitter<OfflineNewsState> emit) async {
    try {
      await newsDatabase.deleteOfflineNews(event.id);
      final offlineNews = await newsDatabase.getOfflineNews();
      emit(OfflineNewsLoaded(offlineNews));
    } catch (e) {
      emit(OfflineNewsError(e.toString()));
    }
  }

  void _onDeleteAllOfflineNews(
      DeleteAllOfflineNews event, Emitter<OfflineNewsState> emit) async {
    try {
      await newsDatabase.deleteAllOfflineNews();
      final offlineNews = await newsDatabase.getOfflineNews();
      emit(OfflineNewsLoaded(offlineNews));
    } catch (e) {
      emit(OfflineNewsError(e.toString()));
    }
  }
}

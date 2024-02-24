part of 'offline_news_bloc.dart';

sealed class OfflineNewsState extends Equatable {
  const OfflineNewsState();
  
  @override
  List<Object> get props => [];
}

final class OfflineNewsInitial extends OfflineNewsState {}


final class OfflineNewsLoading extends OfflineNewsState {}


final class OfflineNewsLoaded extends OfflineNewsState {
  final List<OfflineNews> news;
  const OfflineNewsLoaded(this.news);

  @override
  List<Object> get props => [news];
}

final class OfflineNewsError extends OfflineNewsState {
  final String message;
  const OfflineNewsError(this.message);

  @override
  List<Object> get props => [message];
}

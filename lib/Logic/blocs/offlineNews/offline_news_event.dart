part of 'offline_news_bloc.dart';

sealed class OfflineNewsEvent extends Equatable {
  const OfflineNewsEvent();

  @override
  List<Object> get props => [];
}

final class LoadOfflineNews extends OfflineNewsEvent {}

final class DeleteOfflineNews extends OfflineNewsEvent {
  final int id;
  const DeleteOfflineNews(this.id);

  @override
  List<Object> get props => [id];
}

final class DeleteAllOfflineNews extends OfflineNewsEvent{}
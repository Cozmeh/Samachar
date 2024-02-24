part of 'news_bloc.dart';

sealed class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

class LoadNews extends NewsEvent {}

class LoadCategoricalNews extends NewsEvent {
  final String category;

  LoadCategoricalNews(this.category);

  @override
  List<Object> get props => [category];
}

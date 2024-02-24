part of 'news_bloc.dart';

sealed class NewsState extends Equatable {
  const NewsState();
  
  @override
  List<Object> get props => [];
}

final class NewsInitial extends NewsState {}

final class NewsLoading extends NewsState {}

// state for news loaded
final class NewsLoaded extends NewsState {
  final List<News> newsList;

  const NewsLoaded(this.newsList);

  @override
  List<Object> get props => [newsList];
}

// state for categories loaded
final class CategoriesLoaded extends NewsState {
  final List<News> newsList;

  const CategoriesLoaded(this.newsList);

  @override
  List<Object> get props => [newsList];
}

// state for error when loading news fails
final class NewsError extends NewsState {
  final String errorMessage;

  const NewsError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';

class SearchTvSeriesState extends Equatable {
  final RequestState searchTvSeriesState;
  final List<TvSeries> tvSeriesList;
  final String message;

  SearchTvSeriesState({
    required this.searchTvSeriesState,
    required this.moviesList,
    required this.message,
  });

  SearchTvSeriesState copyWith({
    RequestState? searchTvSeriesState,
    List<Movie>? moviesList,
    String? message,
  }) {
    return SearchTvSeriesState(
      searchTvSeriesState: searchTvSeriesState ?? this.searchTvSeriesState,
      moviesList: moviesList ?? this.moviesList,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        searchTvSeriesState,
        moviesList,
        message,
      ];
}

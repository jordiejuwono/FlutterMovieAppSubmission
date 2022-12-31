import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

class TopRatedMoviesState extends Equatable {
  final RequestState topRatedMoviesState;
  final List<Movie> topRatedMovies;

  TopRatedMoviesState({
    required this.topRatedMoviesState,
    required this.topRatedMovies,
  });

  TopRatedMoviesState copyWith(
      {RequestState? topRatedMoviesState, List<Movie>? topRatedMovies}) {
    return TopRatedMoviesState(
      topRatedMoviesState: topRatedMoviesState ?? this.topRatedMoviesState,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
    );
  }

  @override
  List<Object?> get props => [
        topRatedMoviesState,
        topRatedMovies,
      ];
}

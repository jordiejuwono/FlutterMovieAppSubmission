import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

class PopularMoviesState extends Equatable {
  final RequestState popularMoviesState;
  final List<Movie> popularMovies;

  PopularMoviesState({
    required this.popularMoviesState,
    required this.popularMovies,
  });

  PopularMoviesState copyWith(
      {RequestState? popularMoviesState, List<Movie>? popularMovies}) {
    return PopularMoviesState(
      popularMoviesState: popularMoviesState ?? this.popularMoviesState,
      popularMovies: popularMovies ?? this.popularMovies,
    );
  }

  @override
  List<Object?> get props => [
        popularMoviesState,
        popularMovies,
      ];
}

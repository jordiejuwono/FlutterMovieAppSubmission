import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies/top_rated_movies_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedMoviesCubit extends Cubit<TopRatedMoviesState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedMoviesCubit({
    required this.getTopRatedMovies,
  }) : super(TopRatedMoviesState(
          topRatedMoviesState: RequestState.Empty,
          topRatedMovies: [],
        ));

  Future<void> fetchPopularMovies() async {
    emit(state.copyWith(
        topRatedMoviesState: RequestState.Loading, topRatedMovies: []));
    final result = await getTopRatedMovies.execute();
    result.fold((failure) {
      emit(state.copyWith(topRatedMoviesState: RequestState.Error));
    }, (result) {
      emit(state.copyWith(
          topRatedMoviesState: RequestState.Loaded, topRatedMovies: result));
    });
  }
}

import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/bloc/search_movie/search_movie_event.dart';
import 'package:ditonton/presentation/bloc/search_movie/search_movie_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchMovieBloc extends Bloc<SearchMovieEvent, SearchMovieState> {
  final SearchMovies searchMovies;
  SearchMovieBloc({
    required this.searchMovies,
  }) : super(SearchMovieState(
          searchMovieState: RequestState.Empty,
          moviesList: [],
          message: '',
        )) {
    on<SearchMovieFetchEvent>(_fetchSearchedMovies);
  }

  Future<void> _fetchSearchedMovies(
      SearchMovieEvent event, Emitter<SearchMovieState> emit) async {
    if (event is SearchMovieFetchEvent) {
      emit(state.copyWith(searchMovieState: RequestState.Loading));
      final result = await searchMovies.execute(event.query);
      result.fold((failure) {
        emit(state.copyWith(
            searchMovieState: RequestState.Error, message: failure.message));
      }, (result) {
        emit(state.copyWith(
            searchMovieState: RequestState.Loaded, moviesList: result));
      });
    }
  }
}

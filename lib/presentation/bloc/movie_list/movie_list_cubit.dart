import 'package:bloc/bloc.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movie_list/movie_list_state.dart';

class MovieListCubit extends Cubit<MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MovieListCubit({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(MovieListState(
          nowPlayingState: RequestState.Empty,
          popularState: RequestState.Empty,
          topRatedState: RequestState.Empty,
          nowPlayingList: [],
          popularList: [],
          topRatedList: [],
        ));

  Future<void> fetchNowPlayingMovies() async {
    emit(state
        .copyWith(nowPlayingState: RequestState.Loading, nowPlayingList: []));
    final result = await getNowPlayingMovies.execute();
    result.fold((failure) {
      emit(state.copyWith(nowPlayingState: RequestState.Error));
    }, (result) {
      emit(state.copyWith(
          nowPlayingState: RequestState.Loaded, nowPlayingList: result));
    });
  }

  Future<void> fetchPopularMovies() async {
    emit(state.copyWith(popularState: RequestState.Loading, popularList: []));
    final result = await getPopularMovies.execute();
    result.fold((failure) {
      emit(state.copyWith(popularState: RequestState.Error));
    }, (result) {
      emit(state.copyWith(
          popularState: RequestState.Loaded, popularList: result));
    });
  }

  Future<void> fetchTopRatedMovies() async {
    emit(state.copyWith(topRatedState: RequestState.Loading, topRatedList: []));
    final result = await getTopRatedMovies.execute();
    result.fold((failure) {
      emit(state.copyWith(topRatedState: RequestState.Error));
    }, (result) {
      emit(state.copyWith(
          topRatedState: RequestState.Loaded, topRatedList: result));
    });
  }
}

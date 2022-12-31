import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailCubit extends Cubit<MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailCubit({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieDetailState(
          movieDetailState: RequestState.Empty,
          movieDetail: MovieDetail(
            adult: false,
            backdropPath: "",
            genres: [],
            id: 0,
            originalTitle: "",
            overview: "",
            posterPath: "",
            releaseDate: "",
            runtime: 0,
            title: "",
            voteAverage: 0,
            voteCount: 0,
          ),
          isAddedToWatchlist: false,
          movieRecommendations: [],
          recommendationsState: RequestState.Empty,
          watchlistMessage: "",
          message: "",
        ));

  Future<void> fetchMovieDetails(int id) async {
    emit(state.copyWith(movieDetailState: RequestState.Loading));
    final detailResult = await getMovieDetail.execute(id);
    final recommendationsResult = await getMovieRecommendations.execute(id);
    detailResult.fold((failure) {
      emit(state.copyWith(
          movieDetailState: RequestState.Error, message: failure.message));
    }, (result) {
      emit(state.copyWith(recommendationsState: RequestState.Loading));
      emit(state.copyWith(
          movieDetailState: RequestState.Loaded, movieDetail: result));
      recommendationsResult.fold((failure) {
        emit(state.copyWith(recommendationsState: RequestState.Error));
      }, (result) {
        emit(state.copyWith(
            recommendationsState: RequestState.Loaded,
            movieRecommendations: result));
      });
    });
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }

  Future<void> addWatchlist(MovieDetail movie) async {
    final result = await saveWatchlist.execute(movie);
    result.fold((failure) {
      emit(state.copyWith(watchlistMessage: failure.message));
    }, (result) {
      emit(state.copyWith(watchlistMessage: result));
    });

    await loadWatchlistStatus(movie.id);
  }

  Future<void> removeFromWatchlist(MovieDetail movie) async {
    final result = await removeWatchlist.execute(movie);
    result.fold((failure) {
      emit(state.copyWith(watchlistMessage: failure.message));
    }, (result) {
      emit(state.copyWith(watchlistMessage: result));
    });

    await loadWatchlistStatus(movie.id);
  }
}

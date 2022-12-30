import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_tv_series_watchlist.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:flutter/foundation.dart';

class WatchlistMovieNotifier extends ChangeNotifier {
  var _watchlistMovies = <Movie>[];
  List<Movie> get watchlistMovies => _watchlistMovies;

  var _watchlistTvSeries = <TvSeries>[];
  List<TvSeries> get watchlistTvSeries => _watchlistTvSeries;

  var _watchlistState = RequestState.Empty;
  RequestState get watchlistState => _watchlistState;

  var _tvSeriesState = RequestState.Empty;
  RequestState get tvSeriesState => _tvSeriesState;

  String _message = '';
  String get message => _message;

  WatchlistMovieNotifier({
    required this.getWatchlistMovies,
    required this.getTvSeriesWatchlist,
  });

  final GetWatchlistMovies getWatchlistMovies;
  final GetTvSeriesWatchlist getTvSeriesWatchlist;

  Future<void> fetchWatchlistMovies() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistMovies.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _watchlistState = RequestState.Loaded;
        _watchlistMovies = moviesData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTvSeriesWatchlist() async {
    _tvSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getTvSeriesWatchlist.execute();
    result.fold((failure) {
      _tvSeriesState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (tvSeriesData) {
      _tvSeriesState = RequestState.Loaded;
      _watchlistTvSeries = tvSeriesData;
      notifyListeners();
    });
  }
}

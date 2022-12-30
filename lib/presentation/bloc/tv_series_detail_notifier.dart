import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_details.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_tv_series_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_tv_series_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tv_series_watchlist.dart';
import 'package:flutter/material.dart';

class TvSeriesDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvSeriesDetail getTvSeriesDetail;
  final SaveTvSeriesWatchlist saveTvSeriesWatchlist;
  final RemoveTvSeriesWatchlist removeTvSeriesWatchlist;
  final GetTvSeriesWatchlistStatus getTvSeriesWatchlistStatus;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;

  TvSeriesDetailNotifier({
    required this.getTvSeriesDetail,
    required this.saveTvSeriesWatchlist,
    required this.removeTvSeriesWatchlist,
    required this.getTvSeriesWatchlistStatus,
    required this.getTvSeriesRecommendations,
  });

  TvDetails? _tvSeries;
  TvDetails? get tvSeries => _tvSeries;

  RequestState _tvSeriesState = RequestState.Empty;
  RequestState get tvSeriesState => _tvSeriesState;

  List<TvSeries> _tvSeriesRecommendations = [];
  List<TvSeries> get tvSeriesRecommendations => _tvSeriesRecommendations;

  RequestState _tvSeriesRecommendationsState = RequestState.Empty;
  RequestState get tvSeriesRecommendationsState =>
      _tvSeriesRecommendationsState;

  String _message = '';
  String get message => _message;

  bool _isAddedToWatchlist = false;
  bool get isAddedToWatchlist => _isAddedToWatchlist;

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> fetchTvSeriesDetail(int seriesId) async {
    _tvSeriesState = RequestState.Loading;
    notifyListeners();

    final result = await getTvSeriesDetail.execute(seriesId);
    result.fold((failure) {
      _tvSeriesState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (detailData) {
      _tvSeriesState = RequestState.Loaded;
      _tvSeries = detailData;
      notifyListeners();
    });
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getTvSeriesWatchlistStatus.execute(id);
    _isAddedToWatchlist = result;
    notifyListeners();
  }

  Future<void> addTvSeriesWatchlist(TvDetails tv) async {
    final result = await saveTvSeriesWatchlist.execute(tv);

    result.fold(
      (failure) {
        _watchlistMessage = failure.message;
      },
      (success) {
        _watchlistMessage = success;
      },
    );

    await loadWatchlistStatus(tv.id);
  }

  Future<void> removeTvSeriesFromWatchlist(TvDetails tv) async {
    final result = await removeTvSeriesWatchlist.execute(tv);

    result.fold((failure) {
      _watchlistMessage = failure.message;
    }, (success) {
      _watchlistMessage = success;
    });

    loadWatchlistStatus(tv.id);
  }

  Future<void> fetchTvSeriesRecommendations(int seriesId) async {
    _tvSeriesRecommendationsState = RequestState.Loading;
    notifyListeners();

    final result = await getTvSeriesRecommendations.execute(seriesId);
    result.fold((failure) {
      _tvSeriesRecommendationsState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (recommendationsData) {
      _tvSeriesRecommendationsState = RequestState.Loaded;
      _tvSeriesRecommendations = recommendationsData;
      notifyListeners();
    });
  }
}

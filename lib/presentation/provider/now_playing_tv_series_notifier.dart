import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_series.dart';
import 'package:flutter/material.dart';

class NowPlayingTvSeriesNotifier extends ChangeNotifier {
  final GetNowPlayingTvSeries getNowPlayingTvSeries;
  NowPlayingTvSeriesNotifier({
    required this.getNowPlayingTvSeries,
  });

  List<TvSeries> _nowPlayingTvSeries = [];
  List<TvSeries> get nowPlayingTvSeries => _nowPlayingTvSeries;

  String _message = "";
  String get message => _message;

  RequestState _nowPlayingState = RequestState.Empty;
  RequestState get nowPlayingState => _nowPlayingState;

  Future<void> fetchNowPlayingTvSeries() async {
    _nowPlayingState = RequestState.Loading;
    notifyListeners();
    final result = await getNowPlayingTvSeries.execute();
    result.fold((failure) {
      _nowPlayingState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (nowPlayingData) {
      _nowPlayingState = RequestState.Loaded;
      _nowPlayingTvSeries = nowPlayingData;
      notifyListeners();
    });
  }
}

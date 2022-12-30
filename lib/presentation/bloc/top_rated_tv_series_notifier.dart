import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:flutter/material.dart';

class TopRatedTvSeriesNotifier extends ChangeNotifier {
  final GetTopRatedTvSeries getTopRatedTvSeries;
  TopRatedTvSeriesNotifier({
    required this.getTopRatedTvSeries,
  });

  List<TvSeries> _topRatedTvSeries = [];
  List<TvSeries> get topRatedTvSeries => _topRatedTvSeries;

  String _message = '';
  String get message => _message;

  RequestState _topRatedState = RequestState.Empty;
  RequestState get topRatedState => _topRatedState;

  Future<void> fetchTopRatedTvSeries() async {
    _topRatedState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvSeries.execute();
    result.fold((failure) {
      _topRatedState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (topRatedData) {
      _topRatedState = RequestState.Loaded;
      _topRatedTvSeries = topRatedData;
      notifyListeners();
    });
  }
}

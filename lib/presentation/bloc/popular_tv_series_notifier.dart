import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:flutter/material.dart';

class PopularTvSeriesNotifier extends ChangeNotifier {
  final GetPopularTvSeries getPopularTvSeries;
  PopularTvSeriesNotifier({
    required this.getPopularTvSeries,
  });

  List<TvSeries> _popularTvSeries = [];
  List<TvSeries> get popularTvSeries => _popularTvSeries;

  String _message = '';
  String get message => _message;

  RequestState _popularState = RequestState.Empty;
  RequestState get popularState => _popularState;

  Future<void> fetchPopularTvSeries() async {
    _popularState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvSeries.execute();
    result.fold((failure) {
      _popularState = RequestState.Error;
      _message = failure.message;
      notifyListeners();
    }, (popularData) {
      _popularState = RequestState.Loaded;
      _popularTvSeries = popularData;
      notifyListeners();
    });
  }
}

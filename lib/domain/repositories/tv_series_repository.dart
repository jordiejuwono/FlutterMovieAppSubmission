import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_details.dart';
import 'package:ditonton/domain/entities/tv_series.dart';

abstract class TvSeriesRepository {
  // Remote
  Future<Either<Failure, List<TvSeries>>> getNowPlayingTvSeries();
  Future<Either<Failure, List<TvSeries>>> getPopularTvSeries();
  Future<Either<Failure, List<TvSeries>>> getTopRatedTvSeries();
  Future<Either<Failure, TvDetails>> getTvSeriesDetails(int seriesId);
  Future<Either<Failure, List<TvSeries>>> getSearchedTvSeries(String query);
  Future<Either<Failure, List<TvSeries>>> getTvSeriesRecommendations(
      int seriesId);
  // Local
  Future<Either<Failure, String>> insertWatchlist(TvDetails tvSeries);
  Future<Either<Failure, String>> removeWatchlist(TvDetails tvSeries);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<TvSeries>>> getWatchlistTvSeries();
}

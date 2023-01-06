import 'dart:io';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_series_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/data/models/tvseries/tv_series_table.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_details.dart';
import 'package:ditonton/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';

class TvSeriesRepositoryImpl extends TvSeriesRepository {
  final TvSeriesRemoteDataSource tvSeriesRemoteDataSource;
  final TvSeriesLocalDataSource tvSeriesLocalDataSource;
  TvSeriesRepositoryImpl({
    required this.tvSeriesRemoteDataSource,
    required this.tvSeriesLocalDataSource,
  });

  @override
  Future<Either<Failure, List<TvSeries>>> getNowPlayingTvSeries() async {
    try {
      final result = await tvSeriesRemoteDataSource.getNowPlayingTvSeries();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on TlsException catch (e) {
      return Left(ServerFailure('Certification not valid ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getPopularTvSeries() async {
    try {
      final result = await tvSeriesRemoteDataSource.getPopularTvSeries();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on TlsException catch (e) {
      return Left(ServerFailure('Certification not valid ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getSearchedTvSeries(
      String query) async {
    try {
      final result = await tvSeriesRemoteDataSource.getSearchedTvSeries(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on TlsException catch (e) {
      return Left(ServerFailure('Certification not valid ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getTopRatedTvSeries() async {
    try {
      final result = await tvSeriesRemoteDataSource.getTopRatedTvSeries();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on TlsException catch (e) {
      return Left(ServerFailure('Certification not valid ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, TvDetails>> getTvSeriesDetails(int seriesId) async {
    try {
      final result =
          await tvSeriesRemoteDataSource.getTvSeriesDetails(seriesId);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on TlsException catch (e) {
      return Left(ServerFailure('Certification not valid ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getTvSeriesRecommendations(
      int seriesId) async {
    try {
      final result =
          await tvSeriesRemoteDataSource.getTvSeriesRecommendations(seriesId);
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    } on TlsException catch (e) {
      return Left(ServerFailure('Certification not valid ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<TvSeries>>> getWatchlistTvSeries() async {
    final result = await tvSeriesLocalDataSource.getWatchlistTvSeries();
    return Right(result.map((data) => data.toEntity()).toList());
  }

  @override
  Future<Either<Failure, String>> insertWatchlist(TvDetails tvSeries) async {
    try {
      final result = await tvSeriesLocalDataSource
          .insertWatchlist(TvSeriesTable.fromEntity(tvSeries));
      return Right(result);
    } on DatabaseException catch (e) {
      return left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final result = await tvSeriesLocalDataSource.getTvSeriesById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(TvDetails tvSeries) async {
    try {
      final result = await tvSeriesLocalDataSource
          .removeWatchlist(TvSeriesTable.fromEntity(tvSeries));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}

import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/tvseries/tv_series_details.dart';
import 'package:ditonton/data/models/tvseries/tv_series_results.dart';
import 'package:ditonton/data/repositories/tv_series_repository_impl.dart';
import 'package:ditonton/domain/entities/tv_genre.dart';
import 'package:ditonton/domain/entities/tv_season.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRepositoryImpl repository;
  late MockTvSeriesRemoteDataSource mockTvSeriesRemoteDataSource;
  late MockTvSeriesLocalDataSource mockTvSeriesLocalDataSource;

  setUp(() {
    mockTvSeriesRemoteDataSource = MockTvSeriesRemoteDataSource();
    mockTvSeriesLocalDataSource = MockTvSeriesLocalDataSource();
    repository = TvSeriesRepositoryImpl(
        tvSeriesRemoteDataSource: mockTvSeriesRemoteDataSource,
        tvSeriesLocalDataSource: mockTvSeriesLocalDataSource);
  });

  final tvSeriesModel = TvSeriesResults(
    backdropPath: "test",
    firstAirDate: "test",
    genreIds: [1, 2, 3],
    id: 1,
    name: "test",
    originCountry: ["DEN"],
    originalLanguage: "test",
    originalName: "test",
    overview: "test",
    popularity: 1,
    posterPath: "test",
    voteAverage: 1,
    voteCount: 1,
  );

  final tvSeries = TvSeries(
    backdropPath: "test",
    firstAirDate: "test",
    genreIds: [1, 2, 3],
    id: 1,
    name: "test",
    originCountry: ["DEN"],
    originalLanguage: "test",
    originalName: "test",
    overview: "test",
    popularity: 1,
    posterPath: "test",
    voteAverage: 1,
    voteCount: 1,
  );

  final tvSeriesResultList = <TvSeriesResults>[tvSeriesModel];
  final tvSeriesList = <TvSeries>[tvSeries];

  group('now playing tv series', () {
    test(
        'should return remote data when call to remote data source is successful',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getNowPlayingTvSeries())
          .thenAnswer((_) async => tvSeriesResultList);
      // act
      final result = await repository.getNowPlayingTvSeries();
      // assert
      verify(mockTvSeriesRemoteDataSource.getNowPlayingTvSeries());

      final resultList = result.getOrElse(() => []);
      expect(resultList, tvSeriesList);
    });

    test('should return server failure when call to remote data source failed',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getNowPlayingTvSeries())
          .thenThrow(ServerException());
      // act
      final result = await repository.getNowPlayingTvSeries();
      // assert
      verify(mockTvSeriesRemoteDataSource.getNowPlayingTvSeries());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when device not connected to internet',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getNowPlayingTvSeries())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getNowPlayingTvSeries();
      // assert
      verify(mockTvSeriesRemoteDataSource.getNowPlayingTvSeries());
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('popular tv series', () {
    test(
        'should return remote data when call to remote data source is successful',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getPopularTvSeries())
          .thenAnswer((_) async => tvSeriesResultList);
      // act
      final result = await repository.getPopularTvSeries();
      // assert
      verify(mockTvSeriesRemoteDataSource.getPopularTvSeries());

      final resultList = result.getOrElse(() => []);
      expect(resultList, tvSeriesList);
    });

    test('should return server failure when call to remote data source failed',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getPopularTvSeries())
          .thenThrow(ServerException());
      // act
      final result = await repository.getPopularTvSeries();
      // assert
      verify(mockTvSeriesRemoteDataSource.getPopularTvSeries());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when device not connected to internet',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getPopularTvSeries())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getPopularTvSeries();
      // assert
      verify(mockTvSeriesRemoteDataSource.getPopularTvSeries());
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('top rated tv series', () {
    test(
        'should return remote data when call to remote data source is successful',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getTopRatedTvSeries())
          .thenAnswer((_) async => tvSeriesResultList);
      // act
      final result = await repository.getTopRatedTvSeries();
      // assert
      verify(mockTvSeriesRemoteDataSource.getTopRatedTvSeries());

      final resultList = result.getOrElse(() => []);
      expect(resultList, tvSeriesList);
    });

    test('should return server failure when call to remote data source failed',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getTopRatedTvSeries())
          .thenThrow(ServerException());
      // act
      final result = await repository.getTopRatedTvSeries();
      // assert
      verify(mockTvSeriesRemoteDataSource.getTopRatedTvSeries());
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return connection failure when device not connected to internet',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getTopRatedTvSeries())
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTopRatedTvSeries();
      // assert
      verify(mockTvSeriesRemoteDataSource.getTopRatedTvSeries());
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('get tv series details', () {
    final id = 1;
    final tvSeriesDetail = TvSeriesDetails(
      adult: false,
      backdropPath: 'backdropPath',
      createdBy: ['createdBy'],
      episodeRunTime: [1],
      genres: [
        Genre(id: 1, name: 'Drama'),
      ],
      homepage: 'homePage',
      id: 1,
      name: 'tvSeriesTitle',
      posterPath: 'posterPath',
      overview: 'tvOverview',
      inProduction: false,
      languages: ['en'],
      numberOfEpisodes: 12,
      numberOfSeasons: 3,
      originCountry: ['den'],
      originalLanguage: 'id',
      originalName: 'originalName',
      popularity: 1,
      productionCountries: [],
      seasons: [
        Season(
            airDate: DateTime(0),
            episodeCount: 0,
            id: 1,
            name: "season",
            overview: "overview",
            posterPath: "path",
            seasonNumber: 1),
      ],
      status: 'status',
      tagline: 'tagline',
      type: 'type',
      voteAverage: 1,
      voteCount: 1,
    );

    test(
        'should return tv series data when call to remote data source is successful',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getTvSeriesDetails(id))
          .thenAnswer((_) async => tvSeriesDetail);
      // act
      final result = await repository.getTvSeriesDetails(id);
      // assert
      verify(mockTvSeriesRemoteDataSource.getTvSeriesDetails(id));
      expect(result, equals(Right(testTvSeriesDetail)));
    });

    test('should return ServerFailure when call to remote data source failed',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getTvSeriesDetails(id))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvSeriesDetails(id);
      // assert
      verify(mockTvSeriesRemoteDataSource.getTvSeriesDetails(id));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test('should return SocketException when there is no connection', () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getTvSeriesDetails(id))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvSeriesDetails(id);
      // assert
      verify(mockTvSeriesRemoteDataSource.getTvSeriesDetails(id));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('get tv series recommendations', () {
    final tvSeriesList = <TvSeriesResults>[];
    final id = 0;

    test('should return data list when call is successful', () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getTvSeriesRecommendations(id))
          .thenAnswer((_) async => tvSeriesList);
      // act
      final result = await repository.getTvSeriesRecommendations(id);
      // assert
      verify(mockTvSeriesRemoteDataSource.getTvSeriesRecommendations(id));
      final resultList = result.getOrElse(() => []);
      expect(resultList, equals(tvSeriesList));
    });

    test('should return ServerFailure when call to remote data source failed',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getTvSeriesRecommendations(id))
          .thenThrow(ServerException());
      // act
      final result = await repository.getTvSeriesRecommendations(id);
      // assert
      verify(mockTvSeriesRemoteDataSource.getTvSeriesRecommendations(id));
      expect(result, equals(Left(ServerFailure(''))));
    });

    test(
        'should return ConnectionFailure when call to remote data source failed',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getTvSeriesRecommendations(id))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getTvSeriesRecommendations(id);
      // assert
      verify(mockTvSeriesRemoteDataSource.getTvSeriesRecommendations(id));
      expect(result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))));
    });
  });

  group('search tv series', () {
    final query = 'All of Us';

    test('should return tv series list when call to data source is success',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getSearchedTvSeries(query))
          .thenAnswer((_) async => tvSeriesResultList);
      // act
      final result = await repository.getSearchedTvSeries(query);
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, tvSeriesList);
    });

    test('should return ServerFailure when call to data source failed',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getSearchedTvSeries(query))
          .thenThrow(ServerException());
      // act
      final result = await repository.getSearchedTvSeries(query);
      // assert
      expect(result, Left(ServerFailure('')));
    });

    test('should return ConnectionFailure when call to data source failed',
        () async {
      // arrange
      when(mockTvSeriesRemoteDataSource.getSearchedTvSeries(query))
          .thenThrow(SocketException('Failed to connect to the network'));
      // act
      final result = await repository.getSearchedTvSeries(query);
      // assert
      expect(
          result, Left(ConnectionFailure('Failed to connect to the network')));
    });
  });

  group('save watchlist', () {
    test('should return success message when save to database success',
        () async {
      // arrange
      when(mockTvSeriesLocalDataSource.insertWatchlist(testTvSeriesTable))
          .thenAnswer((_) async => 'Added to Watchlist');
      // act
      final result = await repository.insertWatchlist(testTvSeriesDetail);
      // assert
      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving to database failed',
        () async {
      // arrange
      when(mockTvSeriesLocalDataSource.insertWatchlist(testTvSeriesTable))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // act
      final result = await repository.insertWatchlist(testTvSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove from database success',
        () async {
      // arrange
      when(mockTvSeriesLocalDataSource.removeWatchlist(testTvSeriesTable))
          .thenAnswer((_) async => 'Removed from watchlist');
      // act
      final result = await repository.removeWatchlist(testTvSeriesDetail);
      // assert
      expect(result, Right('Removed from watchlist'));
    });

    test('should return DatabaseFailure when remove from database failed',
        () async {
      // arrange
      when(mockTvSeriesLocalDataSource.removeWatchlist(testTvSeriesTable))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // act
      final result = await repository.removeWatchlist(testTvSeriesDetail);
      // assert
      expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('get watchlist status', () {
    test('should return status whether data is found or not', () async {
      // arrange
      final id = 1;
      when(mockTvSeriesLocalDataSource.getTvSeriesById(id))
          .thenAnswer((_) async => null);
      // act
      final result = await repository.isAddedToWatchlist(id);
      // assert
      expect(result, false);
    });
  });

  group('get watchlist movies', () {
    test('should return list of tv series', () async {
      // arrange
      when(mockTvSeriesLocalDataSource.getWatchlistTvSeries())
          .thenAnswer((_) async => [testTvSeriesTable]);
      // act
      final result = await repository.getWatchlistTvSeries();
      // assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTvSeries]);
    });
  });
}

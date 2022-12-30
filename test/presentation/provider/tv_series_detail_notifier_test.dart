import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/get_tv_series_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_tv_series_watchlist.dart';
import 'package:ditonton/domain/usecases/save_tv_series_watchlist.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'tv_series_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTvSeriesDetail,
  SaveTvSeriesWatchlist,
  RemoveTvSeriesWatchlist,
  GetTvSeriesWatchlistStatus,
  GetTvSeriesRecommendations,
])
void main() {
  late TvSeriesDetailNotifier provider;
  late MockGetTvSeriesDetail mockGetTvSeriesDetail;
  late MockSaveTvSeriesWatchlist mockSaveTvSeriesWatchlist;
  late MockRemoveTvSeriesWatchlist mockRemoveTvSeriesWatchlist;
  late MockGetTvSeriesWatchlistStatus mockGetTvSeriesWatchlistStatus;
  late MockGetTvSeriesRecommendations mockGetTvSeriesRecommendations;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTvSeriesDetail = MockGetTvSeriesDetail();
    mockSaveTvSeriesWatchlist = MockSaveTvSeriesWatchlist();
    mockRemoveTvSeriesWatchlist = MockRemoveTvSeriesWatchlist();
    mockGetTvSeriesWatchlistStatus = MockGetTvSeriesWatchlistStatus();
    mockGetTvSeriesRecommendations = MockGetTvSeriesRecommendations();
    provider = TvSeriesDetailNotifier(
      getTvSeriesDetail: mockGetTvSeriesDetail,
      saveTvSeriesWatchlist: mockSaveTvSeriesWatchlist,
      removeTvSeriesWatchlist: mockRemoveTvSeriesWatchlist,
      getTvSeriesWatchlistStatus: mockGetTvSeriesWatchlistStatus,
      getTvSeriesRecommendations: mockGetTvSeriesRecommendations,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final id = 1;

  final tvSeries = TvSeries(
      backdropPath: "/8Xs20y8gFR0W9u8Yy9NKdpZtSu7.jpg",
      firstAirDate: "2022-01-28",
      genreIds: [1, 2, 3],
      id: id,
      name: "All of Us Are Dead",
      originCountry: ["KR"],
      originalLanguage: "ko",
      originalName: "test",
      overview: "overview",
      popularity: 1,
      posterPath: "/6zUUtzj7aJzOdoxhpiGzEKYtj1o.jpg",
      voteAverage: 1,
      voteCount: 1);

  final tvSeriesList = <TvSeries>[tvSeries];

  group('Get Tv Series Detail', () {
    test('Should get data from usecase', () async {
      // arrange
      when(mockGetTvSeriesDetail.execute(id))
          .thenAnswer((_) async => Right(testTvSeriesDetail));
      // act
      await provider.fetchTvSeriesDetail(id);
      // assert
      verify(mockGetTvSeriesDetail.execute(id));
    });

    test('Should change state to Loading State when usecase is called', () {
      // arrange
      when(mockGetTvSeriesDetail.execute(id))
          .thenAnswer((_) async => Right(testTvSeriesDetail));
      // act
      provider.fetchTvSeriesDetail(id);
      // assert
      expect(provider.tvSeriesState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('Should change state to Loaded when fetch data successful', () async {
      // arrange
      when(mockGetTvSeriesDetail.execute(id))
          .thenAnswer((_) async => Right(testTvSeriesDetail));
      // act
      await provider.fetchTvSeriesDetail(id);
      // assert
      expect(provider.tvSeriesState, RequestState.Loaded);
      expect(provider.tvSeries, testTvSeriesDetail);
      expect(listenerCallCount, 2);
    });

    test('Should return error when fetch data failed', () async {
      // arrange
      when(mockGetTvSeriesDetail.execute(id))
          .thenAnswer((_) async => Left(ServerFailure("Failure")));
      // act
      await provider.fetchTvSeriesDetail(id);
      // assert
      expect(provider.tvSeriesState, RequestState.Error);
      expect(provider.message, "Failure");
      expect(listenerCallCount, 2);
    });
  });

  group('Tv Series Recommendations', () {
    test('Should return Tv Series recommendations from usecase', () async {
      // arrange
      when(mockGetTvSeriesRecommendations.execute(id))
          .thenAnswer((_) async => Right(tvSeriesList));
      // act
      await provider.fetchTvSeriesRecommendations(id);
      // assert
      verify(mockGetTvSeriesRecommendations.execute(id));
    });

    test('Should change state to Loading State when fetch', () {
      // arrange
      when(mockGetTvSeriesRecommendations.execute(id))
          .thenAnswer((_) async => Right(tvSeriesList));
      // act
      provider.fetchTvSeriesRecommendations(id);
      // assert
      expect(provider.tvSeriesRecommendationsState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('Should change State Loaded when fetch successful', () async {
      // arrange
      when(mockGetTvSeriesRecommendations.execute(id))
          .thenAnswer((_) async => Right(tvSeriesList));
      // act
      await provider.fetchTvSeriesRecommendations(id);
      // assert
      expect(provider.tvSeriesRecommendationsState, RequestState.Loaded);
      expect(listenerCallCount, 2);
    });

    test('Should return error when fetch data failed', () async {
      // arrange
      when(mockGetTvSeriesRecommendations.execute(id))
          .thenAnswer((_) async => Left(ServerFailure("Failure")));
      // act
      await provider.fetchTvSeriesRecommendations(id);
      // assert
      expect(provider.tvSeriesRecommendationsState, RequestState.Error);
      expect(provider.message, "Failure");
      expect(listenerCallCount, 2);
    });
  });

  group('Watchlist', () {
    test('Should return watchlist status', () async {
      // arrange
      when(mockGetTvSeriesWatchlistStatus.execute(id))
          .thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistStatus(id);
      // assert
      expect(provider.isAddedToWatchlist, true);
    });

    test(
        'Should execute save watchlist when function called and update watchlist status',
        () async {
      // arrange
      when(mockSaveTvSeriesWatchlist.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Right("Added to Watchlist"));
      when(mockGetTvSeriesWatchlistStatus.execute(id))
          .thenAnswer((_) async => true);
      // act
      await provider.addTvSeriesWatchlist(testTvSeriesDetail);
      // assert
      verify(mockSaveTvSeriesWatchlist.execute(testTvSeriesDetail));
      verify(mockGetTvSeriesWatchlistStatus.execute(id));
      expect(provider.watchlistMessage, "Added to Watchlist");
      expect(listenerCallCount, 1);
    });

    test('Should remove watchlist when function is called and update watchlist',
        () async {
      // arrange
      when(mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Right("Tv Series Removed"));
      when(mockGetTvSeriesWatchlistStatus.execute(id))
          .thenAnswer((_) async => false);
      // act
      await provider.removeTvSeriesFromWatchlist(testTvSeriesDetail);
      // assert
      verify(mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetail));
      verify(mockGetTvSeriesWatchlistStatus.execute(id));
      expect(provider.watchlistMessage, "Tv Series Removed");
    });

    test('Should return database error when save watchlist failed', () async {
      // arrange
      when(mockSaveTvSeriesWatchlist.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Left(DatabaseFailure("Failed")));
      when(mockGetTvSeriesWatchlistStatus.execute(id))
          .thenAnswer((_) async => false);
      // act
      await provider.addTvSeriesWatchlist(testTvSeriesDetail);
      // aseert
      expect(provider.watchlistMessage, "Failed");
      expect(listenerCallCount, 1);
    });

    test('Should return database error when remove watchlist failed', () async {
      // arrange
      when(mockRemoveTvSeriesWatchlist.execute(testTvSeriesDetail))
          .thenAnswer((_) async => Left(DatabaseFailure("Failed")));
      when(mockGetTvSeriesWatchlistStatus.execute(id))
          .thenAnswer((_) async => true);
      // act
      await provider.removeTvSeriesFromWatchlist(testTvSeriesDetail);
      // aseert
      expect(provider.watchlistMessage, "Failed");
    });
  });
}

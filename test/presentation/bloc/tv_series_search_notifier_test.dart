import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_search_notifier_test.mocks.dart';

@GenerateMocks([
  SearchTvSeries,
])
void main() {
  late TvSeriesSearchNotifier provider;
  late MockSearchTvSeries mockSearchTvSeries;
  late int listenerCount;
  setUp(() {
    listenerCount = 0;
    mockSearchTvSeries = MockSearchTvSeries();
    provider = TvSeriesSearchNotifier(searchTvSeries: mockSearchTvSeries)
      ..addListener(() {
        listenerCount += 1;
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
  final query = "All of Us Are Dead";

  group('Search Tv Series', () {
    test('Should change state to Loading State when function called', () async {
      // arrange
      when(mockSearchTvSeries.execute(query))
          .thenAnswer((_) async => Right(tvSeriesList));
      // act
      provider.fetchTvSeriesSearch(query);
      // assert
      expect(provider.state, RequestState.Loading);
      expect(listenerCount, 1);
    });

    test('Should return state Loaded when fetch data is successful', () async {
      // arrange
      when(mockSearchTvSeries.execute(query))
          .thenAnswer((_) async => Right(tvSeriesList));
      // act
      await provider.fetchTvSeriesSearch(query);
      // assert
      expect(provider.state, RequestState.Loaded);
      expect(provider.searchResult, tvSeriesList);
      expect(listenerCount, 2);
    });

    test('Should return Server Failure when fetch data is failed', () async {
      // arrange
      when(mockSearchTvSeries.execute(query))
          .thenAnswer((_) async => Left(ServerFailure("Failure")));
      // act
      await provider.fetchTvSeriesSearch(query);
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, "Failure");
      expect(listenerCount, 2);
    });
  });
}

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:ditonton/presentation/bloc/popular_tv_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tv_series_notifier_test.mocks.dart';

@GenerateMocks([
  GetPopularTvSeries,
])
void main() {
  late PopularTvSeriesNotifier provider;
  late MockGetPopularTvSeries mockGetPopularTvSeries;
  late int listenerCount;

  setUp(() {
    listenerCount = 0;
    mockGetPopularTvSeries = MockGetPopularTvSeries();
    provider =
        PopularTvSeriesNotifier(getPopularTvSeries: mockGetPopularTvSeries)
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

  group('Popular Tv Series', () {
    test('Should return request state empty first', () {
      expect(provider.popularState, RequestState.Empty);
      expect(listenerCount, 0);
    });

    test('Should return data from usecase', () async {
      // arrange
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(tvSeriesList));
      // act
      await provider.fetchPopularTvSeries();
      // assert
      verify(mockGetPopularTvSeries.execute());
    });

    test('Should change state to Loading when function called', () {
      // arrange
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(tvSeriesList));
      // act
      provider.fetchPopularTvSeries();
      // assert
      expect(provider.popularState, RequestState.Loading);
      expect(listenerCount, 1);
    });

    test(
        'Should return popular Tv Series list and Loaded State when function called',
        () async {
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Right(tvSeriesList));
      // act
      await provider.fetchPopularTvSeries();
      // assert
      expect(provider.popularState, RequestState.Loaded);
      expect(provider.popularTvSeries, tvSeriesList);
      expect(listenerCount, 2);
    });

    test('Should return Server Failure and Error State when function called',
        () async {
      when(mockGetPopularTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure("Failure")));
      // act
      await provider.fetchPopularTvSeries();
      // assert
      expect(provider.popularState, RequestState.Error);
      expect(provider.message, "Failure");
      expect(listenerCount, 2);
    });
  });
}

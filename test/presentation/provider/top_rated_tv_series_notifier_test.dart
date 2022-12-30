import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/provider/top_rated_tv_series_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_list_notifier_test.mocks.dart';

@GenerateMocks([
  GetTopRatedTvSeries,
])
void main() {
  late TopRatedTvSeriesNotifier provider;
  late MockGetTopRatedTvSeries mockGetTopRatedTvSeries;
  late int listenerCount;
  setUp(() {
    listenerCount = 0;
    mockGetTopRatedTvSeries = MockGetTopRatedTvSeries();
    provider =
        TopRatedTvSeriesNotifier(getTopRatedTvSeries: mockGetTopRatedTvSeries)
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

  group('Top Rated Tv Series', () {
    test('Should return request state empty first', () {
      expect(provider.topRatedState, RequestState.Empty);
      expect(listenerCount, 0);
    });

    test('Should return data from usecase', () async {
      // arrange
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(tvSeriesList));
      // act
      await provider.fetchTopRatedTvSeries();
      // assert
      verify(mockGetTopRatedTvSeries.execute());
    });

    test('Should change state to Loading when function called', () {
      // arrange
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(tvSeriesList));
      // act
      provider.fetchTopRatedTvSeries();
      // assert
      expect(provider.topRatedState, RequestState.Loading);
      expect(listenerCount, 1);
    });

    test('Should return top rated list and Loaded State when function called',
        () async {
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Right(tvSeriesList));
      // act
      await provider.fetchTopRatedTvSeries();
      // assert
      expect(provider.topRatedState, RequestState.Loaded);
      expect(provider.topRatedTvSeries, tvSeriesList);
      expect(listenerCount, 2);
    });

    test('Should return Server Failure and Error State when function called',
        () async {
      when(mockGetTopRatedTvSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure("Failure")));
      // act
      await provider.fetchTopRatedTvSeries();
      // assert
      expect(provider.topRatedState, RequestState.Error);
      expect(provider.message, "Failure");
      expect(listenerCount, 2);
    });
  });
}

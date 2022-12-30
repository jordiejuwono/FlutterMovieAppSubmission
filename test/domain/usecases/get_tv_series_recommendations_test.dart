import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeriesRecommendations getTvSeriesRecommendations;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    getTvSeriesRecommendations =
        GetTvSeriesRecommendations(tvSeriesRepository: mockTvSeriesRepository);
  });

  int id = 1;
  final tvSeriesList = <TvSeries>[];

  test('should return tv series recommendations list from repository',
      () async {
    // arrange
    when(mockTvSeriesRepository.getTvSeriesRecommendations(id))
        .thenAnswer((_) async => Right(tvSeriesList));
    // act
    final result = await getTvSeriesRecommendations.execute(id);
    // assert
    expect(result, Right(tvSeriesList));
  });
}

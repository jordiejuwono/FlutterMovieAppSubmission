import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTvSeries getPopularTvSeries;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    getPopularTvSeries =
        GetPopularTvSeries(tvSeriesRepository: mockTvSeriesRepository);
  });

  List<TvSeries> popularTvSeries = [];

  test('should return popular tv series list when get from repository',
      () async {
    // arrange
    when(mockTvSeriesRepository.getPopularTvSeries())
        .thenAnswer((_) async => Right(popularTvSeries));
    // act
    final result = await getPopularTvSeries.execute();
    // assert
    expect(result, Right(popularTvSeries));
  });
}

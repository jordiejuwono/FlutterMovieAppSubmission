import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedTvSeries getTopRatedTvSeries;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    getTopRatedTvSeries =
        GetTopRatedTvSeries(tvSeriesRepository: mockTvSeriesRepository);
  });

  List<TvSeries> topRatedTvSeries = [];

  test('should return top rated tv series list when get from repository',
      () async {
    // arrange
    when(mockTvSeriesRepository.getTopRatedTvSeries())
        .thenAnswer((_) async => Right(topRatedTvSeries));
    // act
    final result = await getTopRatedTvSeries.execute();
    // assert
    expect(result, Right(topRatedTvSeries));
  });
}

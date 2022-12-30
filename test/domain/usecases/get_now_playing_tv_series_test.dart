import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetNowPlayingTvSeries getNowPlayingTvSeries;
  late MockTvSeriesRepository mockTvSeriesRepository;

  setUp(() {
    mockTvSeriesRepository = MockTvSeriesRepository();
    getNowPlayingTvSeries =
        GetNowPlayingTvSeries(tvSeriesRepository: mockTvSeriesRepository);
  });

  final tvSeries = <TvSeries>[];

  test('should get list of tv series list from repository', () async {
    // arrange
    when(mockTvSeriesRepository.getNowPlayingTvSeries())
        .thenAnswer((_) async => Right(tvSeries));
    // act
    final result = await getNowPlayingTvSeries.execute();
    // assert
    expect(result, Right(tvSeries));
  });
}

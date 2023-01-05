// import 'dart:convert';

// import 'package:ditonton/common/exception.dart';
// import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart';
// import 'package:ditonton/data/models/tvseries/tv_series_response.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:http/http.dart' as http;
// import '../../helpers/test_helper.mocks.dart';
// import '../../json_reader.dart';

// void main() {
//   const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
//   const BASE_URL = 'https://api.themoviedb.org/3/';

//   late TvSeriesRemoteDataSourceImpl dataSource;
//   late MockHttpClient mockHttpClient;

//   setUp(() {
//     mockHttpClient = MockHttpClient();
//     dataSource = TvSeriesRemoteDataSourceImpl(client: mockHttpClient);
//   });

//   group('get Now Playing Tv Series', () {
//     final tTvSeriesList = TvSeriesResponse.fromJson(
//             json.decode(readJson('dummy_data/tvseries/now_playing.json')))
//         .results;

//     test('should return list of Tv Series when response code is 200', () async {
//       // arrange
//       when(mockHttpClient.get(
//               Uri.parse('${BASE_URL}tv/on_the_air?$API_KEY&language=en-US')))
//           .thenAnswer((_) async => http.Response(
//               readJson('dummy_data/tvseries/now_playing.json'), 200));
//       // act
//       final result = await dataSource.getNowPlayingTvSeries();
//       // assert
//       expect(result, equals(tTvSeriesList));
//     });

//     test('should throw ServerException when the response code is 404',
//         () async {
//       // arrange
//       when(mockHttpClient.get(
//               Uri.parse('${BASE_URL}tv/on_the_air?$API_KEY&language=en-US')))
//           .thenAnswer((_) async => http.Response('Not Found', 404));
//       // act
//       final call = dataSource.getNowPlayingTvSeries();
//       // assert
//       expect(() => call, throwsA(isA<ServerException>()));
//     });
//   });

//   group('get Popular Tv Series', () {
//     final tTvSeriesList = TvSeriesResponse.fromJson(
//             json.decode(readJson('dummy_data/tvseries/popular.json')))
//         .results;

//     test('should return list of Tv Series when response code is 200', () async {
//       // arrange
//       when(mockHttpClient
//               .get(Uri.parse('${BASE_URL}tv/popular?$API_KEY&language=en-US')))
//           .thenAnswer((_) async =>
//               http.Response(readJson('dummy_data/tvseries/popular.json'), 200));
//       // act
//       final result = await dataSource.getPopularTvSeries();
//       // assert
//       expect(result, equals(tTvSeriesList));
//     });

//     test('should throw ServerException when the response code is 404',
//         () async {
//       // arrange
//       when(mockHttpClient
//               .get(Uri.parse('${BASE_URL}tv/popular?$API_KEY&language=en-US')))
//           .thenAnswer((_) async => http.Response('Not Found', 404));
//       // act
//       final call = dataSource.getPopularTvSeries();
//       // assert
//       expect(() => call, throwsA(isA<ServerException>()));
//     });
//   });

//   group('get Top Rated Tv Series', () {
//     final tTvSeriesList = TvSeriesResponse.fromJson(
//             json.decode(readJson('dummy_data/tvseries/top_rated.json')))
//         .results;

//     test('should return list of Tv Series when response code is 200', () async {
//       // arrange
//       when(mockHttpClient.get(
//               Uri.parse('${BASE_URL}tv/top_rated?$API_KEY&language=en-US')))
//           .thenAnswer((_) async => http.Response(
//               readJson('dummy_data/tvseries/top_rated.json'), 200));
//       // act
//       final result = await dataSource.getTopRatedTvSeries();
//       // assert
//       expect(result, equals(tTvSeriesList));
//     });

//     test('should throw ServerException when the response code is 404',
//         () async {
//       // arrange
//       when(mockHttpClient.get(
//               Uri.parse('${BASE_URL}tv/top_rated?$API_KEY&language=en-US')))
//           .thenAnswer((_) async => http.Response('Not Found', 404));
//       // act
//       final call = dataSource.getTopRatedTvSeries();
//       // assert
//       expect(() => call, throwsA(isA<ServerException>()));
//     });
//   });

//   group('tv series recommendations', () {
//     final tvSeriesList = TvSeriesResponse.fromJson(json.decode(
//             readJson('dummy_data/tvseries/tv_series_recommendations.json')))
//         .results;
//     final id = 1;

//     test('should return list of tv series model when response is 200',
//         () async {
//       // arrange
//       when(mockHttpClient.get(Uri.parse(
//               '${BASE_URL}tv/$id/recommendations?$API_KEY&language=en-US&page=1')))
//           .thenAnswer((_) async => http.Response(
//               readJson('dummy_data/tvseries/tv_series_recommendations.json'),
//               200));
//       // act
//       final result = await dataSource.getTvSeriesRecommendations(id);
//       // assert
//       expect(result, equals(tvSeriesList));
//     });

//     test('should throw ServerException when the response code id 404 or other',
//         () {
//       // arrange
//       when(mockHttpClient.get(Uri.parse(
//               '${BASE_URL}tv/$id/recommendations?$API_KEY&language=en-US&page=1')))
//           .thenAnswer((_) async => http.Response('Not Found', 404));
//       // act
//       final call = dataSource.getTvSeriesRecommendations(id);
//       // assert
//       expect(() => call, throwsA(isA<ServerException>()));
//     });
//   });

//   group('search tv series', () {
//     final searchResult = TvSeriesResponse.fromJson(
//             json.decode(readJson('dummy_data/tvseries/search_tv_series.json')))
//         .results;
//     final query = 'All of Us';

//     test('should return list of movies when response code is 200', () async {
//       // arrange
//       when(mockHttpClient.get(Uri.parse(
//               '${BASE_URL}search/tv?$API_KEY&language=en-US&page=1&include_adult=false&query=$query')))
//           .thenAnswer((_) async => http.Response(
//               readJson('dummy_data/tvseries/search_tv_series.json'), 200));
//       // act
//       final result = await dataSource.getSearchedTvSeries(query);
//       // assert
//       expect(result, searchResult);
//     });

//     test('should throw ServerException when response code is other than 200',
//         () async {
//       // arrange
//       when(mockHttpClient.get(Uri.parse(
//               '${BASE_URL}search/tv?$API_KEY&language=en-US&page=1&include_adult=false&query=$query')))
//           .thenAnswer((_) async => http.Response(
//               readJson('dummy_data/tvseries/search_tv_series.json'), 404));
//       // act
//       final call = dataSource.getSearchedTvSeries(query);
//       // assert
//       expect(() => call, throwsA(isA<ServerException>()));
//     });
//   });
// }

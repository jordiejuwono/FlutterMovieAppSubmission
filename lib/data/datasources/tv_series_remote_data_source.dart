import 'dart:convert';
import 'dart:io';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tvseries/tv_series_details.dart';
import 'package:ditonton/data/models/tvseries/tv_series_response.dart';
import 'package:ditonton/data/models/tvseries/tv_series_results.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

abstract class TvSeriesRemoteDataSource {
  Future<List<TvSeriesResults>> getNowPlayingTvSeries();
  Future<List<TvSeriesResults>> getPopularTvSeries();
  Future<List<TvSeriesResults>> getTopRatedTvSeries();
  Future<TvSeriesDetails> getTvSeriesDetails(int seriesId);
  Future<List<TvSeriesResults>> getSearchedTvSeries(String query);
  Future<List<TvSeriesResults>> getTvSeriesRecommendations(int seriesId);
}

class TvSeriesRemoteDataSourceImpl implements TvSeriesRemoteDataSource {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3/';
  final http.Client client;

  TvSeriesRemoteDataSourceImpl({required this.client});

  Future<SecurityContext> get globalContext async {
    final sslCert = await rootBundle.load('certificates/certificates.pem');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    return securityContext;
  }

  @override
  Future<List<TvSeriesResults>> getNowPlayingTvSeries() async {
    HttpClient client = HttpClient(context: await globalContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient ioClient = IOClient(client);
    final response = await ioClient
        .get(Uri.parse('${BASE_URL}tv/on_the_air?$API_KEY&language=en-US'));
    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).results;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesResults>> getPopularTvSeries() async {
    HttpClient client = HttpClient(context: await globalContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient ioClient = IOClient(client);
    final response = await ioClient
        .get(Uri.parse('${BASE_URL}tv/popular?$API_KEY&language=en-US'));
    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).results;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesResults>> getSearchedTvSeries(String query) async {
    HttpClient client = HttpClient(context: await globalContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient ioClient = IOClient(client);
    final response = await ioClient.get(Uri.parse(
        '${BASE_URL}search/tv?$API_KEY&language=en-US&page=1&include_adult=false&query=$query'));
    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).results;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesResults>> getTopRatedTvSeries() async {
    HttpClient client = HttpClient(context: await globalContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient ioClient = IOClient(client);
    final response = await ioClient
        .get(Uri.parse('${BASE_URL}tv/top_rated?$API_KEY&language=en-US'));
    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).results;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvSeriesDetails> getTvSeriesDetails(int seriesId) async {
    HttpClient client = HttpClient(context: await globalContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient ioClient = IOClient(client);
    final response = await ioClient
        .get(Uri.parse('${BASE_URL}tv/$seriesId?$API_KEY&language=en-US'));
    if (response.statusCode == 200) {
      return TvSeriesDetails.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvSeriesResults>> getTvSeriesRecommendations(int seriesId) async {
    HttpClient client = HttpClient(context: await globalContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient ioClient = IOClient(client);
    final response = await ioClient.get(Uri.parse(
        '${BASE_URL}tv/$seriesId/recommendations?$API_KEY&language=en-US&page=1'));
    if (response.statusCode == 200) {
      return TvSeriesResponse.fromJson(json.decode(response.body)).results;
    } else {
      throw ServerException();
    }
  }
}

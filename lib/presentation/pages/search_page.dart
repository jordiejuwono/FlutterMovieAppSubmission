import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/type_helper.dart';
import 'package:ditonton/presentation/bloc/movie_search_notifier.dart';
import 'package:ditonton/presentation/bloc/tv_series_search_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  static const ROUTE_NAME = '/search';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final typeHelper = ModalRoute.of(context)!.settings.arguments as TypeHelper;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          typeHelper == TypeHelper.Movies
              ? 'Search Movies'
              : 'Search TV Series',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                typeHelper == TypeHelper.Movies
                    ? Provider.of<MovieSearchNotifier>(context, listen: false)
                        .fetchMovieSearch(query)
                    : Provider.of<TvSeriesSearchNotifier>(context,
                            listen: false)
                        .fetchTvSeriesSearch(query);
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            typeHelper == TypeHelper.Movies
                ? Consumer<MovieSearchNotifier>(
                    builder: (context, data, child) {
                      if (data.state == RequestState.Loading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (data.state == RequestState.Loaded) {
                        final result = data.searchResult;
                        return Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              final movie = data.searchResult[index];
                              return MovieCard(movie);
                            },
                            itemCount: result.length,
                          ),
                        );
                      } else {
                        return Expanded(
                          child: Container(),
                        );
                      }
                    },
                  )
                : Consumer<TvSeriesSearchNotifier>(
                    builder: (context, data, child) {
                    if (data.state == RequestState.Loading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (data.state == RequestState.Loaded) {
                      final result = data.searchResult;
                      return Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            final tvSeries = data.searchResult[index];
                            return TvSeriesCardList(tvSeries: tvSeries);
                          },
                          itemCount: result.length,
                        ),
                      );
                    } else {
                      return Expanded(
                        child: Container(),
                      );
                    }
                  }),
          ],
        ),
      ),
    );
  }
}

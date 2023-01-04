import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/type_helper.dart';
import 'package:ditonton/presentation/bloc/search_movie/search_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/search_movie/search_movie_event.dart';
import 'package:ditonton/presentation/bloc/search_movie/search_movie_state.dart';
import 'package:ditonton/presentation/bloc/tv_series_search_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                    ? context.read<SearchMovieBloc>().add(
                          SearchMovieFetchEvent(query: query),
                        )
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
                ? BlocBuilder<SearchMovieBloc, SearchMovieState>(
                    builder: (context, state) {
                      if (state.searchMovieState == RequestState.Loading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state.searchMovieState ==
                          RequestState.Loaded) {
                        final result = state.moviesList;
                        return Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemBuilder: (context, index) {
                              final movie = state.moviesList[index];
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

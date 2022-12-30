import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<WatchlistMovieNotifier>(context, listen: false)
          ..fetchWatchlistMovies()
          ..fetchTvSeriesWatchlist());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    Provider.of<WatchlistMovieNotifier>(context, listen: false)
      ..fetchWatchlistMovies()
      ..fetchTvSeriesWatchlist();
  }

  final List<Map> dropDownList = [
    {'id': 0, 'kategori': 'Movies'},
    {'id': 1, 'kategori': 'TV Series'},
  ];
  int dropDownValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            dropDownKategori(),
            SizedBox(
              height: 8.0,
            ),
            Consumer<WatchlistMovieNotifier>(
              builder: (context, data, child) {
                if (data.watchlistState == RequestState.Loading ||
                    data.tvSeriesState == RequestState.Loading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (data.watchlistState == RequestState.Loaded ||
                    data.tvSeriesState == RequestState.Loaded) {
                  return Expanded(
                    child: dropDownValue == 0
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              final movie = data.watchlistMovies[index];
                              return MovieCard(movie);
                            },
                            itemCount: data.watchlistMovies.length,
                          )
                        : ListView.builder(
                            itemBuilder: (context, index) {
                              final tvSeries = data.watchlistTvSeries[index];
                              return TvSeriesCardList(
                                tvSeries: tvSeries,
                              );
                            },
                            itemCount: data.watchlistTvSeries.length,
                          ),
                  );
                } else {
                  return Center(
                    key: Key('error_message'),
                    child: Text(data.message),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  StatefulBuilder dropDownKategori() {
    return StatefulBuilder(
      builder: (context, dropDownState) {
        return InputDecorator(
          decoration: const InputDecoration(border: OutlineInputBorder()),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
                isExpanded: true,
                isDense: true,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
                value: dropDownValue,
                items: dropDownList
                    .map(
                      (data) => DropdownMenuItem(
                        value: data["id"],
                        child: Text(
                          data["kategori"],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (newValue) {
                  dropDownState(() {
                    dropDownValue = newValue as int;
                  });
                }),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}

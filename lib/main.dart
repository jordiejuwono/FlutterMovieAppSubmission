import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/now_playing_tv_series_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv_series_detail_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/bloc/movie_detail_notifier.dart';
import 'package:ditonton/presentation/bloc/movie_search_notifier.dart';
import 'package:ditonton/presentation/bloc/movie_list/movie_list_cubit.dart';
import 'package:ditonton/presentation/bloc/now_playing_tv_series_notifier.dart';
import 'package:ditonton/presentation/bloc/popular_movies_notifier.dart';
import 'package:ditonton/presentation/bloc/popular_tv_series_notifier.dart';
import 'package:ditonton/presentation/bloc/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/bloc/top_rated_tv_series_notifier.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail_notifier.dart';
import 'package:ditonton/presentation/bloc/tv_series_list_notifier.dart';
import 'package:ditonton/presentation/bloc/tv_series_search_notifier.dart';
import 'package:ditonton/presentation/bloc/watchlist_movie_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/injection.dart' as di;

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<MovieListCubit>(),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => di.locator<MovieDetailNotifier>(),
          ),
          ChangeNotifierProvider(
            create: (_) => di.locator<MovieSearchNotifier>(),
          ),
          ChangeNotifierProvider(
            create: (_) => di.locator<TopRatedMoviesNotifier>(),
          ),
          ChangeNotifierProvider(
            create: (_) => di.locator<PopularMoviesNotifier>(),
          ),
          ChangeNotifierProvider(
            create: (_) => di.locator<WatchlistMovieNotifier>(),
          ),
          ChangeNotifierProvider(
            create: (_) => di.locator<TvSeriesListNotifier>(),
          ),
          ChangeNotifierProvider(
            create: (_) => di.locator<TvSeriesSearchNotifier>(),
          ),
          ChangeNotifierProvider(
            create: (_) => di.locator<TvSeriesDetailNotifier>(),
          ),
          ChangeNotifierProvider(
            create: (_) => di.locator<PopularTvSeriesNotifier>(),
          ),
          ChangeNotifierProvider(
            create: (_) => di.locator<TopRatedTvSeriesNotifier>(),
          ),
          ChangeNotifierProvider(
            create: (_) => di.locator<NowPlayingTvSeriesNotifier>(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData.dark().copyWith(
            colorScheme: kColorScheme,
            primaryColor: kRichBlack,
            scaffoldBackgroundColor: kRichBlack,
            textTheme: kTextTheme,
          ),
          home: HomeMoviePage(),
          navigatorObservers: [routeObserver],
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case '/home':
                return MaterialPageRoute(builder: (_) => HomeMoviePage());
              case PopularMoviesPage.ROUTE_NAME:
                return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
              case TopRatedMoviesPage.ROUTE_NAME:
                return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
              case MovieDetailPage.ROUTE_NAME:
                final id = settings.arguments as int;
                return MaterialPageRoute(
                  builder: (_) => MovieDetailPage(id: id),
                  settings: settings,
                );
              case SearchPage.ROUTE_NAME:
                return CupertinoPageRoute(
                  builder: (_) => SearchPage(),
                  settings: settings,
                );
              case WatchlistMoviesPage.ROUTE_NAME:
                return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
              case AboutPage.ROUTE_NAME:
                return MaterialPageRoute(builder: (_) => AboutPage());
              case TvSeriesDetailPage.ROUTE_NAME:
                final id = settings.arguments as int;
                return MaterialPageRoute(
                  builder: (_) => TvSeriesDetailPage(id: id),
                );
              case PopularTvSeriesPage.ROUTE_NAME:
                return MaterialPageRoute(builder: (_) => PopularTvSeriesPage());
              case TopRatedTvSeriesPage.ROUTE_NAME:
                return MaterialPageRoute(
                    builder: (_) => TopRatedTvSeriesPage());
              case NowPlayingTvSeriesPage.ROUTE_NAME:
                return MaterialPageRoute(
                    builder: (_) => NowPlayingTvSeriesPage());
              default:
                return MaterialPageRoute(builder: (_) {
                  return Scaffold(
                    body: Center(
                      child: Text('Page not found :('),
                    ),
                  );
                });
            }
          },
        ),
      ),
    );
  }
}

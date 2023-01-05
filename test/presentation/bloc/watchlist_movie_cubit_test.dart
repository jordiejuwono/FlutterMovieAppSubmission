import 'package:ditonton/domain/usecases/get_tv_series_watchlist.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/watchlist/watchlist_cubit.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([GetWatchlistMovies, GetTvSeriesWatchlist])
void main() {
  late WatchlistCubit bloc;
}

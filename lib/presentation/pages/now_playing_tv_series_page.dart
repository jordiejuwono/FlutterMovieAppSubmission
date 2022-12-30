import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/now_playing_tv_series_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class NowPlayingTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = "/now-playing-tv-series";
  const NowPlayingTvSeriesPage({Key? key}) : super(key: key);

  @override
  State<NowPlayingTvSeriesPage> createState() => _NowPlayingTvSeriesPageState();
}

class _NowPlayingTvSeriesPageState extends State<NowPlayingTvSeriesPage> {
  @override
  void initState() {
    Future.microtask(
      () => Provider.of<NowPlayingTvSeriesNotifier>(context, listen: false)
          .fetchNowPlayingTvSeries(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Now Playing TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<NowPlayingTvSeriesNotifier>(
            builder: (context, value, child) {
          if (value.nowPlayingState == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (value.nowPlayingState == RequestState.Loaded) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final tvSeries = value.nowPlayingTvSeries[index];
                return TvSeriesCardList(tvSeries: tvSeries);
              },
              itemCount: value.nowPlayingTvSeries.length,
            );
          } else {
            return Center(
              key: Key('error_message'),
              child: Text(value.message),
            );
          }
        }),
      ),
    );
  }
}

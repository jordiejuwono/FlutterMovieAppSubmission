import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/popular_tv_series_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopularTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv-series';
  const PopularTvSeriesPage({Key? key}) : super(key: key);

  @override
  State<PopularTvSeriesPage> createState() => _PopularTvSeriesPageState();
}

class _PopularTvSeriesPageState extends State<PopularTvSeriesPage> {
  @override
  void initState() {
    Future.microtask(() =>
        Provider.of<PopularTvSeriesNotifier>(context, listen: false)
            .fetchPopularTvSeries());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            Consumer<PopularTvSeriesNotifier>(builder: (context, value, child) {
          if (value.popularState == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (value.popularState == RequestState.Loaded) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final tvSeries = value.popularTvSeries[index];
                return TvSeriesCardList(tvSeries: tvSeries);
              },
              itemCount: value.popularTvSeries.length,
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

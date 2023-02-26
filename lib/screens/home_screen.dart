import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import 'package:fl_movies_app/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('On Cinemas'),
          actions: [
            IconButton(
                onPressed: () => showSearch(
                    context: context, delegate: MoviesSearchDelegate()),
                icon: const Icon(Icons.search))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //Card swiper
              CardSwiper(
                movies: moviesProvider.onDisplayMovies,
              ),

              //Listado horizontal de peliculas
              MovieSlider(
                title: 'Popular Movies',
                movies: moviesProvider.popularMovies,
                onNextPage: moviesProvider.getPopularMovies,
              )
            ],
          ),
        ));
  }
}

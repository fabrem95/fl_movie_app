import 'package:fl_movies_app/models/models.dart';
import 'package:flutter/material.dart';

class MovieSlider extends StatefulWidget {
  const MovieSlider(
      {super.key, this.title, required this.movies, required this.onNextPage});

  final String? title;
  final List<Movie> movies;
  final Function onNextPage;

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        widget.onNextPage();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height * 0.285,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (widget.title != null)
          Text(
            widget.title!,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        Expanded(
          child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.movies.length,
              itemBuilder: (_, i) {
                final movie = widget.movies[i];
                movie.heroId = 'movie_slider-${movie.id}';

                return _MoviePoster(
                  movie: movie,
                  movieId: movie.heroId!,
                );
              }),
        )
      ]),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  const _MoviePoster({
    super.key,
    required this.movie,
    required this.movieId,
  });

  final Movie movie;
  final String movieId;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 190,
      margin: const EdgeInsets.all(10),
      child: Column(children: [
        GestureDetector(
          onTap: () =>
              Navigator.pushNamed(context, 'movie_details', arguments: movie),
          child: Hero(
            tag: 'movie_slider-${movie.id}',
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: FadeInImage(
                placeholder: const AssetImage('assets/images/no-image.jpg'),
                image: NetworkImage(movie.getFullPosterPath),
                width: 130,
                height: 170,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          movie.title,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        )
      ]),
    );
  }
}

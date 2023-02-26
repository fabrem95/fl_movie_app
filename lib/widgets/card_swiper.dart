import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

import 'package:fl_movies_app/models/models.dart';

class CardSwiper extends StatelessWidget {
  const CardSwiper({super.key, required this.movies});

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        width: double.infinity,
        height: size.height * 0.6,
        child: Swiper(
          itemCount: movies.length,
          layout: SwiperLayout.STACK,
          itemWidth: size.width * 0.6,
          itemHeight: size.height * 0.5,
          itemBuilder: (context, i) {
            final movie = movies[i];
            movie.heroId = 'card_swiper-${movie.id}';

            return GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'movie_details',
                  arguments: movie),
              child: Hero(
                tag: movie.heroId!,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/images/no-image.jpg'),
                    image: NetworkImage(movie.getFullPosterPath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/providers.dart';

class CastingSlider extends StatelessWidget {
  const CastingSlider({super.key, required this.movieId});

  final int movieId;

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;

    return FutureBuilder(
        future: moviesProvider.getMovieCast(movieId),
        builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              margin: const EdgeInsets.only(bottom: 30),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: size.height * 0.26,
              child: const Center(
                child: SizedBox(
                    width: 50, height: 50, child: CircularProgressIndicator()),
              ),
            );
          }

          final cast = snapshot.data!;

          return Container(
              margin: const EdgeInsets.only(bottom: 30),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              height: size.height * 0.26,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: cast.length,
                        itemBuilder: (_, i) => _CastingPoster(actor: cast[i])),
                  )
                ],
              ));
        });
  }
}

class _CastingPoster extends StatelessWidget {
  const _CastingPoster({
    super.key,
    required this.actor,
  });

  final Cast actor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Column(children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: FadeInImage(
            placeholder: const AssetImage('assets/images/no-image.jpg'),
            image: NetworkImage(actor.getFullProfilePath),
            width: 130,
            height: 170,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          actor.name,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        )
      ]),
    );
  }
}

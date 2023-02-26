import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../providers/providers.dart';

class MoviesSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    if (query.isEmpty) {
      return const Center(
          child: Icon(
        Icons.movie_creation,
        color: Colors.black38,
        size: 100,
      ));
    }

    moviesProvider.getSuggestionsByQuery(query);

    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
              child: Icon(
            Icons.movie_creation,
            color: Colors.black38,
            size: 100,
          ));
        }

        final List<Movie> movies = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, int i) {
              final Movie movie = movies[i];
              movie.heroId = 'movie_search-${movie.id}';
              final TextTheme textTheme = Theme.of(context).textTheme;

              return ListTile(
                leading: Hero(
                  tag: movie.heroId!,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage(
                      placeholder:
                          const AssetImage('assets/images/no-image.jpg'),
                      image: NetworkImage(movie.getFullPosterPath),
                      fit: BoxFit.cover,
                      width: 50,
                    ),
                  ),
                ),
                title: Text(movie.title,
                    style: textTheme.bodyLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2),
                subtitle: Text(movie.originalTitle),
                onTap: () => Navigator.pushNamed(context, 'movie_details',
                    arguments: movie),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('BuildReesults');
  }
}

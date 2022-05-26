import 'package:flutter/material.dart';
import 'package:flutter_movie/models/item.dart';
import 'package:flutter_movie/resources/sql_hepler.dart';
import 'package:flutter_movie/ui/movie_detail.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FavoritePageState();
  }
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: SQLHelper.getItems(),
          builder: (context, AsyncSnapshot<List<Item>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            return buildList(snapshot.data!);
          },
        ),
      ),
    );
  }

  Widget buildList(List<Item> results) {
    return GridView.builder(
      itemCount: results.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GridTile(
          child: InkResponse(
            enableFeedback: true,
            child: Image.network(
              'https://image.tmdb.org/t/p/w185${results[index].posterPath}',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Expanded(
                child: Container(
                  color: Colors.black12,
                ),
              ),
            ),
            onTap: () => openDetailPage(results[index]),
          ),
        );
      },
    );
  }

  openDetailPage(Item movie) {
    final page = MovieDetail(
      title: movie.title ?? '',
      posterUrl: movie.posterPath ?? '',
      backdropUrl: movie.backdropPath ?? '',
      description: movie.overview ?? '',
      releaseDate: movie.releaseDate ?? '',
      voteAverage: movie.voteAverage?.toString() ?? '',
      movieId: movie.id ?? 0,
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return page;
      }),
    ).then((value) {
      setState(() {});
    });
  }
}

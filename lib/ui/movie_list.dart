import 'package:flutter/material.dart';
import 'package:flutter_movie/models/movie.dart';
import 'package:flutter_movie/models/response_movies.dart';
import 'package:flutter_movie/resources/movie_api_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_movie/ui/movie_detail.dart';

class MovieList extends StatefulWidget {
  const MovieList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MovieListState();
  }
}

class _MovieListState extends State<MovieList> {
  final movieApiProvider = MovieApiProvider(Dio());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Popular"),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future:
              movieApiProvider.getMovieList('74c117ba95e20ba9d103ea81588c6880'),
          builder: (context, AsyncSnapshot<ResponseMovies> snapshot) {
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

  Widget buildList(ResponseMovies data) {
    final results = data.results ?? [];
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

  openDetailPage(Movie movie) {
    final page = MovieDetail(
      title: movie.title ?? '',
      posterUrl: movie.backdropPath ?? '',
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
    );
  }
}

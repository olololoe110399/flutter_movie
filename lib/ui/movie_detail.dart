import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_movie/models/response_trailers.dart';
import 'package:flutter_movie/models/trailer.dart';
import 'package:flutter_movie/resources/movie_api_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_movie/resources/sql_hepler.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetail extends StatefulWidget {
  final String posterUrl;
  final String backdropUrl;
  final String description;
  final String releaseDate;
  final String title;
  final String voteAverage;
  final int movieId;

  const MovieDetail({
    Key? key,
    required this.posterUrl,
    required this.backdropUrl,
    required this.description,
    required this.releaseDate,
    required this.title,
    required this.voteAverage,
    required this.movieId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => MovieDetailState();
}

class MovieDetailState extends State<MovieDetail> {
  final movieApiProvider = MovieApiProvider(Dio());

  bool isFavorite = false;

  toggleFavorite() async {
    final item = await SQLHelper.getItem(widget.movieId);
    if (item == null) {
      await SQLHelper.createItem(
        movieId: widget.movieId,
        title: widget.title,
        posterPath: widget.posterUrl,
        backdropPath: widget.backdropUrl,
        description: widget.description,
        releaseDate: widget.releaseDate,
        voteAverage: widget.voteAverage,
      );
    } else {
      await SQLHelper.deleteItem(widget.movieId);
    }
    _updateFavorite(widget.movieId);
  }

  _updateFavorite(int id) async {
    await SQLHelper.getItem(id).then((value) {
      if (value != null) {
        setState(() {
          isFavorite = true;
        });
      } else {
        setState(() {
          isFavorite = false;
        });
      }
    }).catchError((err) {
      setState(() {
        isFavorite = false;
      });
    });
  }

  @override
  void initState() {
    _updateFavorite(widget.movieId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                elevation: 0.0,
                title: Text(widget.title),
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    "https://image.tmdb.org/t/p/w500${widget.posterUrl}",
                    fit: BoxFit.cover,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () => toggleFavorite(),
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                    ),
                  ),
                ],
              ),
            ];
          },
          body: ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(10.0),
            shrinkWrap: true,
            children: <Widget>[
              const SizedBox(
                height: 5,
              ),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Text(
                    widget.voteAverage,
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    widget.releaseDate,
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Text(widget.description),
              const SizedBox(
                height: 16,
              ),
              const Text(
                "Trailer",
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              FutureBuilder(
                future: movieApiProvider.getTrailerByMovieId(
                    widget.movieId, '74c117ba95e20ba9d103ea81588c6880'),
                builder:
                    (context, AsyncSnapshot<ResponseTrailers> itemSnapShot) {
                  if ((itemSnapShot.hasError) || (!itemSnapShot.hasData)) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (itemSnapShot.hasError) {
                    return Text(itemSnapShot.error.toString());
                  }
                  final results = itemSnapShot.data!.results ?? [];
                  if (results.isNotEmpty) {
                    return buildTrailerList(results);
                  } else {
                    return noTrailer();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget noTrailer() {
    return const Center(
      child: Text("No trailer available"),
    );
  }

  Widget buildTrailerList(List<Trailer> results) {
    return SizedBox(
      height: 420,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: results.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemBuilder: (BuildContext context, int index) =>
            trailerItem(results[index]),
      ),
    );
  }

  _launchURL(String key) async {
    final url = Uri.parse("http://www.youtube.com/watch?v=$key");
    if (Platform.isIOS) {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } else {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    }
  }

  Widget trailerItem(Trailer trailer) {
    return GestureDetector(
      onTap: () => _launchURL(trailer.key ?? ''),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                "https://img.youtube.com/vi/${trailer.key}/maxresdefault.jpg",
                fit: BoxFit.cover,
                height: 100,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 100,
                  color: Colors.grey,
                ),
              ),
              const Center(
                child: Icon(Icons.play_circle_filled),
              ),
            ],
          ),
          Text(
            trailer.name ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter_movie/models/response_movies.dart';
import 'package:flutter_movie/models/response_trailers.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'movie_api_provider.g.dart';

@RestApi(baseUrl: 'https://api.themoviedb.org/3/')
abstract class MovieApiProvider {
  factory MovieApiProvider(Dio dio, {String baseUrl}) = _MovieApiProvider;

  @GET("/movie/popular")
  Future<ResponseMovies> getMovieList(
    @Query("api_key") String apiKey,
  );

  @GET("/movie/{id}/videos")
  Future<ResponseTrailers> getTrailerByMovieId(
    @Path("id") int id,
    @Query("api_key") String apiKey,
  );
}

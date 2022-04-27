import 'package:flutter_movie/models/trailer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_trailers.g.dart';

@JsonSerializable()
class ResponseTrailers {
  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'results')
  List<Trailer>? results;

  ResponseTrailers({
    this.id,
    this.results,
  });

  factory ResponseTrailers.fromJson(Map<String, dynamic> json) =>
      _$ResponseTrailersFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseTrailersToJson(this);

  @override
  String toString() => 'ResponseTrailer(id: $id, results: $results)';
}

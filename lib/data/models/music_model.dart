// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

/// Represents a music track with its details.
class Music {
  /// The unique identifier for the music track.
  final int id;

  /// The title of the music track.
  final String title;

  /// The artist of the music track.
  final String artist;

  /// The path to the music file.
  final String path;

  /// Creates a new instance of the `Music` class.
  Music({
    required this.id,
    required this.title,
    required this.artist,
    required this.path,
  });

  /// Creates a copy of the `Music` object with optional modifications.
  Music copyWith({
    int? id,
    String? title,
    String? artist,
    String? path,
  }) {
    return Music(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      path: path ?? this.path,
    );
  }

  /// Converts the `Music` object to a map.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'artist': artist,
      'path': path,
    };
  }

  /// Creates a `Music` object from a map.
  factory Music.fromMap(Map<String, dynamic> map) {
    return Music(
      id: map['id'] as int,
      title: map['title'] as String,
      artist: map['artist'] as String,
      path: map['path'] as String,
    );
  }

  /// Converts the `Music` object to a JSON string.
  String toJson() => json.encode(toMap());

  /// Creates a `Music` object from a JSON string.
  factory Music.fromJson(String source) =>
      Music.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Returns a string representation of the `Music` object.
  @override
  String toString() {
    return 'Music(id: $id, title: $title, artist: $artist, path: $path)';
  }

  /// Checks if two `Music` objects are equal.
  @override
  bool operator ==(covariant Music other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.artist == artist &&
        other.path == path;
  }

  /// Returns the hash code for the `Music` object.
  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ artist.hashCode ^ path.hashCode;
  }
}

/// Generates a URL for accessing a music file on Google Drive.
///
/// This function takes a file ID as input and returns a URL that can be used
/// to access the corresponding music file.
String getUrlAddress(String fileID) {
  String apiKey = 'AIzaSyCAtbRmPnOklzrDRYZe4LBemLzNTjx80pI&v';
  return 'https://www.googleapis.com/drive/v3/files/$fileID?alt=media&key=$apiKey=.mp3';
}

/// A list of `Music` objects representing the available music tracks.
final musicList = <Music>[
  Music(
    id: 0,
    title: ' Sunset Ride',
    artist: 'APO ザ·犬 。',
    path: getUrlAddress('1JSEdASD4FWss2ZbimDQJ7pNBUEl2I9Qw'),
  ),
  Music(
    id: 1,
    title: 'Dream (Girl)',
    artist: 'Slike',
    path: getUrlAddress('1p-4VHzdaqw7goMQ2Gh8hKcTrKoA8e4r8'),
  ),
  Music(
    id: 2,
    title: 'Gucci Louis - Rap Beat 2',
    artist: 'Ladyfingers',
    path: getUrlAddress('15b--mu6aI1j-kWsCuWWHJjG6uNW0c4cS'),
  ),
];

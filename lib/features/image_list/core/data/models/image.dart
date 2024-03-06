import 'dart:io';

class Image {
  final String? id;
  final String name;
  final File? image;
  final String timestamp;
  final String url;

  Image({
    required this.name,
    required this.timestamp,
    required this.url,
    this.id,
    this.image,
  });

  factory Image.fromJson(dynamic json) {
    return Image(
      id: json['id'],
      name: json['name'],
      timestamp: json['timestamp'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'timestamp': timestamp,
      'url': url,
    };
  }
}

import '/exports/entities.dart';

class Article extends Comparable {
  static final Map<String, Article> _shelf = {};

  final String title;
  final String content;
  final String thumbnail;
  final bool primary;

  const Article._(
    super.id, {
    required this.title,
    required this.content,
    required this.primary,
    required this.thumbnail,
  });

  factory Article.fromJson(String id, Map<String, dynamic> fields) {
    return _shelf.putIfAbsent(id, () {
      return Article._(
        id,
        title: fields['title'],
        content: fields['content'],
        primary: fields['primary'],
        thumbnail: fields['thumbnail'] ?? 'https://y.qq.com/music/photo_new/T002R300x300M000002Ptet12aGZr5_1.jpg?max_age=2592000',
      );
    });
  }

  Map<String, dynamic> toJson() {
    return {
      id: {
        'title': title,
        'content': content,
        'primary': primary,
        'thumbnail': thumbnail,
      },
    };
  }

  String get source => 'http://timbus.vn/article.aspx?id=$id';
}

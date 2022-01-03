class Genre {
  final int id;
  final String name;

  const Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  static List<Genre> listToGenres(List jsonList) {
    return jsonList.map((e) => Genre.fromJson(e)).toList();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Genre && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

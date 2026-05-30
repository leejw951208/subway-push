class Station {
  const Station(this.name, this.lines, this.description);

  final String name;
  final List<String> lines;
  final String description;

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      json['name'] as String,
      (json['lines'] as List<dynamic>).cast<String>(),
      json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lines': lines,
      'description': description,
    };
  }
}

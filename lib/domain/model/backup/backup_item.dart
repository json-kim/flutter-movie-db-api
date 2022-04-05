class BackupItem {
  final String id;
  final String path;
  final DateTime uploadDate;

  BackupItem({
    required this.id,
    required this.path,
    required this.uploadDate,
  });

  factory BackupItem.fromJson(Map<String, dynamic> json) {
    return BackupItem(
      id: json['id'],
      path: json['path'],
      uploadDate: DateTime.parse(json['uploadDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'uploadDate': uploadDate.toIso8601String(),
    };
  }
}

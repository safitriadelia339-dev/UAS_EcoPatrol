class ReportModel {
  final String id;
  final String title;
  final String description;
  final String imagePath;
  final double latitude;
  final double longitude;
  final String status; // pending | done
  final DateTime createdAt;

  ReportModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
  });

  // Untuk menyimpan ke SQLite
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imagePath': imagePath,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      // Simpan sebagai string ISO 8601
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Untuk mengambil dari SQLite
  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      imagePath: json['imagePath'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      status: json['status'] as String,
      // Konversi kembali dari string
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

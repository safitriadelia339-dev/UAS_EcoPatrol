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
}

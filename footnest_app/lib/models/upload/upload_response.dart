class UploadResponse {

  final String logoPath;

  UploadResponse({
    required this.logoPath,
  });

  factory UploadResponse.fromJson(Map<String, dynamic> json) {
    return UploadResponse(
      logoPath: json['logoPath'],
    );
  }
}
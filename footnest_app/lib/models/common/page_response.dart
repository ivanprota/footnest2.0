class PageResponse<T> {

  final List<T> content;

  final int page;

  final int totalPages;

  final int totalElements;

  PageResponse({
    required this.content,
    required this.page,
    required this.totalPages,
    required this.totalElements,
  });

  factory PageResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return PageResponse(
      content: (json["content"] as List)
          .map((e) => fromJson(e))
          .toList(),

      page: json["page"],

      totalPages: json["totalPages"],

      totalElements: json["totalElements"],
    );
  }

}
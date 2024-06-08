class Review {
  final String reviewedBy;
  final String reviews;
  final int ratings;

  Review({
    required this.reviewedBy,
    required this.reviews,
    required this.ratings,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewedBy: json['reviewed_by'],
      reviews: json['reviews'],
      ratings: json['ratings'],
    );
  }
}

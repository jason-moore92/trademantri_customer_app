import "package:equatable/equatable.dart";

class FeedbackModel extends Equatable {
  String? id;
  String? userId;
  double? ratingValue;
  String? feedbackText;

  FeedbackModel({
    this.id,
    this.userId = "",
    this.ratingValue = 0.0,
    this.feedbackText = "",
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> map) {
    return FeedbackModel(
      id: map["_id"] ?? null,
      userId: map["userId"] ?? "",
      ratingValue: map["ratingValue"].toDouble() ?? 0.0,
      feedbackText: map["feedbackText"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id ?? null,
      "userId": userId ?? "",
      "ratingValue": ratingValue!.toDouble(),
      "feedbackText": feedbackText ?? "",
    };
  }

  factory FeedbackModel.copy(FeedbackModel feedbackModel) {
    return FeedbackModel(
      id: feedbackModel.id,
      userId: feedbackModel.userId,
      ratingValue: feedbackModel.ratingValue,
      feedbackText: feedbackModel.feedbackText,
    );
  }

  @override
  List<Object> get props => [
        id ?? Object(),
        userId!,
        ratingValue!,
        feedbackText!,
      ];

  @override
  bool get stringify => true;
}

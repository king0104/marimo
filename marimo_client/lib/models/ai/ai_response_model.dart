class AIResponseModel {
  final List<String> meaningList;
  final List<String> actionList;

  AIResponseModel({required this.meaningList, required this.actionList});

  factory AIResponseModel.fromJson(Map<String, dynamic> json) {
    return AIResponseModel(
      meaningList: List<String>.from(json['meaningList'] ?? []),
      actionList: List<String>.from(json['actionList'] ?? []),
    );
  }
}

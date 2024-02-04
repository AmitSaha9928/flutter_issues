// Represents a GitHub issue model with relevant information
class IssueModel {
  final String title;
  final String body;
  final List<String> labels;
  final String createdAt;
  final String userLogin;

  // Constructor for creating an instance of IssueModel
  IssueModel({
    required this.title,
    required this.body,
    required this.labels,
    required this.createdAt,
    required this.userLogin,
  });

  // Factory method to create an instance of IssueModel from JSON
  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      title: json['title'] ?? 'No Title',
      body: json['body'] ?? 'No Body',
      labels: _getLabels(json['labels'] ?? []),
      createdAt: json['created_at'] ?? 'Unknown',
      userLogin: json['user']['login'] ?? 'Unknown',
    );
  }

  // Private method to extract labels from JSON
  static List<String> _getLabels(List<dynamic> labels) {
    return labels.map<String>((label) => label['name'].toString()).toList();
  }
}

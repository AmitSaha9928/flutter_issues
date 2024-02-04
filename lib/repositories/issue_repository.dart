import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/issue_model.dart';

// Repository for fetching and searching GitHub issues
class IssueRepository {
  // Fetches a list of GitHub issues for the specified page
  Future<List<IssueModel>> fetchIssues(int page) async {
    final response = await http.get(
      Uri.parse(
          'https://api.github.com/repos/flutter/flutter/issues?page=$page'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> issues = json.decode(response.body);
      return issues.map((json) => IssueModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load issues');
    }
  }

  // Searches for GitHub issues based on specified labels
  Future<List<IssueModel>> searchIssues(List<String> labels) async {
    final labelsQuery = labels.join(',');
    final response = await http.get(
      Uri.parse(
          'https://api.github.com/repos/flutter/flutter/issues?labels=$labelsQuery'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> issues = json.decode(response.body);
      return issues.map((json) => IssueModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search issues');
    }
  }
}

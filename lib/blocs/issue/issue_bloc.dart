import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../models/issue_model.dart';

// Define events that can be triggered
abstract class IssueEvent {}

class FetchIssues extends IssueEvent {}

class FetchMoreIssues extends IssueEvent {}

class SearchIssues extends IssueEvent {
  final List<String> labels;

  SearchIssues(this.labels);
}

// Define the different states of the issue
class IssueState {
  final bool fetchingMore;

  IssueState({required this.fetchingMore});
}

class IssueInitial extends IssueState {
  IssueInitial() : super(fetchingMore: false);
}

class IssueLoading extends IssueState {
  final List<IssueModel> issues;

  IssueLoading(this.issues, {required bool fetchingMore})
      : super(fetchingMore: fetchingMore);
}

class IssueLoaded extends IssueState {
  final List<IssueModel> issues;
  final int currentPage;
  final bool hasMoreIssues;

  IssueLoaded(this.issues, this.currentPage, this.hasMoreIssues,
      {required bool fetchingMore})
      : super(fetchingMore: fetchingMore);
}

class IssueError extends IssueState {
  final String error;

  IssueError(this.error, {required bool fetchingMore})
      : super(fetchingMore: fetchingMore);
}

// Define the business logic using the Bloc pattern
class IssueBloc extends Bloc<IssueEvent, IssueState> {
  IssueBloc() : super(IssueInitial()) {
    on<FetchIssues>(_onFetchIssues);
    on<FetchMoreIssues>(_onFetchMoreIssues);
    on<SearchIssues>(_onSearchIssues);
  }

  void _onFetchIssues(FetchIssues event, Emitter<IssueState> emit) async {
    emit(IssueLoading([], fetchingMore: true));
    try {
      final issues = await _fetchIssues(1);
      emit(IssueLoaded(issues, 1, true, fetchingMore: false));
    } catch (error) {
      emit(IssueError('Failed to load issues: $error', fetchingMore: false));
    }
  }

  void _onFetchMoreIssues(
      FetchMoreIssues event, Emitter<IssueState> emit) async {
    if (state is IssueLoaded) {
      final currentPage = (state as IssueLoaded).currentPage;
      try {
        final issues = await _fetchIssues(currentPage + 1);
        emit(IssueLoaded(
          (state as IssueLoaded).issues + issues,
          currentPage + 1,
          issues.isNotEmpty,
          fetchingMore: false,
        ));
      } catch (error) {
        emit(IssueError('Failed to load more issues: $error',
            fetchingMore: false));
      }
    }
  }

  void _onSearchIssues(SearchIssues event, Emitter<IssueState> emit) async {
    emit(IssueLoading([], fetchingMore: true));
    try {
      final issues = await _searchIssues(event.labels);
      emit(IssueLoaded(issues, 1, true, fetchingMore: false));
    } catch (error) {
      emit(IssueError('Failed to search issues: $error', fetchingMore: false));
    }
  }

  Future<List<IssueModel>> _fetchIssues(int page) async {
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

  Future<List<IssueModel>> _searchIssues(List<String> labels) async {
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

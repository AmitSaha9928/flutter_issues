import '../../models/issue_model.dart';

// Represents the state of the GitHub issues in the application
class IssueState {
  final bool fetchingMore;

  // Constructor for the base state class
  IssueState({required this.fetchingMore});
}

// Represents the initial state where no issues are loaded
class IssueInitial extends IssueState {
  IssueInitial() : super(fetchingMore: false);
}

// Represents the state when issues are being fetched or loaded
class IssueLoading extends IssueState {
  final List<IssueModel> issues;

  // Constructor for the loading state
  IssueLoading(this.issues, {required bool fetchingMore})
      : super(fetchingMore: fetchingMore);
}

// Represents the state when issues are successfully loaded
class IssueLoaded extends IssueState {
  final List<IssueModel> issues;
  final int currentPage;
  final bool hasMoreIssues;

  // Constructor for the loaded state
  IssueLoaded(this.issues, this.currentPage, this.hasMoreIssues,
      {required bool fetchingMore})
      : super(fetchingMore: fetchingMore);
}

// Represents the state when there's an error loading issues
class IssueError extends IssueState {
  final String error;

  // Constructor for the error state
  IssueError(this.error, {required bool fetchingMore})
      : super(fetchingMore: fetchingMore);
}

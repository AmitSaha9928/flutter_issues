// Define abstract class for events related to the GitHub issues
abstract class IssueEvent {}

// Event to trigger fetching the initial set of issues
class FetchIssues extends IssueEvent {}

// Event to trigger fetching more issues (pagination)
class FetchMoreIssues extends IssueEvent {}

// Event to trigger searching for issues based on labels
class SearchIssues extends IssueEvent {
  final List<String> labels;

  SearchIssues(this.labels);
}

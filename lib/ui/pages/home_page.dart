import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../blocs/issue/issue_bloc.dart';
import '../../models/issue_model.dart';
import '../widgets/issue_card.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Bloc and controllers initialization
  late IssueBloc issueBloc;
  late ScrollController _scrollController;
  late TextEditingController _searchController;
  List<String> enteredLabels = [];

  @override
  void initState() {
    super.initState();

    // Initialize the Bloc and fetch the initial set of issues
    issueBloc = context.read<IssueBloc>();
    issueBloc.add(FetchIssues());

    // Initialize the scroll controller and set up the scroll listener
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    // Initialize the search controller
    _searchController = TextEditingController();
  }

  // Scroll listener to fetch more issues when reaching the bottom
  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        !issueBloc.state.fetchingMore) {
      issueBloc.add(FetchMoreIssues());
    }
  }

  // Perform a search based on entered labels
  void _performSearch() {
    final labels = enteredLabels;
    issueBloc.add(SearchIssues(labels));
  }

  // Clear a label and update the search
  void _clearLabel(String label) {
    setState(() {
      enteredLabels.remove(label);
    });
    _performSearch(); // Update the search when a label is cleared
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Flutter GitHub Issues',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Search bar with label input
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search by label',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        enteredLabels.add(value.trim());
                        _searchController.clear();
                      });
                    }
                    _performSearch();
                  },
                ),
              ),
            ),
            // Display entered labels as chips
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: enteredLabels.map((label) {
                  return Chip(
                    label: Text(label),
                    onDeleted: () => _clearLabel(label),
                  );
                }).toList(),
              ),
            ),
            // Display the list of GitHub issues
            Expanded(
              child: BlocBuilder<IssueBloc, IssueState>(
                builder: (context, state) {
                  return _buildBody(context, state, issueBloc);
                },
              ),
            ),
          ],
        ),
        // Floating action button to manually trigger fetching issues
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            issueBloc.add(FetchIssues());
          },
          tooltip: 'Fetch Issues',
          child: BlocBuilder<IssueBloc, IssueState>(
            builder: (context, state) {
              return state is IssueLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Icon(Icons.refresh);
            },
          ),
        ),
      ),
    );
  }

  // Build the appropriate UI based on the current state
  Widget _buildBody(
      BuildContext context, IssueState state, IssueBloc? issueBloc) {
    if (state is IssueLoading) {
      return _buildLoading();
    } else if (state is IssueLoaded) {
      return _buildIssueList(context, state.issues, state.fetchingMore);
    } else if (state is IssueError) {
      return _buildError(context, state.error, issueBloc);
    } else {
      return Container(); // Placeholder for unexpected states
    }
  }

  // Loading indicator
  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  // Display the list of GitHub issues
  Widget _buildIssueList(
      BuildContext context, List<IssueModel> issues, bool fetchingMore) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: issues.length + (fetchingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < issues.length) {
          final issue = issues[index];
          return IssueCard(issue: issue);
        } else {
          if (fetchingMore) {
            return _buildLoadingIndicator();
          } else {
            return Container(); // Placeholder
          }
        }
      },
    );
  }

  // Display a single GitHub issue card
  Widget _buildIssueCard(BuildContext context, IssueModel issue) {
    String createdAt = issue.createdAt;
    DateTime createdDate = DateTime.parse(createdAt);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 5,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10), // Add padding within the card
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Issue title
                    Text(
                      issue.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Issue body (limited to 3 lines)
                    Text(
                      issue.body,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Issue labels
                    Text(
                      'Labels: ${issue.labels}',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Display issue creation date and user login
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_formatDate(createdDate)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${issue.userLogin}',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Format a DateTime object to display only the date part
  String _formatDate(DateTime date) {
    return DateFormat.yMd().format(date);
  }

  // Loading indicator for when more issues are being fetched
  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  // Display an error message and retry button
  Widget _buildError(BuildContext context, String error, IssueBloc? issueBloc) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Error: $error'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            context.read<IssueBloc>().add(FetchIssues());
          },
          child: const Text('Retry'),
        ),
      ],
    );
  }

  // Concatenate labels into a comma-separated string
  String _getLabels(List<String> labels) {
    return labels.join(', ');
  }
}

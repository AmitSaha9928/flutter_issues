import 'package:flutter/material.dart';
import '../../models/issue_model.dart';
import '../../utils/date_formatter.dart';

class IssueCard extends StatelessWidget {
  final IssueModel issue;

  const IssueCard({Key? key, required this.issue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 5,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display the title of the GitHub issue
                    Text(
                      issue.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Display the body of the GitHub issue with a maximum of 3 lines
                    Text(
                      issue.body,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Display the labels of the GitHub issue
                    Text(
                      'Labels: ${issue.labels.join(', ')}',
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Display the creation date and user login of the GitHub issue
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Format and display the creation date
                  Text(
                    _formatDate(issue.createdAt),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Display the user login associated with the GitHub issue
                  Text(
                    issue.userLogin,
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

  // Format a date string using the DateFormatter utility
  String _formatDate(String createdAt) {
    return DateFormatter.formatDate(createdAt);
  }
}

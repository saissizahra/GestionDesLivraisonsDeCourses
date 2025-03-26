import 'package:flutter/material.dart';

class FAQSearchDelegate extends SearchDelegate {
  final List<Map<String, String>> faqs;

  FAQSearchDelegate(this.faqs);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchContent();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchContent();
  }

  Widget _buildSearchContent() {
    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Search for questions or answers',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    final results = faqs.where((faq) =>
        faq['question']!.toLowerCase().contains(query.toLowerCase()) ||
        faq['answer']!.toLowerCase().contains(query.toLowerCase())).toList();

    if (results.isEmpty) {
      return Center(
        child: Text(
          'No results found for "$query"',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]['question']!),
          subtitle: Text(results[index]['answer']!),
          onTap: () {
            close(context, results[index]);
          },
        );
      },
    );
  }
}
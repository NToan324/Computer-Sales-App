import 'package:computer_sales_app/config/color.dart';
import 'package:flutter/material.dart';

class ProductComment extends StatefulWidget {
  const ProductComment({super.key});

  @override
  State<ProductComment> createState() => _ProductCommentState();
}

class _ProductCommentState extends State<ProductComment> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, String>> _comments = [];

  static const int commentsPerPage = 3;
  int _currentPage = 0;

  void _addComment() {
    final name = _nameController.text.trim();
    final comment = _commentController.text.trim();

    if (name.isEmpty || comment.isEmpty) return;

    setState(() {
      _comments.insert(0, {
        'name': name,
        'comment': comment,
      });
      _nameController.clear();
      _commentController.clear();
      _currentPage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (_comments.length / commentsPerPage).ceil();
    final start = _currentPage * commentsPerPage;
    final end = (_currentPage + 1) * commentsPerPage;
    final visibleComments = _comments.sublist(
      start,
      end > _comments.length ? _comments.length : end,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          'Comments',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          controller: _commentController,
          cursorColor: Colors.black,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Enter your comment',
            labelStyle: const TextStyle(
              color: Colors.grey,
            ),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          cursorColor: Colors.black,
          decoration: InputDecoration(
            labelText: 'Your name',
            border: OutlineInputBorder(),
            labelStyle: const TextStyle(
              color: Colors.grey,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: _addComment,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Send',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  )),
            ),
          ),
        ),
        ...visibleComments.map((comment) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment['name'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(comment['comment'] ?? ''),
                  ],
                ),
              ),
            )),

        // Phân trang
        if (_comments.length > commentsPerPage)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _currentPage > 0
                    ? () => setState(() => _currentPage--)
                    : null,
                icon: const Icon(Icons.arrow_back_ios_new_outlined),
              ),
              ...List.generate(totalPages, (index) {
                final isActive = index == _currentPage;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ElevatedButton(
                    onPressed: () => setState(() => _currentPage = index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isActive ? AppColors.primary : Colors.grey[300],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      minimumSize: Size(0, 36),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }),
              IconButton(
                onPressed: _currentPage < totalPages - 1
                    ? () => setState(() => _currentPage++)
                    : null,
                icon: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
      ],
    );
  }
}

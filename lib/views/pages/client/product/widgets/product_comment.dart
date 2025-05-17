import 'package:computer_sales_app/components/custom/pagination.dart';
import 'package:computer_sales_app/components/custom/skeleton.dart';
import 'package:computer_sales_app/components/custom/snackbar.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/models/review.model.dart.dart';
import 'package:computer_sales_app/services/socket_io_client.dart';
import 'package:computer_sales_app/views/pages/client/login/widgets/button.dart';
import 'package:flutter/material.dart';

class ProductComment extends StatefulWidget {
  const ProductComment({
    super.key,
    required this.socketService,
    required this.productId,
    required this.comments,
    this.isLoading = false,
  });

  final SocketService socketService;
  final String productId;
  final List<ReviewModel> comments;
  final bool isLoading;

  @override
  State<ProductComment> createState() => _ProductCommentState();
}

class _ProductCommentState extends State<ProductComment> {
  final TextEditingController _commentController = TextEditingController();
  bool isSending = false;
  int currentPage = 1;
  int totalPage = 1;
  int limit = 10;

  void _addComment() {
    setState(() {
      isSending = true;
    });
    final comment = _commentController.text.trim();
    if (comment.isEmpty) {
      showCustomSnackBar(context, 'Please enter a comment');
      setState(() {
        isSending = false;
      });
      return;
    }

    try {
      widget.socketService.sendReview(
        productVariantId: widget.productId,
        review: _commentController.text,
        onError: (err) {
          showCustomSnackBar(
            context,
            'Failed to add comment',
          );
        },
      );

      setState(() {
        _commentController.clear();
      });
    } catch (e) {
      showCustomSnackBar(context, 'Failed to add comment. Please try again.');
    }
    setState(() {
      isSending = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // _initSocketAndLoadComments();
  }

  @override
  void dispose() {
    widget.socketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalPage =
        widget.comments.length > 10 ? (widget.comments.length / 10).ceil() : 1;

    final commentPagination =
        widget.comments.skip((currentPage - 1) * limit).take(limit).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comments',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        TextField(
          cursorColor: Colors.black,
          controller: _commentController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'Leave a comment',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
        SizedBox(height: 12),
        MyButton(
          text: 'Send',
          isLoading: isSending,
          onTap: (_) {
            _addComment();
          },
        ),
        const SizedBox(height: 12),
        widget.isLoading
            ? ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 10,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) => SkeletonHorizontalProduct(),
              )
            : commentPagination.isEmpty
                ? const Center(
                    child: Text('No comments yet'),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: commentPagination.length >= 10
                        ? 10
                        : commentPagination.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final comment = commentPagination[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          tileColor: Colors.grey[100],
                          leading: const CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.black12,
                            child: Icon(Icons.person, color: Colors.black),
                          ),
                          title: Text(comment.user?.name ?? 'Anonymous'),
                          subtitle: Text(comment.content),
                          trailing: Text(
                            formatDate(comment.createdAt.toString()),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      );
                    },
                  ),
        SizedBox(
          height: 10,
        ),
        PaginationWidget(
          currentPage: currentPage,
          totalPages: totalPage,
          onPageChanged: (page) {
            setState(() {
              currentPage = page;
            });
          },
        ),
      ],
    );
  }
}

import 'package:computer_sales_app/components/custom/pagination.dart';
import 'package:computer_sales_app/components/custom/skeleton.dart';
import 'package:computer_sales_app/components/custom/snackbar.dart';
import 'package:computer_sales_app/helpers/formatMoney.dart';
import 'package:computer_sales_app/models/review.model.dart';
import 'package:computer_sales_app/provider/user_provider.dart';
import 'package:computer_sales_app/services/review.service.dart';
import 'package:computer_sales_app/services/socket_io_client.dart';
import 'package:flutter/material.dart';
import 'package:computer_sales_app/config/color.dart';
import 'package:provider/provider.dart';

class ProductReviewSection extends StatefulWidget {
  const ProductReviewSection({
    super.key,
    required this.productId,
    required this.productName,
    required this.averageRating,
    required this.reviewCount,
    required this.images,
    required this.socketService,
    required this.reviews,
    this.isLoading = false,
  });

  final String productId;
  final String productName;
  final double averageRating;
  final int reviewCount;
  final List<String> images;
  final SocketService socketService;
  final List<ReviewModel> reviews;
  final bool isLoading;

  @override
  State<ProductReviewSection> createState() => _ProductReviewSectionState();
}

class _ProductReviewSectionState extends State<ProductReviewSection> {
  final TextEditingController _commentController = TextEditingController();
  final ReviewService reviewService = ReviewService();
  int currentPage = 1;
  int totalPage = 1;
  int limit = 10;
  bool _showAll = false;

  void _addReviewRating(int rating, String content) {
    try {
      widget.socketService.sendReviewRating(
        productVariantId: widget.productId,
        review: content,
        rating: rating,
        // Removed onSuccess callback as requested
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
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.loadUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalPage =
        widget.reviews.length > 10 ? (widget.reviews.length / 10).ceil() : 1;

    final reviewPagination =
        widget.reviews.skip((currentPage - 1) * limit).take(limit).toList();

    final reviewsToShow =
        _showAll ? reviewPagination : reviewPagination.take(2).toList();

    //Get user data
    final userProvider = Provider.of<UserProvider>(context);
    final userId = userProvider.userModel?.id ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reviews ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.averageRating.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < widget.averageRating
                          ? Icons.star
                          : index < widget.averageRating + 0.5
                              ? Icons.star_half
                              : Icons.star_border,
                      size: 18,
                      color: AppColors.yellow,
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.reviewCount} review${widget.reviewCount == 1 ? '' : 's'}',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
            Column(
              spacing: 4,
              children: [
                RatingReviewBar(
                  rating: 5,
                  count: reviewPagination
                      .where((review) => review.rating == 5.0)
                      .length,
                ),
                RatingReviewBar(
                  rating: 4,
                  count: reviewPagination
                      .where((review) => review.rating == 4.0)
                      .length,
                ),
                RatingReviewBar(
                  rating: 3,
                  count: reviewPagination
                      .where((review) => review.rating == 3.0)
                      .length,
                ),
                RatingReviewBar(
                  rating: 2,
                  count: reviewPagination
                      .where((review) => review.rating == 2.0)
                      .length,
                ),
                RatingReviewBar(
                  rating: 1,
                  count: reviewPagination
                      .where((review) => review.rating == 1.0)
                      .length,
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 10),

        // Danh sách đánh giá
        widget.isLoading
            ? ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 10,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) => SkeletonHorizontalProduct(),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: reviewsToShow.length,
                separatorBuilder: (_, __) => SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final review = reviewsToShow[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.grey.withAlpha(20),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tên + thời gian
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              review.user?.name ?? 'Anonymous',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              formatDate(review.createdAt.toString()),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Rating
                        Row(
                          children: List.generate(5, (i) {
                            return Icon(
                              i < (review.rating ?? 0.0)
                                  ? Icons.star
                                  : i < ((review.rating ?? 0.0) + 0.5)
                                      ? Icons.star_half
                                      : Icons.star_border,
                              size: 18,
                              color: AppColors.yellow,
                            );
                          }),
                        ),
                        const SizedBox(height: 8),
                        // Nội dung
                        Text(
                          review.content,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  );
                },
              ),
        if (_showAll)
          Column(
            children: [
              const SizedBox(height: 20),
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
          ),
        const SizedBox(height: 20),

        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            if (reviewPagination.length > 2)
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _showAll = !_showAll;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      _showAll
                          ? 'Collapse'
                          : 'View ${widget.reviewCount} reviews',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ),
              ),
            if (userId.isNotEmpty)
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      _openReviewDialog(
                        context,
                        images: widget.images,
                        productName: widget.productName,
                        handleReviewRating: (rating, content) {
                          _addReviewRating(rating, content);
                          Navigator.pop(context);
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                        color: AppColors.primary,
                      ),
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Write a review',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        )
      ],
    );
  }
}

class RatingReviewBar extends StatelessWidget {
  const RatingReviewBar({
    super.key,
    required this.rating,
    required this.count,
  });

  final int rating;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 10,
          child: Text(
            rating.toString(),
            style: TextStyle(
              fontSize: 14,
              color: const Color.fromARGB(255, 179, 179, 179),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Icon(
          Icons.star,
          size: 18,
          color: AppColors.yellow,
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 200,
          child: LinearProgressIndicator(
            value: count / 5,
            backgroundColor: Colors.grey[300],
            color: AppColors.yellow,
            minHeight: 12,
            borderRadius: BorderRadius.circular(8),
          ),
        )
      ],
    );
  }
}

void _openReviewDialog(
  BuildContext context, {
  required List<String> images,
  required String productName,
  required Function(int rating, String content) handleReviewRating,
}) {
  int selectedRating = 0;
  bool showForm = false;
  TextEditingController commentController = TextEditingController();
  bool recommend = false;
  String errorMessage = '';

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetAnimationCurve: Curves.easeInOut,
        insetAnimationDuration: const Duration(milliseconds: 1000),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 660),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Review Product',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Image.network(
                        images[0],
                        height: 100,
                      ),
                      SizedBox(height: 8),
                      Text(
                        productName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(5, (index) {
                          return Column(
                            children: [
                              IconButton(
                                icon: Icon(
                                  index < selectedRating
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: AppColors.yellow,
                                  size: 32,
                                ),
                                onPressed: () {
                                  setState(() {
                                    selectedRating = index + 1;
                                    showForm = selectedRating > 0;
                                  });
                                },
                              ),
                              SizedBox(height: 4),
                              Text(
                                [
                                  'Terrible',
                                  'Poor',
                                  'Average',
                                  'Good',
                                  'Excelent'
                                ][index],
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          );
                        }),
                      ),
                      SizedBox(height: 24),
                      if (showForm) ...[
                        TextField(
                          controller: commentController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Write your review here',
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.primary,
                              ),
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (errorMessage.isNotEmpty)
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                errorMessage,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                        SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Checkbox(
                              value: recommend,
                              onChanged: (val) {
                                setState(() {
                                  recommend = val ?? false;
                                });
                              },
                              checkColor: Colors.white,
                              activeColor: AppColors.primary,
                            ),
                            Expanded(
                              child: Text(
                                'I will recommend this product to my friends',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 48),
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (commentController.text.isEmpty) {
                              setState(() {
                                errorMessage = 'Please enter your review';
                              });
                              return;
                            }
                            handleReviewRating(
                              selectedRating,
                              commentController.text,
                            );
                          },
                          child: Text(
                            'Gửi đánh giá',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ]
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildRatingStars() {
  final labels = ['Terrible', 'Poor', 'Average', 'Good', 'Excelent'];

  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(5, (index) {
      return Column(
        children: [
          IconButton(
            icon: Icon(
              Icons.star_border,
              color: Colors.orange,
              size: 32,
            ),
            onPressed: () {
              // TODO: chọn số sao
            },
          ),
          SizedBox(height: 4),
          Text(
            labels[index],
            style: TextStyle(fontSize: 12),
          ),
        ],
      );
    }),
  );
}

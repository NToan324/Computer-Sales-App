import 'package:flutter/material.dart';
import 'package:computer_sales_app/config/color.dart';

class ProductReviewSection extends StatefulWidget {
  const ProductReviewSection({super.key});

  @override
  State<ProductReviewSection> createState() => _ProductReviewSectionState();
}

class _ProductReviewSectionState extends State<ProductReviewSection> {
  final List<Map<String, dynamic>> allReviews = [
    {
      "name": "Nguyễn Văn A",
      "rating": 4.5,
      "comment": "Sản phẩm rất tốt, hiệu năng ổn định. Giao hàng nhanh!",
      "time": "2 ngày trước"
    },
    {
      "name": "Trần Thị B",
      "rating": 5.0,
      "comment": "Máy chạy mượt, thiết kế đẹp. Rất hài lòng!",
      "time": "1 tuần trước"
    },
    {
      "name": "Lê Văn C",
      "rating": 3.5,
      "comment": "Máy ổn nhưng pin hơi yếu, cần cải thiện.",
      "time": "3 tuần trước"
    },
    {
      "name": "Phạm D",
      "rating": 4.0,
      "comment": "Phù hợp giá tiền. Có hơi nóng khi dùng lâu.",
      "time": "1 tháng trước"
    },
  ];

  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final reviewsToShow = _showAll ? allReviews : allReviews.take(2).toList();
    final averageRating = allReviews.fold<double>(
          0.0,
          (sum, item) => sum + item['rating'],
        ) /
        allReviews.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Phần đầu: Tổng số đánh giá + trung bình sao
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Đánh giá sản phẩm',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            Row(
              children: [
                Icon(Icons.star, size: 18, color: Colors.orange),
                Text(
                  averageRating.toStringAsFixed(1),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                Text(
                  ' (${allReviews.length} đánh giá)',
                  style: TextStyle(color: Colors.grey[700]),
                )
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Danh sách đánh giá
        ListView.separated(
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
                        review['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        review['time'],
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
                        i < review['rating']
                            ? Icons.star
                            : i < review['rating'] + 0.5
                                ? Icons.star_half
                                : Icons.star_border,
                        size: 18,
                        color: Colors.orange,
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  // Nội dung
                  Text(
                    review['comment'],
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            );
          },
        ),

        const SizedBox(height: 8),
        // Nút xem thêm / thu gọn
        if (allReviews.length > 2)
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
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
                  ),
                  child: Text(
                    _showAll ? 'Thu gọn' : 'Xem thêm',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
                SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    _openReviewDialog(context);
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Viết đánh giá',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }
}

void _openReviewDialog(BuildContext context) {
  int _selectedRating = 0;
  bool _showForm = false;
  TextEditingController _commentController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  bool _agreePolicy = false;
  bool _recommend = false;

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                      'Đánh giá sản phẩm',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Image.network(
                      'https://cdn.tgdd.vn/Products/Images/44/302209/TimerThumb/hp-pavilion-15-eg2088tu-i7-7c0r0pa-(10).jpg',
                      height: 100,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Laptop HP Pavilion 15 eg2088TU i7 1260P/16GB/512GB/Win11 (7C0R0PA)',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Column(
                          children: [
                            IconButton(
                              icon: Icon(
                                index < _selectedRating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.orange,
                                size: 32,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedRating = index + 1;
                                  _showForm = _selectedRating > 0;
                                });
                              },
                            ),
                            SizedBox(height: 4),
                            Text(
                              [
                                'Rất tệ',
                                'Tệ',
                                'Tạm ổn',
                                'Tốt',
                                'Rất tốt'
                              ][index],
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        );
                      }),
                    ),
                    SizedBox(height: 24),
                    if (_showForm) ...[
                      TextField(
                        controller: _commentController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Mời bạn chia sẻ thêm cảm nhận...',
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      CheckboxListTile(
                        title: Text(
                          'Tôi sẽ giới thiệu sản phẩm cho bạn bè, người thân',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        value: _recommend,
                        onChanged: (val) {
                          setState(() {
                            _recommend = val ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: 'Họ tên (bắt buộc)',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                hintText: 'Số điện thoại (bắt buộc)',
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      CheckboxListTile(
                        title: RichText(
                          text: TextSpan(
                            text: 'Tôi đồng ý với ',
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Chính sách xử lý dữ liệu cá nhân',
                                style: TextStyle(color: Colors.blue),
                              ),
                              TextSpan(text: ' của Thế Giới Di Động'),
                            ],
                          ),
                        ),
                        value: _agreePolicy,
                        onChanged: (val) {
                          setState(() {
                            _agreePolicy = val ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
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
                          if (_agreePolicy &&
                              _nameController.text.isNotEmpty &&
                              _phoneController.text.isNotEmpty) {
                            Navigator.of(context).pop();
                          } else {}
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
      );
    },
  );
}

Widget _buildRatingStars() {
  final labels = ['Rất tệ', 'Tệ', 'Tạm ổn', 'Tốt', 'Rất tốt'];

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

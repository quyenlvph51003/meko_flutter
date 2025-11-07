import 'package:flutter/material.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/utils/converts/forrmat_uttils.dart';

class ItemProductSearch extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final double price;
  final VoidCallback? onTap;

  const ItemProductSearch({Key? key, required this.imageUrl, required this.title, required this.description, required this.price, this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2, // 👈 shadow nhẹ hơn (0 = không có, 1~2 = mảnh)
        shadowColor: Colors.black.withValues(alpha: 0.5), // 👈 màu đổ bóng nhẹ
        child: Container(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              // Ảnh sản phẩm bên trái
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: Icon(Icons.image, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(width: 12),
              // Nội dung bên phải
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      FormatUtils.formatCurrency(price),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFE53935)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

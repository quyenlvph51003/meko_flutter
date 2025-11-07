import 'package:flutter/material.dart';
import 'package:meko_project/consts/app_dimens.dart';
import 'package:meko_project/consts/app_images.dart';
import 'package:meko_project/consts/app_paths.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/utils/converts/forrmat_uttils.dart';

class ProductCart extends StatelessWidget {
  ProductCart({Key? key, required this.item, required this.index, required this.onTap}) : super(key: key);

  final ListingItem item;
  final int index;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: AppDimens.getHeight(context) * 0.17,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: Image.network(
                      item.images.isNotEmpty ? item.images.first : AppPaths.img_splash,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) {
                        return Container(color: Colors.grey[300], child: const Icon(Icons.image, size: 32));
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    children: [
                      Visibility(
                        visible: item.isPinned == 1,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                          child: Image.asset(AppImages.icon_pinned, width: 20, height: 20, color: Colors.red),
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                          child: const Icon(Icons.favorite_border, size: 16, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF111111)),
                ),
                // const SizedBox(height: 2),
                // Text(
                //   item.status, // ví dụ "APPROVED"
                //   maxLines: 1,
                //   overflow: TextOverflow.ellipsis,
                //   style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                // ),
                Text(
                  FormatUtils.formatCurrency(double.tryParse(item.price.toString()) ?? 0),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFFE53935)),
                ),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

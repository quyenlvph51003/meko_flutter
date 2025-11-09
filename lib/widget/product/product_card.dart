import 'package:flutter/material.dart';
import 'package:meko_project/consts/app_dimens.dart';
import 'package:meko_project/consts/app_images.dart';
import 'package:meko_project/consts/app_paths.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/repository/favorite/favorite_repo.dart';
import 'package:meko_project/utils/converts/forrmat_uttils.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';

class ProductCart extends StatefulWidget {
  const ProductCart({Key? key, required this.item, required this.index, required this.onTap}) : super(key: key);

  final ListingItem item;
  final int index;
  final VoidCallback onTap;

  @override
  State<ProductCart> createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.item.isFavorite ?? false;
  }

  Future<void> toggleFavorite() async {
    final favoriteRepo = getIt<FavoriteRepo>();
    final user = await SqliteHelper.getUserSql();
    if (isFavorite) {
      favoriteRepo.deleteFavorite(postId: widget.item.id, userId: user?.id ?? 0);
    } else {
      favoriteRepo.createFavorite(postId: widget.item.id, userId: user?.id ?? 0);
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: AppDimens.getHeight(context) * 0.17,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: Image.network(
                      widget.item.images.isNotEmpty ? widget.item.images.first : AppPaths.img_splash,
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
                        visible: widget.item.isPinned == 1,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                          child: Image.asset(AppImages.icon_pinned, width: 20, height: 20, color: Colors.red),
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: toggleFavorite,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                          child: isFavorite
                              ? const Icon(Icons.favorite, size: 16, color: Colors.red)
                              : const Icon(Icons.favorite_border, size: 16, color: Colors.grey),
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
                  widget.item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF111111)),
                ),
                Text(
                  FormatUtils.formatCurrency(double.tryParse(widget.item.price.toString()) ?? 0),
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
                        widget.item.address,
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

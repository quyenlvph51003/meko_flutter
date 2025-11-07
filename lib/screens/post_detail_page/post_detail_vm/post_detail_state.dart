import 'package:meko_project/models/body/location/province_model.dart';
import 'package:meko_project/models/body/location/ward_model.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';

class PostDetailState {
  final ListingItem item;
  final int currentImageIndex;
  final bool isLiked;
  final bool descriptionExpanded;

  const PostDetailState({required this.item, required this.currentImageIndex, required this.isLiked, required this.descriptionExpanded});

  PostDetailState copyWith({ListingItem? item, int? currentImageIndex, bool? isLiked, bool? descriptionExpanded}) {
    return PostDetailState(
      item: item ?? this.item,
      currentImageIndex: currentImageIndex ?? this.currentImageIndex,
      isLiked: isLiked ?? this.isLiked,
      descriptionExpanded: descriptionExpanded ?? this.descriptionExpanded,
    );
  }
}

// post_detail_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/repository/favorite/favorite_repo.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';
import 'post_detail_state.dart';

class PostDetailCubit extends Cubit<PostDetailState> {
  final Future<ListingItem> Function(int) loader;
  final FavoriteRepo favoriteRepo;
  PostDetailCubit({required ListingItem item, required this.loader, required this.favoriteRepo})
    : super(PostDetailState(item: item, currentImageIndex: 0, isLiked: false, descriptionExpanded: false));

  Future<void> init(int id) async {
    final full = await loader(id);
    emit(state.copyWith(item: full, currentImageIndex: 0));
  }

  void changeImageIndex(int index) {
    emit(state.copyWith(currentImageIndex: index));
  }

  void toggleLike() {
    // if (!state.isLiked) {
    //   fetchCreateFavorite();
    // } else {
    //   // fetchDeleteFavorite();
    // }
    emit(state.copyWith(isLiked: !state.isLiked));
  }

  void toggleDescription() {
    emit(state.copyWith(descriptionExpanded: !state.descriptionExpanded));
  }

  Future<void> fetchCreateFavorite() async {
    final user = await SqliteHelper.getUserSql();
    if (user == null) {
      return;
    }
    final isLiked = await favoriteRepo.createFavorite(postId: state.item.id, userId: user.id!);
    emit(state.copyWith(isLiked: isLiked));
  }
}

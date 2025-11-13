import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meko_project/common/enum_common.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/models/body/user/user_model.dart';
import 'package:meko_project/repository/post/post_repo.dart';
import 'package:meko_project/routers/app_router_paths.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';
part 'tab_posting_state.dart';

class PostManagerCubit extends Cubit<PostManagerState> {
  final PostRepo postRepo;
  PostManagerCubit({required this.postRepo}) : super(PostManagerState());

  //init widget
  void initCubit() async {
    final user = await SqliteHelper.getUserSql();
    if (user != null) {
      emit(state.copyWith(user: user));
      await getPostByStatus();
    }
  }

  Future<void> selectTab(PostStatus tab) async {
    emit(state.copyWith(currentTab: tab));
    await getPostByStatus();
  }

  //navigate detail product
  void onProductTap(BuildContext context, int index, ListingItem item) {
    Navigator.pushNamed(context, AppRouterPaths.postDetailPage, arguments: {'item': item, 'loader': (int id) => postRepo.getPostDetailItem(id)});
  }

  void increaseDT() {
    emit(state.copyWith(dtPoint: state.dtPoint + 1));
  }

  Future<void> onLoadMore() async {
    await getPostByStatus(page: state.page + 1, isLoading: false, isLoadmore: true);
  }

  //call api post by status
  Future<void> getPostByStatus({int page = 0, int size = 10, bool isLoading = true, bool isLoadmore = false}) async {
    print('page ${page}');
    if (isLoading) {
      emit(state.copyWith(isLoading: true));
    }
    PostSearchRequest postSearchRequest = PostSearchRequest(status: state.currentTab, userPosterId: state.user?.id);
    final result = await postRepo.getPosts(postSearchRequest: postSearchRequest, page: page);
    if (result.isSuccess) {
      if (isLoadmore) {
        // add thêm vào list
        emit(state.copyWith(listings: [...state.listings, ...result.data?.content ?? []]));
      } else {
        //data ban đầu refresh
        emit(state.copyWith(listings: result.data?.content ?? []));
      }

      // những cái chung
      emit(state.copyWith(isLoading: false, isLastPage: result.data?.content.isEmpty, page: page));
    }
  }
}

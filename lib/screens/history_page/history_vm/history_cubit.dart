import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/repository/history/history_repo.dart';
import 'package:meko_project/repository/post/post_repo.dart';
import 'package:meko_project/routers/app_router_paths.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final HistoryRepo historyRepo;
  HistoryCubit({required this.historyRepo})
    : super(HistoryState(listings: [], isLoading: false, isLoadMore: false, page: 0, size: 10, total: 0, isLastPage: false));

  void initCubit() async {
    await getHistoryList();
  }

  void onProductTap(BuildContext context, int index, ListingItem item) {
    Navigator.pushNamed(
      context,
      AppRouterPaths.postDetailPage,
      arguments: {'item': item, 'loader': (int id) => getIt<PostRepo>().getPostDetailItem(id)},
    );
  }

  Future<void> getHistoryList() async {
    // reset to first page
    emit(state.copyWith(isLoading: true, page: 0, isLastPage: false));
    final res = await historyRepo.getListHistory(searchText: '', page: 0, size: 10);
    final firstPageItems = res.data?.content ?? [];
    emit(state.copyWith(listings: firstPageItems, isLastPage: false, isLoading: false, page: 0));
  }

  Future<void> onLoadmore() async {
    final res = await historyRepo.getListHistory(searchText: '', page: state.page + 1, size: state.size);
    final items = res.data?.content ?? [];
    emit(state.copyWith(listings: [...state.listings, ...items], isLastPage: res.data?.content.isEmpty ?? false, isLoadMore: false));
  }
}

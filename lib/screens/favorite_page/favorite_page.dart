import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/repository/favorite/favorite_repo.dart';
import 'package:meko_project/screens/favorite_page/favorite_vm/favorite_cubit.dart';
import 'package:meko_project/utils/converts/forrmat_uttils.dart';
import 'package:meko_project/widget/app_loading/app_loader.dart';
import 'package:meko_project/widget/widget_helper.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin đăng đã lưu', style: TextStyle(color: Colors.black, fontSize: 20)),
      ),
      body: BlocProvider(
        create: (context) => FavoriteCubit(favoriteRepo: getIt<FavoriteRepo>())..initCubit(),
        child: BlocBuilder<FavoriteCubit, FavoriteState>(
          builder: (context, state) {
            final vm = context.read<FavoriteCubit>();

            return RefreshLoadmore(
              onRefresh: () => vm.getFavoriteList(),
              onLoadmore: () => vm.loadMore(),
              isLastPage: state.isLastPage,
              child: _buildListContent(state, vm),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListContent(FavoriteState state, FavoriteCubit vm) {
    if (state.isLoading && state.listings.isEmpty) {
      return Column(
        children: [
          const SizedBox(height: 50),
          const Center(child: AppLoader()),
        ],
      );
    }

    if (state.listings.isEmpty) {
      return Column(children: [const SizedBox(height: 50), WidgetHelper.noDataListing()]);
    }

    // ✅ chỉ 1 cuộn duy nhất
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: state.listings.length,
      separatorBuilder: (context, index) => const Divider(color: Colors.grey, thickness: 0.5, height: 25),
      itemBuilder: (context, index) {
        final item = state.listings[index];
        return GestureDetector(
          onTap: () => vm.onProductTap(context, index, item),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    item.images.first,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            FormatUtils.formatCurrency(double.tryParse(item.price) ?? 0),
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFE53935)),
                          ),
                          GestureDetector(
                            onTap: () {
                              vm.updateIsFavorite(index: index, postId: item.postId ?? 0);
                            },
                            child: state.isFavorite?[index] == true
                                ? const Icon(Icons.favorite, color: Colors.red)
                                : const Icon(Icons.favorite_border, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

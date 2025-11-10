import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/repository/favorite/favorite_repo.dart';
import 'package:meko_project/repository/history/history_repo.dart';
import 'package:meko_project/screens/favorite_page/favorite_vm/favorite_cubit.dart';
import 'package:meko_project/screens/history_page/history_vm/history_cubit.dart';
import 'package:meko_project/utils/converts/forrmat_uttils.dart';
import 'package:meko_project/widget/app_loading/app_loader.dart';
import 'package:meko_project/widget/widget_helper.dart';
import 'package:refresh_loadmore/refresh_loadmore.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin đăng đã xem', style: TextStyle(color: Colors.black, fontSize: 20)),
      ),
      body: BlocProvider(
        create: (context) => HistoryCubit(historyRepo: getIt<HistoryRepo>())..initCubit(),
        child: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            final vm = context.read<HistoryCubit>();

            return RefreshLoadmore(
              onRefresh: () => vm.getHistoryList(),
              onLoadmore: () => vm.onLoadmore(),
              isLastPage: state.isLastPage,
              child: _buildListContent(state, vm),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListContent(HistoryState state, HistoryCubit vm) {
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
                          Text(FormatUtils.timeAgo(item.createdAt?.toIso8601String() ?? ''), style: TextStyle(fontSize: 14, color: Colors.grey[700])),
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

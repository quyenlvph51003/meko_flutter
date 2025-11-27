import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/repository/post/post_repo.dart';
import 'package:meko_project/repository/reviews/review_repo.dart';
import 'package:meko_project/screens/my_review_page/my_review_vm/my_review_cubit.dart';
import 'package:meko_project/utils/converts/forrmat_uttils.dart';
import 'package:meko_project/widget/app_loading/app_loader.dart';
import 'package:meko_project/widget/widget_helper.dart';

class MyReviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyReviewCubit(reviewRepo: getIt<ReviewRepo>(), postRepo: getIt<PostRepo>())..initCubit(),
      child: MyReviewPageStateFull(),
    );
  }
}

class MyReviewPageStateFull extends StatefulWidget {
  const MyReviewPageStateFull({super.key});

  @override
  State<MyReviewPageStateFull> createState() => _MyReviewPageState();
}

class _MyReviewPageState extends State<MyReviewPageStateFull> with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollControllerTab1 = ScrollController();
  final ScrollController _scrollControllerTab2 = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabController.addListener(() {
        if (_tabController.indexIsChanging) return;
        context.read<MyReviewCubit>().changeTabIndex(_tabController.index);
      });

      // Lắng nghe scroll để load thêm dữ liệu
      _scrollControllerTab1.addListener(() => _onScroll(0));
      _scrollControllerTab2.addListener(() => _onScroll(1));
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollControllerTab1.dispose();
    _scrollControllerTab2.dispose();
    super.dispose();
  }

  void _onScroll(int tabIndex) {
    final cubit = context.read<MyReviewCubit>();
    final scrollController = tabIndex == 0 ? _scrollControllerTab1 : _scrollControllerTab2;

    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100) {
      cubit.loadMore();
    }
  }

  Future<void> _onRefresh() async {
    await context.read<MyReviewCubit>().getReviews(page: 0, isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyReviewCubit, MyReviewState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text("Đánh giá của tôi"),
            bottom: TabBar(
              controller: _tabController,
              unselectedLabelColor: Colors.black,
              labelColor: Colors.green,
              labelStyle: const TextStyle(fontWeight: FontWeight.w500),
              dividerColor: Colors.transparent,
              indicatorColor: Colors.green,
              indicatorWeight: 1,
              tabs: const [
                Tab(text: "Bài viết của tôi"),
                Tab(text: "Bài viết đã đánh giá"),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [_buildReviewList(state, _scrollControllerTab1), _buildReviewList(state, _scrollControllerTab2)],
          ),
        );
      },
    );
  }

  Widget _buildReviewList(MyReviewState state, ScrollController scrollController) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: state.listReview.isEmpty
          ? state.isLoading
                ? const Center(child: AppLoader())
                : Center(
                    child: Padding(padding: const EdgeInsets.symmetric(vertical: 50), child: WidgetHelper.noDataListing()),
                  )
          : ListView.separated(
              controller: scrollController,
              separatorBuilder: (context, index) => Divider(color: Colors.grey.withOpacity(0.7), thickness: 1, height: 1),
              itemCount: state.hasMore ? state.listReview.length + 1 : state.listReview.length,
              itemBuilder: (context, index) {
                if (index >= state.listReview.length) {
                  // Hiển thị loading indicator khi load thêm page
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final item = state.listReview[index];
                return InkWell(
                  onTap: () => context.read<MyReviewCubit>().onProductTap(context, index),
                  child: ReviewItem(
                    productImageUrl: item.imagesPost?[0] ?? '',
                    productName: item.postTitle ?? '',
                    userAvatarUrl: item.reviewUserAvatar ?? '',
                    userName: item.reviewUser ?? '',
                    timeAgo: item.reviewCreatedAt ?? '',
                    comment: item.reviewComment ?? '',
                    description: item.postDesciption ?? '',
                  ),
                );
              },
            ),
    );
  }
}

class ReviewItem extends StatelessWidget {
  final String productImageUrl;
  final String productName;
  final String userAvatarUrl;
  final String userName;
  final String timeAgo;
  final String comment;
  final String description;
  const ReviewItem({
    super.key,
    required this.productImageUrl,
    required this.productName,
    required this.userAvatarUrl,
    required this.userName,
    required this.timeAgo,
    required this.comment,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ảnh + tên sản phẩm
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(productImageUrl, width: 60, height: 60, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    Text(description, style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Người đánh giá + thời gian
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(radius: 12, backgroundImage: NetworkImage(userAvatarUrl)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    Text(comment, style: const TextStyle(fontSize: 14, height: 1.5)),
                  ],
                ),
              ),
              Text(FormatUtils.timeAgo(timeAgo), style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

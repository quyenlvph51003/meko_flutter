part of 'tab_posting_cubit.dart';

class PostManagerState extends Equatable {
  final int notificationCount;
  final int chatCount;
  final int voucherCount;
  final int dtPoint;
  final PostStatus currentTab;
  UserModel? user;
  final int page;
  final List<ListingItem> listings;
  final bool isLoading;
  final bool isLastPage;
  PostManagerState({
    this.notificationCount = 11,
    this.chatCount = 0,
    this.voucherCount = 1,
    this.dtPoint = 0,
    this.currentTab = PostStatus.PENDING,
    this.user,
    this.page = 0,
    this.listings = const [],
    this.isLoading = false,
    this.isLastPage = false,
  });

  PostManagerState copyWith({
    int? notificationCount,
    int? chatCount,
    int? voucherCount,
    int? dtPoint,
    PostStatus? currentTab,
    UserModel? user,
    int? page,
    List<ListingItem>? listings,
    bool? isLoading,
    bool? isLastPage,
  }) {
    return PostManagerState(
      notificationCount: notificationCount ?? this.notificationCount,
      chatCount: chatCount ?? this.chatCount,
      voucherCount: voucherCount ?? this.voucherCount,
      dtPoint: dtPoint ?? this.dtPoint,
      currentTab: currentTab ?? this.currentTab,
      user: user ?? this.user,
      page: page ?? this.page,
      listings: listings ?? this.listings,
      isLoading: isLoading ?? this.isLoading,
      isLastPage: isLastPage ?? this.isLastPage,
    );
  }

  @override
  List<Object?> get props {
    return [notificationCount, chatCount, voucherCount, dtPoint, currentTab, user, page, listings, isLoading, isLastPage];
  }
}

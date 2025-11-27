part of 'my_review_cubit.dart';

class MyReviewState extends Equatable {
  final int tabIndex;
  final List<MyReviewModel> listReview;
  final bool isLoading;
  final int page;
  final bool hasMore;

  const MyReviewState({required this.tabIndex, required this.listReview, required this.isLoading, required this.page, required this.hasMore});

  MyReviewState copyWith({int? tabIndex, List<MyReviewModel>? listReview, bool? isLoading, int? page, bool? hasMore}) {
    return MyReviewState(
      tabIndex: tabIndex ?? this.tabIndex,
      listReview: listReview ?? this.listReview,
      isLoading: isLoading ?? this.isLoading,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [tabIndex, listReview, isLoading];
}

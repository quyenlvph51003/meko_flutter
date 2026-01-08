part of 'post_create_cubit.dart';

class PostCreateState extends Equatable {
  final bool? isLoading;
  final List<Category> categories;
  List<Category> subCategories;
  final List<Category> selectedCategories;
  final List<ProvinceModel> provinces;
  final List<WardModel> wards;
  ProvinceModel? provinceSelected;
  WardModel? wardSelected;
  ProvinceModel? provinceSelectedCached;
  WardModel? wardSelectedCached;
  final int rebuild;
  final bool? isSubmitting;
  final UserPaymentModel? userPaymentSelected;
  final int oldProductPercent;
  PostCreateState({
    this.isLoading,
    this.categories = const [],
    this.subCategories = const [],
    this.selectedCategories = const [],
    this.provinces = const [],
    this.wards = const [],
    this.provinceSelected,
    this.wardSelected,
    this.provinceSelectedCached,
    this.wardSelectedCached,
    this.rebuild = 0,
    this.isSubmitting,
    this.userPaymentSelected,
    this.oldProductPercent = 80,
  });

  PostCreateState copyWith({
    bool? isLoading,
    List<Category>? categories,
    List<Category>? subCategories,
    List<Category>? selectedCategories,
    List<ProvinceModel>? provinces,
    List<WardModel>? wards,
    ProvinceModel? provinceSelected,
    WardModel? wardSelected,
    ProvinceModel? provinceSelectedCached,
    WardModel? wardSelectedCached,
    int? rebuild,
    bool? isSubmitting,
    UserPaymentModel? userPaymentSelected,
    int? oldProductPercent,
  }) {
    return PostCreateState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      subCategories: subCategories ?? this.subCategories,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      provinces: provinces ?? this.provinces,
      wards: wards ?? this.wards,
      provinceSelected: provinceSelected ?? this.provinceSelected,
      wardSelected: wardSelected ?? this.wardSelected,
      provinceSelectedCached: provinceSelectedCached ?? this.provinceSelectedCached,
      wardSelectedCached: wardSelectedCached ?? this.wardSelectedCached,
      rebuild: rebuild ?? this.rebuild,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      userPaymentSelected: userPaymentSelected ?? this.userPaymentSelected,
      oldProductPercent: oldProductPercent ?? this.oldProductPercent,
    );
  }

  PostCreateState copyWithNullable({
    List<Category>? selectedCategories,
    List<Category>? subCategories,
    List<WardModel>? wards,
    ProvinceModel? provinceSelected,
    WardModel? wardSelected,
    ProvinceModel? provinceSelectedCached,
    WardModel? wardSelectedCached,
    int? rebuild,
    UserPaymentModel? userPaymentSelected,
    bool resetSelectedCategories = false,
    bool resetSubCategories = false,
  }) {
    return PostCreateState(
      isLoading: isLoading,
      categories: categories,
      selectedCategories: resetSelectedCategories ? [] : (selectedCategories ?? this.selectedCategories),
      provinces: provinces,
      wards: wards ?? this.wards,
      provinceSelected: provinceSelected,
      wardSelected: wardSelected,
      provinceSelectedCached: provinceSelectedCached,
      wardSelectedCached: wardSelectedCached,
      rebuild: rebuild ?? this.rebuild,
      subCategories: resetSubCategories ? [] : (subCategories ?? this.subCategories),
      isSubmitting: isSubmitting,
      userPaymentSelected: userPaymentSelected ?? this.userPaymentSelected,
      oldProductPercent: oldProductPercent,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    categories,
    subCategories,
    selectedCategories,
    provinces,
    wards,
    provinceSelected,
    wardSelected,
    provinceSelectedCached,
    wardSelectedCached,
    rebuild,
    isSubmitting,
    userPaymentSelected,
    oldProductPercent,
  ];
}

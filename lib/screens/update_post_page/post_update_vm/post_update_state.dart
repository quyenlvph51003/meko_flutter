part of 'post_update_cubit.dart';

class PostUpdateState extends Equatable {
  ListingItem? listing;
  final bool? isLoading;
  final List<Category> categories;
  List<Category> subCategories;

  /// cache categories
  final List<Category> selectedCategories;
  final List<ProvinceModel> provinces;
  final List<WardModel> wards;
  ProvinceModel? provinceSelected;
  WardModel? wardSelected;
  ProvinceModel? provinceSelectedCached; // luuw tam
  WardModel? wardSelectedCached; // luu tam
  final int rebuild;
  String? locationStr;
  final bool? isLoadingUpdate;
  final bool? isLoadingExtension;
  final UserPaymentModel? userPayment;
  final int? oldProductPercent;

  PostUpdateState({
    this.listing,
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
    this.locationStr,
    this.isLoadingUpdate,
    this.userPayment,
    this.isLoadingExtension,
    this.oldProductPercent,
  });

  PostUpdateState copyWith({
    ListingItem? listing,
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
    String? locationStr,
    bool? isLoadingUpdate,
    UserPaymentModel? userPayment,
    bool? isLoadingExtension,
    int? oldProductPercent,
  }) {
    return PostUpdateState(
      listing: listing ?? this.listing,
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
      locationStr: locationStr ?? this.locationStr,
      isLoadingUpdate: isLoadingUpdate ?? this.isLoadingUpdate,
      userPayment: userPayment ?? this.userPayment,
      isLoadingExtension: isLoadingExtension ?? this.isLoadingExtension,
      oldProductPercent: oldProductPercent ?? this.oldProductPercent,
    );
  }

  PostUpdateState copyWithNullable({
    ListingItem? listing,
    bool? isLoading,
    List<Category>? categories,
    List<Category>? selectedCategories,
    List<ProvinceModel>? provinces,
    List<WardModel>? wards,
    ProvinceModel? provinceSelected,
    WardModel? wardSelected,
    ProvinceModel? provinceSelectedCached,
    WardModel? wardSelectedCached,
    int? rebuild,
    List<Category>? subCategories,
    UserPaymentModel? userPayment,
    bool? isLoadingExtension,
  }) {
    return PostUpdateState(
      listing: listing ?? this.listing,
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      selectedCategories: selectedCategories ?? [],
      provinces: provinces ?? this.provinces,
      wards: wards ?? this.wards,
      provinceSelected: provinceSelected,
      wardSelected: wardSelected,
      provinceSelectedCached: provinceSelectedCached,
      wardSelectedCached: wardSelectedCached,
      rebuild: rebuild ?? this.rebuild,
      subCategories: subCategories ?? [],
      userPayment: userPayment ?? this.userPayment,
      isLoadingExtension: isLoadingExtension ?? this.isLoadingExtension,
    );
  }

  @override
  List<Object?> get props => [
    listing,
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
    locationStr,
    isLoadingUpdate,
    userPayment,
    isLoadingExtension,
    oldProductPercent,
  ];
}

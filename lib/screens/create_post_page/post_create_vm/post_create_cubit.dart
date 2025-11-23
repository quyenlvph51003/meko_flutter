import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meko_project/models/body/category/category_model.dart';
import 'package:meko_project/models/body/location/province_model.dart';
import 'package:meko_project/models/body/location/ward_model.dart';
import 'package:meko_project/models/body/paymnent/user_payment_model.dart';
import 'package:meko_project/repository/category/category_repo.dart';
import 'package:meko_project/repository/location/province_repo.dart';
import 'package:meko_project/repository/location/ward_repo.dart';
import 'package:meko_project/repository/post/post_create_request.dart';
import 'package:meko_project/repository/post/post_repo.dart';
import 'package:meko_project/utils/data_local_helper/sqlite_helper.dart';
import 'package:meko_project/widget/app_validators/app_validators.dart';

part 'post_create_state.dart';

class PostCreateCubit extends Cubit<PostCreateState> {
  final PostRepo postRepository;
  final CategoryRepository categoryRepository;
  final ProvinceRepo provinceRepository;
  final WardRepo wardRepository;
  PostCreateCubit({required this.postRepository, required this.categoryRepository, required this.provinceRepository, required this.wardRepository})
    : super(PostCreateState());

  Future<void> fetchCategory() async {
    try {
      final result = await categoryRepository.getAllCategory();
      if (result.isSuccess) {
        final categories = List<Category>.from(result.content ?? []);
        emit(state.copyWith(categories: categories, rebuild: state.rebuild + 1));
      }
    } catch (_) {}
  }

  Future<void> fetchProvinces() async {
    try {
      final res = await provinceRepository.getProvinces();
      if (res.isSuccess) {
        emit(state.copyWith(provinces: res.data, rebuild: state.rebuild + 1));
      }
    } catch (_) {}
  }

  Future<void> fetchWards({required String provinceCode}) async {
    try {
      final res = await wardRepository.getWards(provinceCodeId: provinceCode);
      if (res.isSuccess) {
        emit(state.copyWith(wards: res.data, rebuild: state.rebuild + 1));
      }
    } catch (_) {}
  }

  void toggleCategory(Category category) {
    final updated = List<Category>.from(state.subCategories);
    final exists = updated.any((c) => c.id == category.id);
    if (exists) {
      updated.removeWhere((c) => c.id == category.id);
    } else {
      updated.add(category);
    }
    emit(
      state.copyWithNullable(
        subCategories: updated,
        rebuild: state.rebuild + 1,
        provinceSelectedCached: state.provinceSelectedCached,
        wardSelectedCached: state.wardSelectedCached,
        provinceSelected: state.provinceSelected,
        wardSelected: state.wardSelected,
      ),
    );
  }

  void setNullSubCategories() {
    emit(
      state.copyWithNullable(
        subCategories: null,
        rebuild: state.rebuild + 1,
        provinceSelectedCached: state.provinceSelectedCached,
        wardSelectedCached: state.wardSelectedCached,
        provinceSelected: state.provinceSelected,
        wardSelected: state.wardSelected,
      ),
    );
  }

  void setSelectedCategories(List<Category> categories) {
    emit(
      state.copyWithNullable(
        selectedCategories: categories,
        rebuild: state.rebuild + 1,
        provinceSelectedCached: state.provinceSelectedCached,
        wardSelectedCached: state.wardSelectedCached,
        provinceSelected: state.provinceSelected,
        wardSelected: state.wardSelected,
      ),
    );
  }

  void selectProvinceCache(ProvinceModel? province) {
    emit(
      state.copyWithNullable(
        provinceSelected: state.provinceSelected,
        wardSelected: state.wardSelected,
        wards: [],
        rebuild: state.rebuild + 1,
        provinceSelectedCached: province,
        wardSelectedCached: null,
      ),
    );
    if (province?.code != null && province!.code!.isNotEmpty) {
      fetchWards(provinceCode: province.code!);
    }
  }

  void selectWardCache(WardModel? ward) {
    emit(
      state.copyWithNullable(
        wardSelected: ward,
        provinceSelected: state.provinceSelected,
        rebuild: state.rebuild + 1,
        provinceSelectedCached: state.provinceSelectedCached,
        wardSelectedCached: ward,
      ),
    );
  }

  void saveLocation(ProvinceModel? province, WardModel? ward) {
    emit(
      state.copyWithNullable(
        provinceSelectedCached: province,
        wardSelectedCached: ward,
        provinceSelected: province,
        wardSelected: ward,
        rebuild: state.rebuild + 1,
      ),
    );
  }

  void selectUserPayment(UserPaymentModel? userPayment) {
    emit(state.copyWith(userPaymentSelected: userPayment, rebuild: state.rebuild + 1));
  }

  Future<void> createPost({
    required String title,
    required String description,
    required double price,
    required String phone,
    required String address,
    required List<XFile> images,
    required BuildContext context,
  }) async {
    if (title.isEmpty || description.isEmpty || price <= 0 || phone.isEmpty || address.isEmpty) {
      Fluttertoast.showToast(msg: 'Vui lòng nhập đầy đủ thông tin', backgroundColor: Colors.red);
      return;
    }
    if (state.userPaymentSelected == null) {
      Fluttertoast.showToast(msg: 'Vui lòng chọn gói đăng', backgroundColor: Colors.red);
      return;
    }
    final validatePhone = AppValidators.phone(phone);
    if (validatePhone != null) {
      Fluttertoast.showToast(msg: validatePhone, backgroundColor: Colors.red);
      return;
    }
    if (images.isEmpty) {
      Fluttertoast.showToast(msg: 'Vui lòng chọn ít nhất 1 ảnh', backgroundColor: Colors.red);
      return;
    }
    if (state.selectedCategories.isEmpty) {
      Fluttertoast.showToast(msg: 'Vui lòng chọn danh mục', backgroundColor: Colors.red);
      return;
    }
    emit(state.copyWith(isSubmitting: true));

    final user = await SqliteHelper.getUserSql();

    PostCreateRequest request = PostCreateRequest(
      title: title,
      description: description,
      price: price,
      phoneNumber: phone,
      address: address,
      userId: user?.id,
      paymentId: state.userPaymentSelected?.id,
    );

    if (state.selectedCategories.isNotEmpty) {
      request.categories = state.selectedCategories.map((e) => e.id).toList();
    }

    if (state.provinceSelected != null) {
      request.provinceCode = state.provinceSelected?.code;
    }
    if (state.wardSelected != null) {
      request.wardCode = state.wardSelected?.code;
      request.address = '$address, ${state.provinceSelected?.name}, ${state.wardSelected?.name}';
    }
    if (images.isNotEmpty) {
      request.images = images;
    }

    final result = await postRepository.createPost(request);
    emit(state.copyWith(isSubmitting: false));
    if (result) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Đăng bài thành công', backgroundColor: Colors.green);
    }
  }
}

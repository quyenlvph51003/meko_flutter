import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meko_project/common/enum_common.dart';
import 'package:meko_project/models/body/category/category_model.dart';
import 'package:meko_project/models/body/location/province_model.dart';
import 'package:meko_project/models/body/location/ward_model.dart';
import 'package:meko_project/models/body/post/listing_item_model.dart';
import 'package:meko_project/repository/category/category_repo.dart';
import 'package:meko_project/repository/post/post_repo.dart';
import 'package:meko_project/repository/location/province_repo.dart';
import 'package:meko_project/repository/location/ward_repo.dart';
import 'package:meko_project/repository/post/post_update_request.dart';

part 'post_update_state.dart';

class PostUpdateCubit extends Cubit<PostUpdateState> {
  final PostRepo postRepository;
  final CategoryRepository categoryRepository;
  final ProvinceRepo provinceRepository;
  final WardRepo wardRepository;
  PostUpdateCubit({required this.postRepository, required this.categoryRepository, required this.provinceRepository, required this.wardRepository})
    : super(PostUpdateState());

  void init(int id) {
    fetchPost(id);
  }

  void toggleCategory(Category category) {
    final updated = List<Category>.from(state.subCategories ?? []);
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

  ///set null subCategories
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

  ///set selectedCategories
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

  //fetch Post
  Future<void> fetchPost(int id) async {
    emit(state.copyWith(isLoading: true));
    try {
      final post = await postRepository.getPostDetail(id: id);
      if (post.isSuccess) {
        emit(state.copyWith(isLoading: false, listing: post.data, rebuild: state.rebuild + 1));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  //fetch Category
  Future<void> fetchCategory() async {
    try {
      final result = await categoryRepository.getAllCategory();
      if (result.isSuccess) {
        final categories = List<Category>.from(result.content ?? []);
        emit(state.copyWith(categories: categories, rebuild: state.rebuild + 1));
      }
    } catch (e) {
      print(e);
    }
  }

  //fetch Provinces
  Future<void> fetchProvinces() async {
    try {
      final res = await provinceRepository.getProvinces();
      if (res.isSuccess) {
        emit(state.copyWith(provinces: res.data, rebuild: state.rebuild + 1));
      }
    } catch (e) {
      // ignore
    }
  }

  //fetch Wards by province code
  Future<void> fetchWards({required String provinceCode}) async {
    try {
      final res = await wardRepository.getWards(provinceCodeId: provinceCode);
      if (res.isSuccess) {
        emit(state.copyWith(wards: res.data, rebuild: state.rebuild + 1));
      }
    } catch (e) {
      // ignore
    }
  }

  void selectProvinceCache(ProvinceModel? province) {
    // reset ward when province changes
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

  Future<void> updateStatusPost({required PostStatus status, required BuildContext context}) async {
    final result = await postRepository.updatePostStatus(postId: state.listing?.id ?? 0, status: status);
    if (result) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Cập nhật trạng thái thành công', backgroundColor: Colors.green);
    }
  }

  ///update post

  Future<void> updatePost({
    required String title,
    required String description,
    required double price,
    required String phone,
    required String address,
    required List<XFile> images,
    required List<String> removedImageUrls,
    required BuildContext context,
  }) async {
    if (title.isEmpty || description.isEmpty || price <= 0 || phone.isEmpty || address.isEmpty) {
      Fluttertoast.showToast(msg: 'Vui lòng nhập đầy đủ thông tin', backgroundColor: Colors.red);
      return;
    }
    // final categories=state.selectedCategories??state.listing.categories;
    emit(state.copyWith(isLoadingUpdate: true));
    PostUpdateRequest request = PostUpdateRequest(
      postId: state.listing?.id,
      title: title,
      description: description,
      price: price,
      phoneNumber: phone,
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

    if (removedImageUrls.isNotEmpty) {
      request.oldImages = removedImageUrls;
    }
    final result = await postRepository.updatePost(request);
    if (result) {
      emit(state.copyWith(isLoadingUpdate: false));
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Cập nhật thành công', backgroundColor: Colors.green);
    }
  }
}

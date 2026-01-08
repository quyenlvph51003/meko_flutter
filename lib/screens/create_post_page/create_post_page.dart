import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/models/body/category/category_model.dart';
import 'package:meko_project/models/body/paymnent/user_payment_model.dart';
import 'package:meko_project/repository/category/category_repo.dart';
import 'package:meko_project/repository/location/province_repo.dart';
import 'package:meko_project/repository/location/ward_repo.dart';
import 'package:meko_project/repository/post/post_repo.dart';
import 'package:meko_project/routers/app_router_paths.dart';
import 'package:meko_project/screens/create_post_page/post_create_vm/post_create_cubit.dart';
import 'package:meko_project/widget/app_button/app_button.dart';
import 'package:meko_project/widget/app_button/app_button_common.dart';

class PostCreateScreen extends StatefulWidget {
  const PostCreateScreen({super.key});

  @override
  State<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  List<XFile> _images = [];

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _images.add(file);
      });
    }
  }

  void _removeImage(XFile file) {
    setState(() {
      _images.remove(file);
    });
  }

  void _showBottomFilterLocation(BuildContext context, {required bool isCheckProvince}) {
    showModalBottomSheet(
      isDismissible: true,
      backgroundColor: Colors.white,
      barrierColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (ctx) {
        return BlocProvider.value(
          value: context.read<PostCreateCubit>(),
          child: BlocBuilder<PostCreateCubit, PostCreateState>(
            builder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(ctx);
                              },
                              child: Icon(Icons.cancel, size: 25, color: Colors.black),
                            ),
                          ),
                          SafeArea(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(isCheckProvince ? 'Tỉnh thành' : 'Xã phường', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey.withOpacity(0.5), thickness: 1, endIndent: 0),
                    if (state.provinces.isNotEmpty && isCheckProvince)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.provinces.length,
                            itemBuilder: (cont, index) {
                              final item = state.provinces[index];
                              return RadioListTile(
                                value: item,
                                groupValue: state.provinceSelected,
                                onChanged: (value) {
                                  if (value != null) {
                                    context.read<PostCreateCubit>().selectProvinceCache(value);
                                    Navigator.pop(ctx);
                                  }
                                },
                                title: Text(item.name ?? ''),
                              );
                            },
                          ),
                        ),
                      ),
                    if (state.wards.isNotEmpty && !isCheckProvince)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.wards.length,
                            itemBuilder: (cont, index) {
                              final item = state.wards[index];
                              return RadioListTile(
                                value: item,
                                groupValue: state.wardSelected,
                                onChanged: (value) {
                                  if (value != null) {
                                    context.read<PostCreateCubit>().selectWardCache(value);
                                    Navigator.pop(ctx);
                                  }
                                },
                                title: Text(item.name ?? ''),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showBottomLocation(BuildContext context) {
    showModalBottomSheet(
      isDismissible: true,
      backgroundColor: Colors.white,
      barrierColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (ctx) {
        return BlocProvider.value(
          value: context.read<PostCreateCubit>(),
          child: BlocBuilder<PostCreateCubit, PostCreateState>(
            builder: (context, state) {
              final vm = context.read<PostCreateCubit>();
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(ctx),
                              child: Icon(Icons.cancel, size: 25, color: Colors.black),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text('Chọn Khu vực', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey.withOpacity(0.5), thickness: 1),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.read<PostCreateCubit>().fetchProvinces();
                              _showBottomFilterLocation(context, isCheckProvince: true);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400, width: 1.5),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.place, color: AppColor.cMain),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${state.provinceSelectedCached?.name ?? 'Chọn tỉnh/thành phố'}',
                                      style: TextStyle(color: Colors.black87),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: () {
                              if (state.provinceSelectedCached != null) {
                                _showBottomFilterLocation(context, isCheckProvince: false);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                color: state.provinceSelectedCached == null ? Colors.grey.shade200 : Colors.white,
                                border: Border.all(color: Colors.grey.shade400, width: 1.5),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.place, color: AppColor.cMain),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${state.wardSelectedCached?.name ?? 'Chọn xã/phường'}',
                                      style: TextStyle(color: Colors.black87),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          AppButton(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                              decoration: BoxDecoration(
                                color: (state.provinceSelectedCached == null || state.wardSelectedCached == null)
                                    ? Colors.grey.shade100
                                    : AppColor.cMain,
                                border: Border.all(color: Colors.grey.shade400, width: 1.5),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  'Tiếp tục',
                                  style: TextStyle(
                                    color: (state.provinceSelectedCached == null || state.wardSelectedCached == null) ? Colors.black : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              vm.saveLocation(state.provinceSelectedCached, state.wardSelectedCached);
                              Navigator.pop(ctx);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showBottomCategories(BuildContext context) {
    showModalBottomSheet(
      isDismissible: true,
      backgroundColor: Colors.white,
      barrierColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (ctx) {
        return BlocProvider.value(
          value: context.read<PostCreateCubit>(),
          child: BlocBuilder<PostCreateCubit, PostCreateState>(
            builder: (context, state) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            child: GestureDetector(
                              onTap: () => Navigator.pop(ctx),
                              child: Icon(Icons.cancel, size: 25, color: Colors.black),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text('Danh mục', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey.withOpacity(0.5), thickness: 1),
                    if (state.categories.isNotEmpty)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: state.categories.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 0),
                            itemBuilder: (cont, index) {
                              final item = state.categories[index];
                              return CheckboxListTile(
                                value: state.subCategories.any((c) => c.id == item.id),
                                activeColor: AppColor.cMain,
                                checkColor: Colors.white,
                                onChanged: (_) {
                                  context.read<PostCreateCubit>().toggleCategory(item);
                                },
                                title: Text(item.name),
                              );
                            },
                          ),
                        ),
                      ),
                    Visibility(
                      visible: state.subCategories.isNotEmpty,
                      child: AppButton(
                        onTap: () {
                          context.read<PostCreateCubit>().setSelectedCategories(state.subCategories);
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(color: AppColor.cMain, borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: const Text('Lưu', style: TextStyle(color: Colors.white, fontSize: 16)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Tạo bài viết', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.cMain,
      ),
      body: BlocProvider(
        create: (context) => PostCreateCubit(
          postRepository: getIt<PostRepo>(),
          categoryRepository: getIt<CategoryRepository>(),
          provinceRepository: getIt<ProvinceRepo>(),
          wardRepository: getIt<WardRepo>(),
        )..fetchProvinces(),
        child: BlocBuilder<PostCreateCubit, PostCreateState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ảnh', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 110,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.add_a_photo, size: 30, color: Colors.black54),
                          ),
                        ),
                        const SizedBox(width: 8),
                        for (var file in _images)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(File(file.path), width: 100, height: 100, fit: BoxFit.cover),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => _removeImage(file),
                                    child: const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.red,
                                      child: Icon(Icons.close, size: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Tiêu đề',
                      labelStyle: TextStyle(color: AppColor.cGray),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.cMain, width: 1.0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Danh mục', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 30,
                    child: Center(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              context.read<PostCreateCubit>().fetchCategory();
                              context.read<PostCreateCubit>().setNullSubCategories();
                              _showBottomCategories(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: AppColor.cGray.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(10)),
                              child: Icon(Icons.add, color: AppColor.cMain),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ListView.separated(
                              itemCount: state.selectedCategories.length,
                              separatorBuilder: (context, index) => const SizedBox(width: 8),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                final Category cat = state.selectedCategories[index];
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: AppColor.cMain, borderRadius: BorderRadius.circular(10)),
                                  child: Text(cat.name, style: const TextStyle(color: Colors.white)),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Mô tả',
                      labelStyle: TextStyle(color: AppColor.cGray),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.cMain, width: 1.0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Giá',
                      labelStyle: TextStyle(color: AppColor.cGray),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.cMain, width: 1.0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Số điện thoại',
                      labelStyle: TextStyle(color: AppColor.cGray),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.cMain, width: 1.0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Độ mới của sản phẩm', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: state.oldProductPercent.toDouble(),
                          min: 1,
                          max: 100,
                          divisions: 99,
                          activeColor: AppColor.cMain,
                          inactiveColor: Colors.grey.shade300,
                          label: '${state.oldProductPercent}%',
                          onChanged: (value) {
                            context.read<PostCreateCubit>().setOldProductPercent(value.toInt());
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColor.cMain,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${state.oldProductPercent}%',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Khu vực', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _showBottomLocation(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400, width: 1.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.place, color: AppColor.cMain),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${state.provinceSelected?.name ?? ''} • ${state.wardSelected?.name ?? ''}',
                              style: TextStyle(color: Colors.black87),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Địa chỉ chi tiết',
                      labelStyle: TextStyle(color: AppColor.cGray),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.cMain, width: 1.0),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Gói đăng', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.of(context).pushNamed(AppRouterPaths.createPurcharsePost);
                          if (result != null) {
                            context.read<PostCreateCubit>().selectUserPayment(result as UserPaymentModel);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppColor.cGray.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(10)),
                          child: Icon(Icons.add, color: AppColor.cMain),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (state.userPaymentSelected != null)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColor.cMain.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColor.cMain, width: 1),
                            ),
                            child: Text(
                              '${state.userPaymentSelected?.packageName ?? ''}\nHạn sử dụng: ${state.userPaymentSelected?.durationUsed ?? 0} ngày',
                              style: TextStyle(fontSize: 14, color: AppColor.cMain),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  AppButtonCommon(
                    text: 'Đăng bài',
                    isLoading: state.isSubmitting ?? false,
                    backgroundColor: AppColor.cMain,
                    onPressed: () async {
                      context.read<PostCreateCubit>().createPost(
                        title: _titleController.text,
                        description: _descriptionController.text,
                        price: double.tryParse(_priceController.text) ?? 0,
                        phone: _phoneController.text,
                        address: _addressController.text,
                        images: _images,
                        context: context,
                      );
                    },
                  ),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: AppButton(
                  //     child: Container(
                  //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  //       decoration: BoxDecoration(color: AppColor.cMain, borderRadius: BorderRadius.circular(15)),
                  //       child: Center(
                  //         child: (state.isSubmitting ?? false)
                  //             ? CircularProgressIndicator(color: Colors.white, backgroundColor: Colors.grey.withValues(alpha: 0.5))
                  //             : Text('Đăng bài', style: TextStyle(color: Colors.white, fontSize: 16)),
                  //       ),
                  //     ),
                  //     onTap: () {
                  //       context.read<PostCreateCubit>().createPost(
                  //         title: _titleController.text,
                  //         description: _descriptionController.text,
                  //         price: double.tryParse(_priceController.text) ?? 0,
                  //         phone: _phoneController.text,
                  //         address: _addressController.text,
                  //         images: _images,
                  //         context: context,
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

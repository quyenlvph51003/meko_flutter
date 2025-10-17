import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/consts/app_dimens.dart';
import 'package:meko_project/consts/app_images.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/repository/auth/auth_repo.dart';
import 'package:meko_project/screens/sign_up_page/sign_up_vm/sign_up_cubit.dart';
import 'package:meko_project/screens/sign_up_page/sign_up_vm/sign_up_state.dart';
import 'package:meko_project/widget/app_button/app_button_common.dart';
import 'package:meko_project/widget/app_text_field/app_text_field.dart';
import 'package:meko_project/widget/app_validators/app_validators.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key, required this.onSuccess, required this.onBackToLogin});

  final void Function() onSuccess;
  final void Function() onBackToLogin;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpCubit(authRepository: getIt<AuthRepository>()),
      child: SignUpPageView(onSuccess: onSuccess, onBackToLogin: onBackToLogin),
    );
  }
}

class SignUpPageView extends StatefulWidget {
  SignUpPageView({super.key, required this.onSuccess, required this.onBackToLogin});
  void Function() onSuccess;
  void Function() onBackToLogin;
  @override
  State<SignUpPageView> createState() => SignUpPageViewState();
}

class SignUpPageViewState extends State<SignUpPageView> {
  late SignUpCubit vm;

  @override
  void initState() {
    super.initState();
    vm = context.read<SignUpCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listenWhen: (p, c) {
        return p.message != c.message || p.isSuccess != c.isSuccess;
      },
      listener: (context, state) {
        if (state.isSuccess == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message!),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
          return;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đăng ký thành công!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          widget.onSuccess.call();
          return;
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F6FF),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),
                Row(
                  children: [
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        widget.onBackToLogin.call();
                      },
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: Icon(Icons.arrow_back, size: 24, color: Colors.black87),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                Stack(
                  children: [
                    SizedBox(
                      width: AppDimens.getWidth(context),
                      height: AppDimens.getHeight(context),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            Image.asset(AppImages.img_splash, height: 120, fit: BoxFit.fitHeight),
                            const SizedBox(height: 16),
                            const Text(
                              'Đăng ký',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tạo tài khoản Meko để bắt đầu trải nghiệm',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 32),

                            Row(
                              children: [
                                Text(
                                  'Họ và tên',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.cGray,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Text('*', style: TextStyle(color: AppColor.cError)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            AppEditText(
                              controller: vm.state.userName,
                              hintText: 'Nhập họ và tên',
                              textInputAction: TextInputAction.next,
                              prefixIcon: const Icon(Icons.person_outline, size: 20),
                              validator: (v) {
                                return (v == null || v.trim().isEmpty)
                                    ? 'Vui lòng nhập họ tên'
                                    : null;
                              },
                              focusedBorderColor: AppColor.color8,
                            ),

                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Text(
                                  'Email',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.cGray,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Text('*', style: TextStyle(color: AppColor.cError)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            AppEditText(
                              controller: vm.state.emailCtrl,
                              hintText: 'Nhập email của bạn',
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              prefixIcon: const Icon(Icons.email_outlined, size: 20),
                              validator: AppValidators.email,
                              focusedBorderColor: AppColor.color8,
                            ),

                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Text(
                                  'Mật khẩu',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColor.cGray,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Text('*', style: TextStyle(color: AppColor.cError)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            AppEditText(
                              controller: vm.state.passwordCtrl,
                              hintText: 'Nhập mật khẩu',
                              obscureText: true,
                              textInputAction: TextInputAction.next,
                              prefixIcon: const Icon(Icons.lock_outline, size: 20),
                              validator: AppValidators.password,
                              focusedBorderColor: AppColor.color8,
                            ),
                            const SizedBox(height: 8),
                            BlocBuilder<SignUpCubit, SignUpState>(
                              buildWhen: (p, c) {
                                return p.acceptedTerms != c.acceptedTerms;
                              },
                              builder: (context, state) {
                                return Row(
                                  children: [
                                    Checkbox(
                                      value: state.acceptedTerms,
                                      onChanged: (v) {
                                        vm.toggleTerms(v ?? false);
                                        return;
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    const Expanded(
                                      child: Text(
                                        'Tôi đồng ý với Điều khoản sử dụng và Chính sách bảo mật',
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            BlocBuilder<SignUpCubit, SignUpState>(
                              buildWhen: (p, c) {
                                return p.isLoading != c.isLoading;
                              },
                              builder: (context, state) {
                                return AppButtonCommon(
                                  text: 'Tạo tài khoản',
                                  isLoading: state.isLoading,
                                  onPressed: () async {
                                    vm.register();
                                  },
                                  type: AppButtonType.primary,
                                  size: AppButtonSize.large,
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            AppButtonCommon(
                              text: 'Đã có tài khoản? Đăng nhập',
                              onPressed: () async {
                                widget.onBackToLogin.call();
                              },
                              type: AppButtonType.outlined,
                              size: AppButtonSize.large,
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

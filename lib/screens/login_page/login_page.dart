import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/consts/app_dimens.dart';
import 'package:meko_project/consts/app_images.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/repository/auth_repository/auth_repo.dart';
import 'package:meko_project/widget/app_button/app_button.dart';
import 'package:meko_project/widget/app_button/app_button_common.dart';
import 'package:meko_project/widget/app_text_field/app_text_field.dart';
import 'package:meko_project/widget/app_validators/app_validators.dart';

import 'login_vm/login_cubit.dart';
import 'login_vm/login_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key, this.showBack = true}) : super(key: key);
  final bool showBack;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(
        authRepository: getIt<AuthRepository>(),
      ),
      child:  LoginPageView(showBack: showBack),
    );
  }
}

class LoginPageView extends StatefulWidget {
  const LoginPageView({super.key,required this.showBack});
  final bool showBack;
  @override
  State<LoginPageView> createState() => _LoginPageViewState();
}

class _LoginPageViewState extends State<LoginPageView> {

  late LoginCubit vm;

  @override
  void initState() {
    super.initState();
     vm = context.read<LoginCubit>();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đăng nhập thành công!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          Future.delayed(const Duration(milliseconds: 500), () {
            if (context.mounted) Navigator.of(context).pop(true);
          });
        }
      },
      child: Scaffold(
        appBar: widget.showBack
            ? AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFFF2F6FF),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          title: const Text('Đăng nhập'),
          centerTitle: true,
        )
            : null,
        backgroundColor: const Color(0xFFF2F6FF),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                SizedBox(
                  width: AppDimens.getWidth(context),
                  height: AppDimens.getWidth(context),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 100),
                        Image.asset(
                          AppImages.img_splash,
                          height: 120,
                          fit: BoxFit.fitHeight,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Đăng nhập',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Chào mừng bạn quay trở lại Meko!',
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
                          controller: vm.state.usernameCtrl,
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
                          textInputAction: TextInputAction.done,
                          prefixIcon: const Icon(Icons.lock_outline, size: 20),
                          validator: AppValidators.password,
                          focusedBorderColor: AppColor.color8,
                          onSubmitted: (_) {
                            vm.login();
                          },
                        ),

                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: AppButton(
                            onTap: () {
                              print('Quên mật khẩu');
                            },
                            child: const Text(
                              'Quên mật khẩu?',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Login Button
                        BlocBuilder<LoginCubit, LoginState>(
                          builder: (context, state) {
                            return AppButtonCommon(
                              text: 'Đăng nhập',
                              isLoading: state.isLoading,
                              onPressed: () {
                                return vm.login();
                              },
                              type: AppButtonType.primary,
                              size: AppButtonSize.large,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        AppButtonCommon(
                          text: 'Đăng ký tài khoản',
                          onPressed: () async {
                            print('Navigate to register');
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
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/consts/app_images.dart';
import 'package:meko_project/widget/app_button/app_button.dart';
import 'package:meko_project/widget/app_button/app_button_common.dart';
import 'package:meko_project/widget/app_text_field/app_text_field.dart';
import 'package:meko_project/widget/app_validators/app_validators.dart';

import 'login_vm/login_cubit.dart';
import 'login_vm/login_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return LoginCubit();
      },
      child: const LoginPageView(),
    );
  }
}

class LoginPageView extends StatelessWidget {
  const LoginPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
        } else if (!state.isLoading && state.errorMessage == null) {
          final email = state.usernameCtrl.text.trim();
          if (email.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đăng nhập thành công!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );

            Future.delayed(const Duration(seconds: 1), () {
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/home');
              }
            });
          }
        }
      },
      child: Scaffold(
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
                  width: screenWidth,
                  height: screenHeight,
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
                            Text(
                              '*',
                              style: TextStyle(color: AppColor.cError),
                            ),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(height: 8),

                        AppEditText(
                          controller: cubit.state.usernameCtrl,
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
                            Text(
                              '*',
                              style: TextStyle(color: AppColor.cError),
                            ),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(height: 8),

                        AppEditText(
                          controller: cubit.state.passwordCtrl,
                          hintText: 'Nhập mật khẩu',
                          obscureText: true,
                          textInputAction: TextInputAction.done,
                          prefixIcon: const Icon(Icons.lock_outline, size: 20),
                          validator: AppValidators.password,
                          focusedBorderColor: AppColor.color8,
                          onSubmitted: (_) async {
                            await cubit.login();
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

                        BlocBuilder<LoginCubit, LoginState>(
                          builder: (context, state) {
                            return AppButtonCommon(
                              text: 'Đăng nhập',
                              isLoading: state.isLoading,
                              onPressed: () async {
                                await cubit.login();
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

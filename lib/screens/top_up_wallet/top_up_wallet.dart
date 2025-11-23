import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/domains/dependency_injection/service_locator.dart';
import 'package:meko_project/models/body/user/user_model.dart';
import 'package:meko_project/repository/payment/payment_repo.dart';
import 'package:meko_project/repository/user/user_repo.dart';
import 'package:meko_project/screens/top_up_wallet/vm/top_up_cubit.dart';
import 'package:meko_project/widget/app_button/app_button_common.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nạp tiền vào ví'),
        backgroundColor: AppColor.cMain,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
      ),
      body: BlocProvider(
        create: (_) => TopUpCubit(userRepo: getIt<UserRepo>(), paymentRepo: getIt<PaymentRepo>())..init(),
        child: BlocBuilder<TopUpCubit, TopUpState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _WalletHeader(user: state.user),
                    const SizedBox(height: 16),

                    if ((state.user?.pinWallet ?? '').isEmpty)
                      _BuildCreatePin(
                        pinController: _pinController,
                        confirmPinController: _confirmPinController,
                        onCreate: () => context.read<TopUpCubit>().createPin(pin: _pinController.text, confirm: _confirmPinController.text),
                        isSubmitting: state.isSubmitting,
                      ),

                    if ((state.user?.pinWallet ?? '').isNotEmpty)
                      _BuildTopUp(
                        amountController: _amountController,
                        selectedAmount: state.selectedAmount,
                        onSelectAmount: (v) {
                          _amountController.text = v.toStringAsFixed(0);
                          context.read<TopUpCubit>().selectAmount(v);
                        },
                        onTopUp: () {
                          final text = _amountController.text.trim();
                          final parsed = double.tryParse(text) ?? (state.selectedAmount ?? 0);
                          context.read<TopUpCubit>().topUp(amount: parsed, context: context);
                        },
                        isSubmitting: state.isSubmitting,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WalletHeader extends StatelessWidget {
  const _WalletHeader({required this.user});
  final UserModel? user;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Xin chào, ${user?.username ?? '---'}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('Số dư hiện tại: ${(user?.walletBalance ?? '')} VND', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

class _BuildCreatePin extends StatelessWidget {
  const _BuildCreatePin({required this.pinController, required this.confirmPinController, required this.onCreate, required this.isSubmitting});
  final TextEditingController pinController;
  final TextEditingController confirmPinController;
  final VoidCallback onCreate;
  final bool isSubmitting;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text('Tạo mã PIN ví', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: pinController,
          decoration: const InputDecoration(labelText: 'PIN (6 số)', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLength: 6,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: confirmPinController,
          decoration: const InputDecoration(labelText: 'Nhập lại PIN', border: OutlineInputBorder()),
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLength: 6,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isSubmitting ? null : onCreate,
            child: isSubmitting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Tạo ví'),
          ),
        ),
      ],
    );
  }
}

class _BuildTopUp extends StatelessWidget {
  const _BuildTopUp({
    required this.amountController,
    required this.selectedAmount,
    required this.onSelectAmount,
    required this.onTopUp,
    required this.isSubmitting,
  });
  final TextEditingController amountController;
  final double? selectedAmount;
  final void Function(double) onSelectAmount;
  final VoidCallback onTopUp;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    final quick = <double>[50000, 100000, 200000, 500000, 1000000];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        const Text('Chọn số tiền nạp', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: amountController,
          decoration: const InputDecoration(labelText: 'Số tiền (VND)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.payments)),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: quick
              .map((e) => ChoiceChip(label: Text('${e.toStringAsFixed(0)} VND'), selected: selectedAmount == e, onSelected: (_) => onSelectAmount(e)))
              .toList(),
        ),
        const SizedBox(height: 20),
        AppButtonCommon(
          text: 'Nạp tiền',
          isLoading: isSubmitting,
          onPressed: () async {
            onTopUp();
          },
        ),
        // SizedBox(
        //   width: double.infinity,
        //   child: ElevatedButton(
        //     onPressed: isSubmitting ? null : onTopUp,
        //     child: isSubmitting ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Nạp tiền'),
        //   ),
        // ),
      ],
    );
  }
}

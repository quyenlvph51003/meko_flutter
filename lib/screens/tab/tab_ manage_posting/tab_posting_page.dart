import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/screens/tab/tab_%20manage_posting/tab_posting_vm/tab_posting_cubit.dart';

class TabPostingView extends StatelessWidget {
  const TabPostingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return TabPostingCubit();
      },
      child: TabMagePostingPage(),
    );
  }
}

class TabMagePostingPage extends StatefulWidget {
  const TabMagePostingPage({super.key});

  @override
  State<TabMagePostingPage> createState() => _TabMagePostingPageState();
}

class _TabMagePostingPageState extends State<TabMagePostingPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.yellow, body: Column());
  }
}

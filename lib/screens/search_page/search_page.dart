import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meko_project/consts/app_colcor.dart';
import 'package:meko_project/screens/search_page/search_page_vm/search_page_cubit.dart';
import 'package:meko_project/widget/widget_helper.dart';

// ignore: must_be_immutable
class SearchPage<T> extends StatefulWidget {
  SearchPage({Key? key, required this.onSearch, required this.itemBuilder, this.hintText, required this.onSelected}) : super(key: key);

  final Future<List<T>> Function(String query) onSearch;
  final Widget Function(T item) itemBuilder;
  String? hintText;
  final void Function(T item) onSelected;

  @override
  State<SearchPage<T>> createState() => _SearchPageState<T>();
}

class _SearchPageState<T> extends State<SearchPage<T>> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit<T>(widget.onSearch),
      child: BlocBuilder<SearchCubit<T>, SearchPageState<T>>(
        builder: (context, state) {
          final vm = context.read<SearchCubit<T>>();
          return Scaffold(
            appBar: AppBar(
              title: TextField(
                controller: _controller,
                focusNode: _focusNode,
                autofocus: true,
                onChanged: (value) {
                  vm.search(value);
                },
                decoration: InputDecoration(
                  hintText: widget.hintText ?? 'Tìm kiếm...',
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20), // icon nhỏ hơn
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12), // giảm padding
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25), // bo góc nhỏ hơn
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: AppColor.cMain, width: 0.5), // viền mảnh hơn
                  ),
                ),
                style: TextStyle(fontSize: 14), // font nhỏ hơn cũng giúp TextField gọn hơn
              ),
            ),
            body: state.items.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      Expanded(child: Center(child: WidgetHelper.noDataListing())),
                    ],
                  )
                : ListView.builder(
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return widget.itemBuilder(item);
                    },
                  ),
          );
        },
      ),
    );
  }
}

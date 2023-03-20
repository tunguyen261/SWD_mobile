import 'dart:core';
import 'package:flutter/material.dart';
import 'package:garden_app/services/api_garden.dart';
import 'package:garden_app/widgets/garden_widget.dart';
import 'package:provider/provider.dart';
import '../models/garden_model.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  List<GardenModel> listGarden = [];
  Future<void> getGardenList() async {
    listGarden = await GardenAPI.getAllGarden();
    setState(() {});
  }

  @override
  void initState() {
    getGardenList();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getGardenList();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _isLoading = true;
        print("_isLoading $_isLoading");
        await getGardenList();
        _isLoading = false;
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: listGarden.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              controller: _scrollController,
              child: SafeArea(
                child: Column(
                  children: [
                    GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listGarden.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 1.6),
                        itemBuilder: (ctx, index) {
                          return ChangeNotifierProvider.value(
                              value: listGarden[index],
                              child: const GardenWidget());
                        }),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ),
    );
  }
}

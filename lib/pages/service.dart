import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:provider/provider.dart';

import '../models/garden_model.dart';
import '../services/api_garden.dart';
import '../widgets/garden_widget.dart';

class ServicePage extends StatefulWidget {
  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {


  HtmlEditorController controller = HtmlEditorController();

  @override
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
        title: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [
                Colors.white,
                Colors.yellow.shade500,
                Colors.white,
                Colors.yellow.shade500
              ],
            ).createShader(bounds);
          },
          child: Text(
            'Order History',
            style: TextStyle(
              fontSize: 25.0,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
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
import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garden_app/models/room_model.dart';
import 'package:garden_app/models/user_model.dart';
import 'package:garden_app/services/api_handler.dart';
import 'package:garden_app/widgets/room_widget.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class RoomOwnerPage extends StatefulWidget {
  const RoomOwnerPage({Key? key}) : super(key: key);

  @override
  State<RoomOwnerPage> createState() => _RoomOwnerPageState();
}

class _RoomOwnerPageState extends State<RoomOwnerPage> {
  final ScrollController _scrollController = ScrollController();
  List<Room> roomList = [];
  int limit = 10;
  bool _isLoading = false;

  Future<void> getRoomUser() async {
    roomList = await APIHandler.getDataRoom(limit: limit.toString());
    setState(() {});
  }

  @override
  void initState() {
    getRoomUser();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getRoomUser();
    _scrollController.addListener(() async {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _isLoading = true;
        print("_isLoading $_isLoading");
        limit += 10;
        await getRoomUser();
        _isLoading = false;
        //print("limit $limit");
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // elevation: 4,
        title: const Text('All Rooms'),
        backgroundColor: Colors.lightGreen,
      ),
      body: roomList.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: roomList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 0,
                              mainAxisSpacing: 5,
                              childAspectRatio: 0.6),
                      itemBuilder: (ctx, index) {
                        return ChangeNotifierProvider.value(
                            value: roomList[index], child: const RoomsWidget());
                      }),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
    );
  }
}

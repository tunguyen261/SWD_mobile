import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../consts/global_colors.dart';
import '../models/request_model.dart';

class RequestWidget extends StatefulWidget {
  const RequestWidget({Key? key}) : super(key: key);

  @override
  State<RequestWidget> createState() => _RequestWidgetState();
}

class _RequestWidgetState extends State<RequestWidget> {

  @override
  Widget build(BuildContext context) {

    final requestModelProvider = Provider.of<RequestModel>(context);
    Size size = MediaQuery.of(context).size;
    String _content = '';
    switch (requestModelProvider.status) {
      case 1:
        _content = 'Pending...';
        break;
      case 2:
        _content = 'Renting';
        break;
      case 3:
        _content = 'Cancel';
        break;
      default:
        break;
    }
    Icon getIcon() {
      switch(requestModelProvider.status) {
        case 1:
          return Icon(Icons.access_time, color: Colors.orange);
        case 2:
          return Icon(Icons.query_stats_outlined, color: Colors.blue);
        case 3:
          return Icon(Icons.task_alt_outlined, color: Colors.green);
        default:
          return Icon(Icons.error, color: Colors.grey);
      }
    }
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).cardColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(8.0),
          onTap: () {

          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                            text: 'Status: ',
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight:FontWeight.bold,
                                color: Color.fromRGBO(22, 216, 0, 1.0)),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "${_content}",
                                  style: TextStyle(
                                      color: lightTextColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)),
                            ]),
                      ),
                    ),
                    getIcon(),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  requestModelProvider.description.toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize:20,
                    fontStyle: FontStyle.italic,
                    //  fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}


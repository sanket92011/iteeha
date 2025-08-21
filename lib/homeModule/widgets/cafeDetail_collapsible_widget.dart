import 'package:flutter/material.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../../authModule/providers/auth_provider.dart';

class CollapsibleDropdown extends StatefulWidget {
  final String title;
  final List<dynamic> data;
  const CollapsibleDropdown({
    super.key,
    required this.title,
    required this.data,
  });

  @override
  CollapsibleDropdownState createState() => CollapsibleDropdownState();
}

class CollapsibleDropdownState extends State<CollapsibleDropdown> {
  bool _isExpanded = true;
  double dW = 0.0;
  double tS = 0.0;
  Map language = {};

  int day = DateTime.now().weekday - 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;

    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Column(
      children: <Widget>[
        GestureDetector(
          child: Row(
            children: [
              TextWidget(
                title: widget.title,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(width: dW * 0.02),
              Icon(
                color: Colors.black,
                _isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
              ),
            ],
          ),
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),
        if (_isExpanded)
          ListView.builder(
              shrinkWrap: true,
              itemCount: widget.data.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) => GestureDetector(
                      child: Container(
                    margin: EdgeInsets.only(right: dW * 0.28, top: dW * 0.035),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextWidget(
                          title: widget.data[i]['day'],
                          color: i == day
                              ? const Color(0xff434343)
                              : const Color(0xffBCBCBC),
                          fontWeight:
                              i == day ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 12,
                        )),
                        if (widget.data[i]['startTime'] != null &&
                            widget.data[i]['endTime'] != null &&
                            widget.data[i]['status'] != 'CLOSE')
                          TextWidget(
                            title:
                                '${convertToTime(widget.data[i]['startTime'])} - ${convertToTime(widget.data[i]['endTime'])}',
                            color: i == day
                                ? const Color(0xff434343)
                                : const Color(0xffBCBCBC),
                            fontWeight:
                                i == day ? FontWeight.w600 : FontWeight.w500,
                            fontSize: 12,
                          )
                        else
                          TextWidget(
                            title: language['closed'],
                            color: i == day
                                ? const Color(0xff434343)
                                : const Color(0xffBCBCBC),
                            fontWeight:
                                i == day ? FontWeight.w600 : FontWeight.w500,
                            fontSize: 12,
                          )
                      ],
                    ),
                  ))),

        // ...widget.data
        //     .map((timing) =>
        //      Container(
        //           margin: EdgeInsets.only(right: dW * 0.28, top: dW * 0.035),
        //           child: Row(
        //             children: [
        //               Expanded(
        //                   child: TextWidget(
        //                 title: timing['day'],
        //                 color: const Color(0xffBCBCBC),
        //                 fontWeight: FontWeight.w500,
        //                 fontSize: 12,
        //               )),
        //               TextWidget(
        //                 title:
        //                     '${convertToTime(timing['startTime'])} - ${convertToTime(timing['endTime'])}',
        //                 color: const Color(0xffBCBCBC),
        //                 fontWeight: FontWeight.w500,
        //                 fontSize: 12,
        //               )
        //             ],
        //           ),
        //         ))
        //     .toList()
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:iteeha_app/moreModule/models/faq_model.dart';

class FaqCollapsibleDropdown extends StatefulWidget {
  final Faq faq;
  const FaqCollapsibleDropdown({super.key, required this.faq});

  @override
  Faq_CollapsibleDropdownState createState() => Faq_CollapsibleDropdownState();
}

class Faq_CollapsibleDropdownState extends State<FaqCollapsibleDropdown> {
  bool _isExpanded = false;
  double dW = 0.0;
  double tS = 0.0;

  int day = DateTime.now().weekday - 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    return Column(
      children: <Widget>[
        GestureDetector(
          child: Row(
            children: [
              Expanded(
                child: TextWidget(
                  title: widget.faq.question,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff6B6C75),
                ),
              ),
              SizedBox(width: dW * 0.02),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: dW * 0.007, vertical: dW * 0.006),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xff5BCAEF).withOpacity(0.1),
                ),
                child: Icon(
                  color: const Color(0xff4F4D8B),
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                ),
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
          Wrap(
            children: [
              Container(
                padding: EdgeInsets.only(top: dW * 0.02),
                child: TextWidget(
                  title: widget.faq.answer,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: const Color(0xff84858E),
                ),
              )
            ],
          ),
        Container(
          margin: EdgeInsets.only(top: dW * 0.03, bottom: dW * 0.03),
          child: const Divider(
            thickness: 1,
            color: Color(0xffDBDBE3),
          ),
        ),
      ],
    );
  }
}

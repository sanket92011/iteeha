import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/colors.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/asset_svg_icon.dart';
import 'package:iteeha_app/common_widgets/custom_button.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:iteeha_app/dynamic_Link_api.dart';
import 'package:iteeha_app/navigation/navigators.dart';
import 'package:provider/provider.dart';

class ReferBottomSheetWidget extends StatefulWidget {
  const ReferBottomSheetWidget({
    super.key,
  });

  @override
  ReferBottomSheetWidgetState createState() => ReferBottomSheetWidgetState();
}

class ReferBottomSheetWidgetState extends State<ReferBottomSheetWidget> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;

  final List termsAndConditions = [
    'Offer valid only for new user',
    'Offer valid till 10 October',
    'Offer not valid on combo meals.'
  ];

  fetchData() async {}

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    final userId = Provider.of<AuthProvider>(context).user.id;

    return Container(
      padding: EdgeInsets.symmetric(
          vertical: dW * horizontalPaddingFactor,
          horizontal: dW * horizontalPaddingFactor),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
              title: language['offerDetails'],
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            GestureDetector(
                onTap: () => pop(),
                child: const AssetSvgIcon(
                  'cross_red',
                  color: Colors.black,
                )),
          ],
        ),
        SizedBox(height: dW * 0.05),
        Container(
          padding: EdgeInsets.only(bottom: dW * 0.06),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFFF4F4F4), width: 1),
            ),
          ),
          child: Image.asset(
            'assets/images/refer1_bg_new.png',
          ),
        ),
        SizedBox(height: dW * 0.07),
        TextWidget(
          title: language['referAFriend'],
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: const Color(0XFF434343),
        ),
        SizedBox(
          height: dW * 0.02,
        ),
        Text(
          language['referDescription'],
          style: const TextStyle(
              fontFamily: 'LT Superior',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color(0XFF434343),
              height: 1.5),
        ),
        SizedBox(
          height: dW * 0.08,
        ),
        TextWidget(
          title: language['terms&Condition'],
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: const Color(0XFF434343),
        ),
        SizedBox(
          height: dW * 0.04,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: termsAndConditions.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(left: dW * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: dW * 0.01),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 5,
                          color: Colors.black,
                        ),
                        SizedBox(width: dW * 0.02),
                        TextWidget(
                          title: termsAndConditions[index],
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: const Color(0XFF434343),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Container(
          margin: EdgeInsets.only(top: dW * 0.1, bottom: dW * 0.04),
          child: CustomButton(
            width: dW,
            height: dW * 0.135,
            radius: 8,
            isLoading: isLoading,
            buttonText: language['share'],
            buttonColor: buttonColor,
            buttonTextSyle: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontSize: tS * 18,
                  color: Colors.white,
                ),
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              await createAppLink(userId);
              setState(() {
                isLoading = false;
              });
            },
          ),
        ),
      ]),
    );
  }
}

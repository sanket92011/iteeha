import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/colors.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/asset_svg_icon.dart';
import 'package:iteeha_app/common_widgets/cached_image_widget.dart';
import 'package:iteeha_app/common_widgets/custom_button.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:iteeha_app/dynamic_Link_api.dart';
import 'package:iteeha_app/rewardsModule/models/offer_model.dart';
import 'package:iteeha_app/navigation/navigators.dart';
import 'package:provider/provider.dart';

class OffersBottomSheetWidget extends StatefulWidget {
  // final double keyboardHeight;

  final Offer offer;
  const OffersBottomSheetWidget({
    super.key,
    required this.offer,
    //  required this.keyboardHeight
  });

  @override
  OffersBottomSheetWidgetState createState() => OffersBottomSheetWidgetState();
}

class OffersBottomSheetWidgetState extends State<OffersBottomSheetWidget> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isLoading = false;
  List<String> selectedWeekdays = [];
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedImageWidget(
              widget.offer.image,
              width: dW,
              height: dW * 0.45,
            ),
          ),
        ),
        SizedBox(height: dW * 0.07),
        TextWidget(
          title: widget.offer.name,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        SizedBox(
          height: dW * 0.01,
        ),
        TextWidget(
          title: widget.offer.description,
        ),
        SizedBox(
          height: dW * 0.08,
        ),
        TextWidget(
          title: language['terms&Condition'],
          fontWeight: FontWeight.w500,
        ),
        SizedBox(
          height: dW * 0.02,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.offer.terms.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(left: dW * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        size: 5,
                      ),
                      SizedBox(
                        width: dW * 0.02,
                      ),
                      TextWidget(
                        title: widget.offer.terms[index],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: dW * 0.02,
                  ),
                ],
              ),
            );
          },
        ),
        if (widget.offer.type == 'Refer')
          Container(
            margin: EdgeInsets.only(top: dW * 0.1, bottom: dW * 0.04),
            child: CustomButton(
              width: dW,
              height: dW * 0.135,
              radius: 8,
              isLoading: isLoading,
              buttonText: language['share'],
              buttonColor: buttonColor,
              buttonTextSyle:
                  Theme.of(context).textTheme.displayLarge!.copyWith(
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

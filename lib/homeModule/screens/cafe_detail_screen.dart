import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iteeha_app/authModule/model/user_model.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/colors.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/asset_svg_icon.dart';
import 'package:iteeha_app/common_widgets/cached_image_widget.dart';
import 'package:iteeha_app/common_widgets/circular_loader.dart';
import 'package:iteeha_app/common_widgets/custom_button.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:iteeha_app/dynamic_Link_api.dart';
import 'package:iteeha_app/homeModule/models/cafe_model.dart';
import 'package:iteeha_app/homeModule/widgets/cafeDetail_carousel_widget.dart';
import 'package:iteeha_app/homeModule/widgets/cafeDetail_collapsible_widget.dart';
import 'package:iteeha_app/homeModule/widgets/cafeDetail_time_container.dart';
import 'package:iteeha_app/navigation/arguments.dart';
import 'package:iteeha_app/navigation/navigators.dart';
import 'package:iteeha_app/navigation/routes.dart';
import 'package:provider/provider.dart';

class CafeDetailScreen extends StatefulWidget {
  final CafeDetailScreenArguments args;

  const CafeDetailScreen({super.key, required this.args});

  @override
  State<CafeDetailScreen> createState() => _CafeDetailScreenState();
}

class _CafeDetailScreenState extends State<CafeDetailScreen> {
  //
  Map language = {};
  double dW = 0.0;
  double tS = 0.0;
  TextTheme get textTheme => Theme.of(context).textTheme;
  double distance = 0;
  bool isLoading = false;

  late Cafe cafe;
  late User user;

  @override
  void initState() {
    super.initState();
    user = Provider.of<AuthProvider>(context, listen: false).user;

    cafe = widget.args.cafe;
    if (user.coordinates != null && user.isLocationAllowed) {
      distance = Geolocator.distanceBetween(
              cafe.coordinates.latitude,
              cafe.coordinates.longitude,
              user.coordinates!.latitude,
              user.coordinates!.longitude) /
          1000;
    }
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          elevation: 0,
          leading: GestureDetector(
            onTap: () => pop(),
            child: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.black,
              size: 30,
            ),
          ),
          title: TextWidget(
            title: language['cafeDetails'],
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: dW * 0.04),
              child: GestureDetector(
                onTap: () async {
                  // setState(() {
                  //   isLoading = true;
                  // });
                  await createShareCafeLink(cafe.id);
                  // setState(() {
                  //   isLoading = false;
                  // });
                },
                child: const Icon(
                  Icons.share_outlined,
                  color: Color(0xff84858E),
                  size: 25,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: isLoading
              ? const Center(child: CircularLoader())
              : Column(
                  children: [
                    Expanded(
                        child: ListView(
                      children: [
                        Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    CafeDetailCarouselWidget(
                                      images: cafe.cafePhotos,
                                      cafe: cafe,
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            CafeDetailTimeContainer(
                                              cafe: cafe,
                                            ),
                                            const Positioned(
                                              top: -30,
                                              left: 0,
                                              right: 0,
                                              child:
                                                  AssetSvgIcon('cup_blue_new'),
                                            ),
                                          ]),
                                    )
                                  ],
                                ),
                                const Divider(
                                  color: Color(0xffD9D9D9),
                                  thickness: 1,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(
                                    dW * horizontalPaddingFactor,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          TextWidget(
                                            title: '${cafe.name}, ',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                          TextWidget(
                                            title: cafe.area,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: dW * 0.02,
                                      ),
                                      TextWidget(
                                        title: cafe.address,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: const Color(0xff848484),
                                      ),
                                      SizedBox(
                                        height: dW * 0.06,
                                      ),
                                      if (cafe.menu.isNotEmpty)
                                        TextWidget(
                                          title: language['menu'],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      if (cafe.menu.isNotEmpty)
                                        SizedBox(
                                          height: cafe.menu.length > 1
                                              ? dW * 0.058
                                              : dW * 0.02,
                                        ),
                                      GestureDetector(
                                        onTap: () => push(
                                            NamedRoute.allMenuScreen,
                                            arguments: AllMenuScreenArguments(
                                              cafe: cafe,
                                            )),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            if (cafe.menu.isNotEmpty &&
                                                cafe.menu.length > 1)
                                              Positioned(
                                                top: -10,
                                                left: 10,
                                                right: 10,
                                                child: Container(
                                                  height: dW * 0.4,
                                                  decoration: BoxDecoration(
                                                      color: white,
                                                      border: Border.all(
                                                        color: const Color(
                                                            0xffAAABB5),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                ),
                                              ),
                                            if (cafe.menu.isNotEmpty &&
                                                cafe.menu.length > 1)
                                              Positioned(
                                                top: -5,
                                                left: 5,
                                                right: 5,
                                                child: Container(
                                                  height: dW * 0.4,
                                                  decoration: BoxDecoration(
                                                      color: white,
                                                      border: Border.all(
                                                        color: const Color(
                                                            0xffAAABB5),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
                                                ),
                                              ),
                                            if (cafe.menu.isNotEmpty)
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: white,
                                                    border: Border.all(
                                                      color: const Color(
                                                          0xffAAABB5),
                                                      width: 1.2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.5)),
                                                height: dW * 0.4,
                                                width: dW * 0.33,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: CachedImageWidget(
                                                      cafe.menu[0]),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: dW * 0.02,
                                      ),
                                      if (cafe.menu.isNotEmpty)
                                        TextWidget(
                                          title:
                                              '${cafe.menu.length.toString()} Pages',
                                          color: const Color(0xff848484),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      SizedBox(height: dW * 0.06),
                                      CollapsibleDropdown(
                                          title: language['cafeTimings'],
                                          data: cafe.timings
                                          // .cast<Map<String, dynamic>>(),
                                          ),
                                      SizedBox(height: dW * 0.06),
                                      TextWidget(
                                        title: language['amenities'],
                                        fontWeight: FontWeight.w600,
                                      ),
                                      ...cafe.amenities.map(
                                        (amenities) => Container(
                                          margin: EdgeInsets.only(
                                              top: dW * 0.027, left: dW * 0.01),
                                          child: Row(
                                            children: [
                                              SvgPicture.network(
                                                amenities.svg,
                                                // width: dW * 0.04,
                                              ),
                                              SizedBox(
                                                width: dW * 0.02,
                                              ),
                                              TextWidget(
                                                title: amenities.name,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12,
                                                color: const Color(0xff848484),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )),
                    Container(
                      padding: EdgeInsets.only(
                          left: dW * horizontalPaddingFactor,
                          right: dW * horizontalPaddingFactor,
                          top: dW * 0.05,
                          bottom: dW * 0.1),
                      child: CustomButton(
                        width: dW,
                        height: dW * 0.13,
                        buttonColor: const Color(0xff272559),
                        radius: 8,
                        onPressed: () => navigateTo(cafe.coordinates),
                        buttonText: '',
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: dW * 0.02,
                                  ),
                                  const AssetSvgIcon(
                                      'direction_button_right_arrow'),
                                  SizedBox(
                                    width: dW * 0.02,
                                  ),
                                  TextWidget(
                                    title: language['getDirections'],
                                    color: white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ),
                            if (user.coordinates != null &&
                                user.isLocationAllowed)
                              TextWidget(
                                title: '${distance.toStringAsFixed(1)} km Away',
                                color: const Color(0xffACACAC),
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            SizedBox(
                              width: dW * 0.02,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
        ));
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iteeha_app/authModule/model/user_model.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/asset_svg_icon.dart';
import 'package:iteeha_app/common_widgets/circular_loader.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:iteeha_app/homeModule/models/cafe_model.dart';
import 'package:iteeha_app/rewardsModule/models/offer_model.dart';
import 'package:iteeha_app/homeModule/providers/cafe_provider.dart';
// import 'package:iteeha_app/homeModule/providers/cafe_provider.dart';
import 'package:iteeha_app/rewardsModule/providers/loyalty_provider.dart';
import 'package:iteeha_app/rewardsModule/providers/offers_provider.dart';
import 'package:iteeha_app/homeModule/widgets/cafe_widget.dart';
import 'package:iteeha_app/homeModule/widgets/carousel_widget.dart';
import 'package:iteeha_app/homeModule/widgets/loyaltyLevel_widget.dart';
import 'package:iteeha_app/homeModule/widgets/offer_widget.dart';
import 'package:iteeha_app/homeModule/widgets/offers_bottomSheet_widget.dart';
import 'package:iteeha_app/homeModule/widgets/total_saving_widget.dart';
import 'package:iteeha_app/navigation/arguments.dart';
import 'package:iteeha_app/navigation/navigators.dart';
import 'package:iteeha_app/navigation/routes.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../models/banner_model.dart';
import '../providers/banner_provider.dart';
import '../widgets/banner_widget.dart';
import '../widgets/refer_bottom_sheet_widget.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onIndexChanged;
  const HomeScreen({super.key, required this.onIndexChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //
  Map language = {};
  double dH = 0.0;
  bool isLoading = false;
  bool isLocationLoading = false;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme get textTheme => Theme.of(context).textTheme;

  List<String> imageList = [
    'assets/images/corousel/image1.png',
    'assets/images/corousel/image2.png',
    'assets/images/corousel/image3.png',
    'assets/images/corousel/image4.png',
  ];

  int currentBarIndex = 0;
  Cafe? selectedCafe;
  late User user;
  double distance = 0;
  DateTime now = DateTime.now();

  void offerBottomSheet(Offer offer) {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => Wrap(
        children: [
          OffersBottomSheetWidget(
            offer: offer,
          ),
        ],
      ),
    );
  }

  void referBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => Wrap(
        children: const [
          ReferBottomSheetWidget(),
        ],
      ),
    );
  }

  fetchCafes() async {
    late String coordString = '';
    if (user.coordinates != null) {
      coordString =
          [user.coordinates!.longitude, user.coordinates!.latitude].toString();
    }

    final response =
        await Provider.of<CafeProvider>(context, listen: false).fetchCafe(
      accessToken: user.accessToken,
      query: '&coordinates=$coordString&fetchNearby=true',
    );
    if (!response['success']) {
      showSnackbar(response['message']);
    }
  }

  fetchLoyaltyLevels() async {
    final response = await Provider.of<LoyaltyProvider>(context, listen: false)
        .fetchLoyaltyLevels(
      accessToken: user.accessToken,
    );
    if (!response['success']) {
      showSnackbar(response['message']);
    }
  }

  fetchOffers() async {
    final response =
        await Provider.of<OffersProvider>(context, listen: false).fetchOffers(
      accessToken: user.accessToken,
    );
    if (!response['success']) {
      showSnackbar(response['message']);
    }
  }

  List<BannerModel> banners = [];

  fetchAllBanner() async {
    setState(() {
      isLoading = true;
    });

    final response = await Provider.of<BannerProvider>(context, listen: false)
        .fetchAllBanner(
      accessToken: user.accessToken,
    );

    if (response['success']) {}
    setState(() {
      isLoading = false;
    });
  }

  Widget get shimmerLoader {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: dW * 0.1,
                height: dW * 0.02,
                color: Colors.white,
              ),
              SizedBox(
                width: dW * 0.01,
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: Colors.white,
              ),
            ],
          ),
          Container(
            width: 100,
            height: 10,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  checkAndGetLocationPermission() async {
    selectedCafe =
        Provider.of<CafeProvider>(context, listen: false).selectedCafe;

    // setState(() => isLoading = true);

    await handlePermissionsFunction();
    if (user.isLocationAllowed && selectedCafe == null) {
      if (await Permission.location.isGranted) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);

        await authProvider.fetchMyLocation();

        final coord = authProvider.user.coordinates;
        if (coord != null) {
          final User user =
              Provider.of<AuthProvider>(context, listen: false).user;
          String coordString = [coord.longitude, coord.latitude].toString();
          final response =
              await Provider.of<CafeProvider>(context, listen: false).fetchCafe(
                  accessToken: user.accessToken,
                  query: 'coordinates=$coordString');

          if (response['success']) {
            if (!user.isLocationAllowed) {
              Provider.of<AuthProvider>(context, listen: false)
                  .editProfile(body: {'isLocationAllowed': 'true'}, files: {});
            }
          }
        }
      }
    } else {
      return;
    }

    // setState(() => isLoading = false);
  }

  logout() async {
    Provider.of<AuthProvider>(context, listen: false).logout();
    pushAndRemoveUntil(NamedRoute.mobileNumberScreen);
  }

  locationFunc() async {
    setState(() => isLocationLoading = true);

    await checkAndGetLocationPermission();

    selectedCafe =
        Provider.of<CafeProvider>(context, listen: false).selectedCafe;

    if (selectedCafe != null &&
        user.coordinates != null &&
        user.isLocationAllowed) {
      distance = Geolocator.distanceBetween(
              selectedCafe!.coordinates.latitude,
              selectedCafe!.coordinates.longitude,
              user.coordinates!.latitude,
              user.coordinates!.longitude) /
          1000;
    }
    setState(() => isLocationLoading = false);
  }

  fetchTransactionCountsForLoyalty() async {
    final response = await Provider.of<LoyaltyProvider>(context, listen: false)
        .fetchTransactionCountsForLoyalty(
      accessToken: user.accessToken,
    );
    if (!response['success']) {
      showSnackbar(response['message']);
    }
  }

  init() async {
    setState(() {
      isLoading = true;
    });

    locationFunc();

    await fetchCafes();
    if (!user.isGuest) {
      await fetchLoyaltyLevels();
      await fetchTransactionCountsForLoyalty();

      await fetchOffers();
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    user = Provider.of<AuthProvider>(context, listen: false).user;

    init();
    fetchAllBanner();
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    dH = MediaQuery.of(context).size.height;

    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    selectedCafe = Provider.of<CafeProvider>(context).selectedCafe;
    final user = Provider.of<AuthProvider>(context).user;
    final cafes = Provider.of<CafeProvider>(context).cafes;
    final offers = Provider.of<OffersProvider>(context).alignedOffers;
    banners = Provider.of<BannerProvider>(context).banners;

    return Scaffold(
        body: SafeArea(
      child: isLoading
          ? const Center(child: CircularLoader())
          : Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: dW * 0.02),
                  padding: EdgeInsets.symmetric(horizontal: dW * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => push(NamedRoute.searchCafeScreen),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/store_location_new.png',
                                  scale: 1.8,
                                ),
                                SizedBox(width: dW * 0.005),
                                isLocationLoading
                                    ? shimmerLoader
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              TextWidget(
                                                title: selectedCafe != null
                                                    ? selectedCafe!.area
                                                    : language['selectACafe'],
                                                // 'Select A Store',
                                                fontWeight: FontWeight.w600,
                                              ),
                                              SizedBox(
                                                width: dW * 0.01,
                                              ),
                                              const Icon(
                                                Icons.keyboard_arrow_down,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                          if (selectedCafe != null &&
                                              user.coordinates != null &&
                                              user.isLocationAllowed)
                                            TextWidget(
                                              title:
                                                  '${distance.toStringAsFixed(1)} km away',
                                              color: const Color(0xffA3A2A2),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                            ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              // GestureDetector(
                              //   onTap: () {},
                              //   child: Container(
                              //     margin: EdgeInsets.only(right: dW * 0.04),
                              //     padding: EdgeInsets.symmetric(
                              //         horizontal: dW * 0.03,
                              //         vertical: dW * 0.015),
                              //     decoration: BoxDecoration(
                              //         border: Border.all(
                              //           color: greyBorderColor,
                              //         ),
                              //         borderRadius: BorderRadius.circular(35)),
                              //     child: Row(
                              //       children: [
                              //         Image.asset(
                              //           'assets/images/coin.png',
                              //           scale: 1.9,
                              //         ),
                              //         SizedBox(
                              //           width: dW * 0.02,
                              //         ),
                              //         const TextWidget(
                              //           title: '14',
                              //           fontSize: 16,
                              //           fontWeight: FontWeight.w600,
                              //           color: Color(0xff84858E),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),

                              GestureDetector(
                                  onTap: () =>
                                      push(NamedRoute.notificationScreen),
                                  child: const AssetSvgIcon('notification'))
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      SizedBox(
                        height: dH,
                        width: dW,
                        child: Image.asset(
                          'assets/images/homescreen_bg_new.png',
                          fit: BoxFit.cover,
                          width: dW,
                          // height: dH * 0.81,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: dW * horizontalPaddingFactor,
                          right: dW * horizontalPaddingFactor,
                          top: dW * horizontalPaddingFactor,
                        ),
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    TextWidget(
                                      title: now.hour < 12
                                          ? language['goodMorning']
                                          : now.hour < 17
                                              ? language['goodAfternoon']
                                              : language['goodEvening'],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                    TextWidget(
                                      title: user.isGuest
                                          ? user.fullName
                                          : ', ${user.fullName}',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                    // Text(
                                    //   user.fullName,
                                    //   style: textTheme.displayLarge!.copyWith(
                                    //     fontSize: tS * 16,
                                    //     color: const Color(0XFF434343),
                                    //   ),
                                    // )
                                  ],
                                ),
                                SizedBox(height: dW * 0.04),
                                user.isGuest
                                    ? GestureDetector(
                                        onTap: () =>
                                            push(NamedRoute.mobileNumberScreen),
                                        child: Image.asset(
                                            'assets/images/guest_loyalty_banner_new.png'),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          widget.onIndexChanged(3);
                                        },
                                        child: const LoyaltyLevelWidget()),
                                if (!user.isGuest && offers.isNotEmpty)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // SizedBox(
                                      //   height: dW * 0.08,
                                      // ),
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     widget.onIndexChanged(1);
                                      //   },
                                      //   child: TotalSavingWidget(),
                                      // ),
                                      if (offers.isNotEmpty) ...[
                                        SizedBox(height: dW * 0.1),
                                        TextWidget(
                                          title: language['exclusiveOffers'],
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                      SizedBox(height: dW * 0.04),
                                      // ListView.builder(
                                      //   shrinkWrap: true,
                                      //   itemCount: banners.length,
                                      //   physics: const BouncingScrollPhysics(),
                                      //   itemBuilder: (context, i) =>
                                      //       BannerWidget(
                                      //     key: ValueKey(banners[i].id),
                                      //     banner: banners[i],
                                      //   ),
                                      // ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: offers.length,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, i) =>
                                            GestureDetector(
                                          onTap: () =>
                                              offerBottomSheet(offers[i]),
                                          child: OfferWidget(
                                            key: ValueKey(offers[i].id),
                                            offer: offers[i],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: referBottomSheet,
                                        child: Image.asset(
                                          'assets/images/refer1_bg_new.png',
                                        ),
                                      ),
                                    ],
                                  ),
                                if (selectedCafe != null &&
                                    selectedCafe!.carouselphotos.isNotEmpty)
                                  Column(
                                    children: [
                                      SizedBox(height: dW * 0.1),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextWidget(
                                            title: language['photos'],
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          GestureDetector(
                                            onTap: () => push(NamedRoute
                                                .cafePhotosListScreen),
                                            child: Row(
                                              children: [
                                                TextWidget(
                                                  title: language['viewMore'],
                                                  fontSize: 13.5,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xffAAABB5),
                                                ),
                                                const Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Color(0xffAAABB5),
                                                  size: 18,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: dW * 0.04,
                                      ),
                                      CarouselWidget(
                                          photoList:
                                              selectedCafe!.carouselphotos),
                                    ],
                                  ),
                                SizedBox(
                                  height: dW * 0.1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextWidget(
                                      title: language['ourCafes'],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          push(NamedRoute.allCafesScreen),
                                      child: Row(
                                        children: [
                                          TextWidget(
                                            title: language['viewMore'],
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xffAAABB5),
                                          ),
                                          const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Color(0xffAAABB5),
                                            size: 18,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: dW * 0.04),
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: cafes.length,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, i) => GestureDetector(
                                    onTap: () => push(
                                        NamedRoute.cafeDetailScreen,
                                        arguments: CafeDetailScreenArguments(
                                            cafe: cafes[i])),
                                    child: CafeWidget(
                                      key: ValueKey(cafes[i].id),
                                      cafe: cafes[i],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    ));
  }
}

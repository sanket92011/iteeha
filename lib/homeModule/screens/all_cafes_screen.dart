import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/model/user_model.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/colors.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/circular_loader.dart';
import 'package:iteeha_app/common_widgets/empty_list_widget.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:iteeha_app/homeModule/models/cafe_model.dart';
import 'package:iteeha_app/homeModule/providers/cafe_provider.dart';
import 'package:iteeha_app/homeModule/widgets/cafe_widget.dart';
import 'package:iteeha_app/navigation/arguments.dart';
import 'package:iteeha_app/navigation/navigators.dart';
import 'package:iteeha_app/navigation/routes.dart';
import 'package:provider/provider.dart';

class AllCafesScreen extends StatefulWidget {
  const AllCafesScreen({super.key});

  @override
  State<AllCafesScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<AllCafesScreen>
    with TickerProviderStateMixin {
  //
  Map language = {};
  double dW = 0.0;
  double dH = 0.0;
  bool isLoading = false;
  bool fetchingFav = false;
  double tS = 0.0;
  TextTheme get textTheme => Theme.of(context).textTheme;
  late TabController _tabController;
  List<Cafe> likedCafe = [];
  late User user;
  String noFavsText = '';

  fetchCafes() async {
    final response = await Provider.of<CafeProvider>(context, listen: false)
        .fetchCafe(
            accessToken: user.accessToken,
            query: '?guest=false&fetchLiked=true');
    if (!response['success']) {
      showSnackbar(response['message']);
    }
  }

  Widget get nearByTab {
    final cafes = Provider.of<CafeProvider>(context).cafes;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dW * horizontalPaddingFactor),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: cafes.length,
        physics: isGuest ? const BouncingScrollPhysics() : null,
        itemBuilder: (context, i) => GestureDetector(
          onTap: () => push(NamedRoute.cafeDetailScreen,
              arguments: CafeDetailScreenArguments(cafe: cafes[i])),
          child: CafeWidget(
            key: ValueKey(cafes[i].id),
            cafe: cafes[i],
          ),
        ),
      ),
    );
  }

  Widget get favouritesTab {
    likedCafe = Provider.of<CafeProvider>(context).likedCafes;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dW * horizontalPaddingFactor),
      child: fetchingFav
          ? const CircularLoader()
          : likedCafe.isEmpty
              ? EmptyListWidget(
                  text: language['noFavouriteCafes'], topPadding: 0)
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: likedCafe.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, i) => GestureDetector(
                    onTap: () => push(NamedRoute.cafeDetailScreen,
                        arguments:
                            CafeDetailScreenArguments(cafe: likedCafe[i])),
                    child: CafeWidget(
                      key: ValueKey(likedCafe[i].id),
                      cafe: likedCafe[i],
                    ),
                  ),
                ),
    );
  }

  @override
  void initState() {
    super.initState();

    user = Provider.of<AuthProvider>(context, listen: false).user;
    // fetchCafes();
    _tabController = TabController(vsync: this, length: 2);

    _tabController.addListener(() async {
      if (_tabController.index == 1 && !fetchingFav) {
        if (likedCafe.isEmpty) {
          setState(() {
            fetchingFav = true;
          });
        }

        await fetchCafes();
        setState(() {
          fetchingFav = false;
          noFavsText = language['noFavouriteCafes'];
        });
      } else {
        setState(() {
          noFavsText = '';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    dH = MediaQuery.of(context).size.height;

    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    likedCafe = Provider.of<CafeProvider>(context).likedCafes;

    // fetchingFav = true;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => pop(),
          child: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.black,
            size: 25,
          ),
        ),
        titleSpacing: dH * 0.01,
        title: TextWidget(
          title: language['ourCafes'],
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
      body: SafeArea(
        child: user.isGuest
            ? ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: dW * horizontalPaddingFactor),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: dW * horizontalPaddingFactor,
                          ),
                          child: TextWidget(
                            title: language['nearbyCafes'],
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: dW * 0.04,
                        ),
                        nearByTab,
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // SizedBox(height: dW * 0.05),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: dW * horizontalPaddingFactor),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: dW * 0.06),
                      padding: EdgeInsets.all(dW * .02),
                      decoration: BoxDecoration(
                          color: const Color(0xffEFF6F8),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.15),
                                blurRadius: 10,
                                offset: const Offset(0, 4))
                          ]),
                      child: TabBar(
                        physics: const BouncingScrollPhysics(),
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        splashBorderRadius: BorderRadius.circular(8),
                        splashFactory: NoSplash.splashFactory,
                        overlayColor:
                            const MaterialStatePropertyAll(Colors.transparent),
                        unselectedLabelColor: getUnselectedLabelColor(context),
                        unselectedLabelStyle:
                            const TextStyle(fontWeight: FontWeight.w400),
                        labelColor: const Color(0xff434343),
                        labelStyle: textTheme.titleLarge!
                            .copyWith(fontWeight: FontWeight.w500),
                        tabs: [
                          Tab(
                            height: dW * .1,
                            child: Text(
                              language['nearbyCafes'],
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Inter'),
                            ),
                          ),
                          Tab(
                            height: dW * .1,
                            child: Text(
                              language['favourites'],
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Inter'),
                            ),
                          ),
                        ],
                        controller: _tabController,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      physics: const BouncingScrollPhysics(),
                      controller: _tabController,
                      children: [
                        nearByTab,
                        // favouritesTab,
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: dW * horizontalPaddingFactor),
                          child: fetchingFav
                              ? const CircularLoader()
                              : likedCafe.isEmpty
                                  ? EmptyListWidget(
                                      text: noFavsText, topPadding: 0)
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: likedCafe.length,
                                      // physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, i) =>
                                          GestureDetector(
                                        onTap: () => push(
                                            NamedRoute.cafeDetailScreen,
                                            arguments:
                                                CafeDetailScreenArguments(
                                                    cafe: likedCafe[i])),
                                        child: CafeWidget(
                                          key: ValueKey(likedCafe[i].id),
                                          cafe: likedCafe[i],
                                        ),
                                      ),
                                    ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

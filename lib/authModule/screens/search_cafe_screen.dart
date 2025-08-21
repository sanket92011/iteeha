import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/model/user_model.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/colors.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/asset_svg_icon.dart';
import 'package:iteeha_app/common_widgets/circular_loader.dart';
import 'package:iteeha_app/common_widgets/custom_text_field.dart';
import 'package:iteeha_app/common_widgets/empty_list_widget.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:iteeha_app/homeModule/models/cafe_model.dart';
import 'package:iteeha_app/homeModule/providers/cafe_provider.dart';
import 'package:iteeha_app/homeModule/widgets/cafe_widget.dart';
import 'package:iteeha_app/navigation/arguments.dart';
import 'package:iteeha_app/navigation/navigators.dart';
import 'package:iteeha_app/navigation/routes.dart';
import 'package:provider/provider.dart';

class SearchCafeScreen extends StatefulWidget {
  const SearchCafeScreen({super.key});

  @override
  State<SearchCafeScreen> createState() => _SearchCafeScreenState();
}

class _SearchCafeScreenState extends State<SearchCafeScreen> {
  //
  Map language = {};
  double dW = 0.0;
  double tS = 0.0;
  bool isLoading = false;
  bool isSearchLoading = false;
  TextTheme get textTheme => Theme.of(context).textTheme;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late User user;
  Timer? _debounce;

  selectCafe(Cafe cafe) {
    Provider.of<CafeProvider>(context, listen: false).selectCafe(cafe);
    pushAndRemoveUntil(NamedRoute.bottomNavBarScreen,
        arguments: BottomNavArgumnets());
  }

  fetchCafes() async {
    final response =
        await Provider.of<CafeProvider>(context, listen: false).fetchCafe(
      accessToken: user.accessToken,
      query: 'search=${_searchController.text.trim()}',
    );
    if (!response['success']) {
      showSnackbar(response['message']);
    }
  }

  init() async {
    setState(() => isLoading = true);
    await fetchCafes();
    setState(() => isLoading = false);
  }

  search(_) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    if (_searchController.text.trim().length > 2) {
      _debounce = Timer(const Duration(seconds: 1), () async {
        setState(() => isSearchLoading = true);
        await fetchCafes();
        setState(() => isSearchLoading = false);

        if (_debounce?.isActive ?? false) _debounce!.cancel();
      });
    }
  }

  @override
  void initState() {
    super.initState();

    user = Provider.of<AuthProvider>(context, listen: false).user;
    init();
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    final cafes = Provider.of<CafeProvider>(context).cafes;

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
          title: language['selectACafe'],
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   margin: EdgeInsets.only(top: dW * 0.03),
            //   color: const Color(0XFFEFF6F8),
            //   padding: screenHorizontalPadding(dW),
            //   child: CustomTextFieldWithLabel(
            //     label: '',
            //     borderColor: Colors.black,
            //     controller: _searchController,
            //     focusNode: _searchFocusNode,
            //     hintText: language['srchByLocOrCafe'],
            //     hintFontWeight: FontWeight.w600,
            //     hintColor: const Color(0XFFB4B4B4),
            //     prefixIcon: const Padding(
            //       padding: EdgeInsets.all(15.0),
            //       child: AssetSvgIcon('search_icon', color: lightGray),
            //     ),
            //     suffixIcon: IconButton(
            //       focusColor: Colors.transparent,
            //       highlightColor: Colors.transparent,
            //       splashColor: Colors.transparent,
            //       onPressed: () {
            //         setState(() => _searchController.clear());
            //         fetchCafes();
            //       },
            //       icon: _searchController.text.isEmpty
            //           ? const SizedBox.shrink()
            //           : const Icon(
            //               Icons.clear,
            //               color: Colors.black87,
            //             ),
            //     ),
            //     onChanged: search,
            //   ),
            // ),
            Container(
              margin: EdgeInsets.only(top: dW * 0.03),
              padding: screenHorizontalPadding(dW),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0XFFEFF6F8),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: CustomTextFieldWithLabel(
                  label: '',
                  borderColor: Colors.transparent,
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  hintText: language['srchByLocOrCafe'],
                  hintFontWeight: FontWeight.w600,
                  hintColor: const Color(0XFFB4B4B4),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: AssetSvgIcon('search_icon', color: lightGray),
                  ),
                  suffixIcon: IconButton(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () {
                      setState(() => _searchController.clear());
                      fetchCafes();
                    },
                    icon: _searchController.text.isEmpty
                        ? const SizedBox.shrink()
                        : const Icon(
                            Icons.clear,
                            color: Colors.black87,
                          ),
                  ),
                  onChanged: search,
                ),
              ),
            ),
            SizedBox(height: dW * 0.07),
            Padding(
              padding: screenHorizontalPadding(dW),
              child: TextWidget(
                title: language['nearbyCafes'],
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: const Color(0XFF434343),
              ),
            ),
            SizedBox(height: dW * 0.06),
            Expanded(
              child: isSearchLoading || isLoading
                  ? const CircularLoader()
                  : cafes.isEmpty
                      ? EmptyListWidget(
                          text: _searchController.text.trim().isEmpty
                              ? language['searchCafes']
                              : language['noCafesFound'],
                          topPadding: 0)
                      : ListView.builder(
                          padding: EdgeInsets.only(
                            left: dW * horizontalPaddingFactor,
                            right: dW * horizontalPaddingFactor,
                          ),
                          shrinkWrap: true,
                          itemCount: cafes.length,
                          // physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, i) => GestureDetector(
                            onTap: () => selectCafe(cafes[i]),
                            child: CafeWidget(
                              key: ValueKey(cafes[i].id),
                              cafe: cafes[i],
                              showFavourite: false,
                            ),
                          ),
                        ),
            )
          ],
        ),
      ),
    );
  }
}

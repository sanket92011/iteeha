import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/model/user_model.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/colors.dart';
import 'package:iteeha_app/common_widgets/asset_svg_icon.dart';
import 'package:iteeha_app/common_widgets/cached_image_widget.dart';
import 'package:iteeha_app/homeModule/models/cafe_model.dart';
import 'package:iteeha_app/homeModule/providers/cafe_provider.dart';
import 'package:provider/provider.dart';

class CafeDetailCarouselWidget extends StatefulWidget {
  final List<dynamic> images;
  final Cafe cafe;
  final bool showFavourite;

  const CafeDetailCarouselWidget(
      {super.key,
      required this.images,
      required this.cafe,
      this.showFavourite = true});

  @override
  CafeDetail_CarouselWidgetState createState() =>
      CafeDetail_CarouselWidgetState();
}

class CafeDetail_CarouselWidgetState extends State<CafeDetailCarouselWidget> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  double dW = 0.0;
  double dH = 0.0;
  late User user;
  double tS = 0.0;

  likeUnlike() async {
    setState(() {
      widget.cafe.isLiked = !widget.cafe.isLiked;
    });
    final response =
        await Provider.of<CafeProvider>(context, listen: false).likeUnlike(
      body: {
        'cafe': widget.cafe.id,
        'like': widget.cafe.isLiked,
      },
      accessToken: user.accessToken,
    );

    if (!response['success']) {
      setState(() {
        widget.cafe.isLiked = !widget.cafe.isLiked;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    user = Provider.of<AuthProvider>(context, listen: false).user;
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    dH = MediaQuery.of(context).size.height;

    tS = MediaQuery.of(context).textScaleFactor;

    return Container(
      alignment: Alignment.topCenter,
      height: dW * 0.95,
      width: dW,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            // height: MediaQuery.of(context).size.height * 0.4,
            height: dW * 0.85,

            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return CachedImageWidget(
                  widget.images[index],
                );
              },
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
          if (widget.showFavourite && !user.isGuest)
            Positioned(
              right: 22,
              top: 22,
              child: GestureDetector(
                onTap: likeUnlike,
                child: widget.cafe.isLiked
                    ? const AssetSvgIcon('favourite_filled')
                    : const AssetSvgIcon('favourite'),
              ),
            ),
          Positioned(
            left: 0,
            child: Visibility(
              visible: _currentIndex > 0,
              child: Container(
                margin: EdgeInsets.only(left: dW * 0.04),
                // padding: EdgeInsets.only(left: dW * 0.01),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xff37383F).withOpacity(0.5),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: white,
                  ),
                  onPressed: () {
                    if (_currentIndex > 0) {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: Visibility(
              visible: _currentIndex < widget.images.length - 1,
              child: Container(
                margin: EdgeInsets.only(right: dW * 0.04),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xff37383F).withOpacity(0.5),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    color: white,
                  ),
                  onPressed: () {
                    if (_currentIndex < widget.images.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:iteeha_app/authModule/model/user_model.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/colors.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/asset_svg_icon.dart';
import 'package:iteeha_app/common_widgets/cached_image_widget.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:iteeha_app/homeModule/models/cafe_model.dart';
import 'package:iteeha_app/homeModule/providers/cafe_provider.dart';
import 'package:provider/provider.dart';

class CafeWidget extends StatefulWidget {
  final bool showFavourite;
  final Cafe cafe;
  const CafeWidget({super.key, required this.cafe, this.showFavourite = true});

  @override
  State<CafeWidget> createState() => _CafeWidgetState();
}

class _CafeWidgetState extends State<CafeWidget> {
  //
  Map language = {};
  double dW = 0.0;
  double tS = 0.0;
  TextTheme get textTheme => Theme.of(context).textTheme;
  late User user;
  double distance = 0;
  bool isLoading = false;
  bool isOpen = true;
  bool isFavourite = false;

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

  // String day = (DateTime.now().weekday - 1).toString();

  // String getCurrentTimeIn24HourFormat() {
  //   final now = DateTime.now();
  //   final formatter = DateFormat('HH:mm');

  //   return formatter.format(now);
  // }

  String getCurrentDayName() {
    return DateFormat('EEEE').format(DateTime.now());
  }

  // bool isCafeOpen() {
  //   int i = widget.cafe.timings.indexWhere(
  //     (timing) => timing['day'] == getCurrentDayName(),
  //   );
  //   if (i == -1) {
  //     return false;
  //   } else {
  //     if (widget.cafe.timings[i]['status'] == 'OPEN' &&
  //         DateTime.now().isAfter(
  //             convertNumberToDate(widget.cafe.timings[i]['startTime'])) &&
  //         DateTime.now().isBefore(
  //             convertNumberToDate(widget.cafe.timings[i]['endTime']))) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   }
  // }

  bool isCafeOpen() {
    int i = widget.cafe.timings.indexWhere(
      (timing) => timing['day'] == getCurrentDayName(),
    );
    if (i == -1) return false;


    final timing = widget.cafe.timings[i];
    final num startTimeNum = timing['startTime']??0;
    final num endTimeNum = timing['endTime']??0;

    final bool crossesMidnight = endTimeNum == 0 || endTimeNum < startTimeNum;

    final DateTime now = DateTime.now();
    final DateTime startTime = convertNumberToDate(startTimeNum);
    final DateTime endTime =
        convertNumberToDate(endTimeNum, addNextDay: crossesMidnight);

    return timing['status'] == 'OPEN' &&
        now.isAfter(startTime) &&
        now.isBefore(endTime);
  }

  @override
  void initState() {
    super.initState();

    isOpen = isCafeOpen();
    user = Provider.of<AuthProvider>(context, listen: false).user;
    setState(() {
      isLoading = true;
    });
    if (user.coordinates != null && user.isLocationAllowed) {
      distance = Geolocator.distanceBetween(
              widget.cafe.coordinates.latitude,
              widget.cafe.coordinates.longitude,
              user.coordinates!.latitude,
              user.coordinates!.longitude) /
          1000;
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Container(
      margin: EdgeInsets.only(bottom: dW * 0.08),
      child: Column(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              CachedImageWidget(
                widget.cafe.cafePhotos[0],
                width: dW,
                height: dW * 0.475,
              ),
              if (widget.showFavourite && !user.isGuest)
                Positioned(
                  right: 16,
                  top: 16,
                  child: GestureDetector(
                    onTap: likeUnlike,
                    child: widget.cafe.isLiked
                        ? const AssetSvgIcon('favourite_filled')
                        : const AssetSvgIcon('favourite'),
                  ),
                )
            ],
          ),
        ),
        SizedBox(
          height: dW * 0.035,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TextWidget(
                      title: '${widget.cafe.name}, ',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    TextWidget(
                      title: widget.cafe.area,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                SizedBox(
                  height: dW * 0.01,
                ),
                Row(
                  children: [
                    if (user.coordinates != null && user.isLocationAllowed)
                      Row(
                        children: [
                          TextWidget(
                            title: isLoading
                                ? '-- Km Away'
                                : ' ${distance.toStringAsFixed(1)} Km Away',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff84858E),
                          ),
                          SizedBox(
                            width: dW * 0.02,
                          ),
                          const Icon(
                            Icons.circle,
                            size: 7,
                            color: Color(0xffDBDBE3),
                          ),
                          SizedBox(
                            width: dW * 0.02,
                          ),
                        ],
                      ),
                    isOpen
                        ? const TextWidget(
                            title: 'OPEN',
                            color: greenColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          )
                        : const TextWidget(
                            title: 'CLOSED',
                            color: redColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                  ],
                ),
              ],
            ),
            GestureDetector(
              onTap: () => navigateTo(widget.cafe.coordinates),
              child: Row(
                children: [
                  const TextWidget(
                    title: 'Directions',
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                    color: Color(0xff272559),
                  ),
                  SizedBox(
                    width: dW * 0.01,
                  ),
                  const AssetSvgIcon('direction_right_arrow'),
                  SizedBox(width: dW * 0.03),
                ],
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

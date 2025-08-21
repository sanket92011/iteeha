import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/common_widgets/cached_image_widget.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CarouselWidget extends StatefulWidget {
  List<dynamic> photoList;
  CarouselWidget({super.key, required this.photoList});

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  //
  Map language = {};
  double dW = 0.0;
  double tS = 0.0;
  TextTheme get textTheme => Theme.of(context).textTheme;
  int currentBarIndex = 0;

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;

    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: widget.photoList.length,
          options: CarouselOptions(
            height: 200,
            aspectRatio: 16 / 9,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(seconds: 2),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                currentBarIndex = index;
              });
            },
          ),
          itemBuilder: (BuildContext context, int index, int realIndex) {
            return Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                // image: DecorationImage(
                //   image: NetworkImage(widget.photoList[index]),
                //   fit: BoxFit.cover,
                // ),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedImageWidget(widget.photoList[index])),
            );
          },
        ),
        Positioned(
          bottom: dW * 0.03,
          left: dW * 0.03,
          right: dW * 0.03,
          child: Row(
            children: List.generate(widget.photoList.length, (index) {
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.symmetric(horizontal: dW * 0.005),
                  decoration: BoxDecoration(
                    color:
                        index == currentBarIndex ? Colors.white : Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

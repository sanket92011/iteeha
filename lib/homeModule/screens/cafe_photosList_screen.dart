import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/colors.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/cached_image_widget.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:iteeha_app/homeModule/providers/cafe_provider.dart';
import 'package:iteeha_app/homeModule/widgets/carousel_widget.dart';
import 'package:iteeha_app/navigation/arguments.dart';
import 'package:iteeha_app/navigation/navigators.dart';
import 'package:iteeha_app/navigation/routes.dart';
import 'package:provider/provider.dart';

class CafePhotosListScreen extends StatefulWidget {
  const CafePhotosListScreen({super.key});

  @override
  State<CafePhotosListScreen> createState() => _CafePhotosListScreenState();
}

class _CafePhotosListScreenState extends State<CafePhotosListScreen> {
  //
  Map language = {};
  double dW = 0.0;
  double tS = 0.0;
  TextTheme get textTheme => Theme.of(context).textTheme;

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    final selectedCafe =
        Provider.of<CafeProvider>(context, listen: false).selectedCafe;
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
          title: language['images'],
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: 1,
          itemBuilder: ((context, index) => Padding(
                padding: EdgeInsets.all(dW * horizontalPaddingFactor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CarouselWidget(photoList: selectedCafe!.carouselphotos),
                    SizedBox(
                      height: dW * 0.08,
                    ),
                    TextWidget(
                      title:
                          '${selectedCafe.otherPhotos.length} ${language['images']}',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    SizedBox(
                      height: dW * 0.05,
                    ),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: selectedCafe.otherPhotos.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: dW * 0.04,
                        mainAxisSpacing: dW * 0.06,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        String imageUrl = selectedCafe.otherPhotos[index];

                        return GestureDetector(
                            onTap: () => push(
                                  NamedRoute.cafeImageScreen,
                                  arguments: CafeImageArguments(
                                    otherPhoto: selectedCafe.otherPhotos[index],
                                  ),
                                ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedImageWidget(
                                imageUrl,
                              ),
                            ));
                      },
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}

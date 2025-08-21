import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/model/user_model.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/colors.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:iteeha_app/moreModule/providers/faq_topic_provider.dart';
import 'package:iteeha_app/moreModule/widgets/faq_topic_container_widget.dart';
import 'package:iteeha_app/navigation/arguments.dart';
import 'package:iteeha_app/navigation/navigators.dart';
import 'package:iteeha_app/navigation/routes.dart';
import 'package:provider/provider.dart';

class FaqTopicsScreen extends StatefulWidget {
  const FaqTopicsScreen({super.key});

  @override
  State<FaqTopicsScreen> createState() => _FaqTopicsScreenState();
}

class _FaqTopicsScreenState extends State<FaqTopicsScreen> {
  double dW = 0.0;
  double dH = 0.0;
  double tS = 0.0;
  Map language = {};
  bool isLoading = false;
  TextTheme get textTheme => Theme.of(bContext).textTheme;
  late User user;

  fetchFaqTopics() async {
    final response = await Provider.of<FaqTopicProvider>(context, listen: false)
        .fetchFaqTopics(
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
    await fetchFaqTopics();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    user = Provider.of<AuthProvider>(context, listen: false).user;

    init();
  }

  @override
  Widget build(BuildContext context) {
    dH = MediaQuery.of(context).size.height;

    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    final faqTopic = Provider.of<FaqTopicProvider>(context).faqTopics;

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
        title: const TextWidget(
          title: "FAQs",
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: dW * horizontalPaddingFactor, vertical: dW * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWidget(
              title: language['faqsTopics'],
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            SizedBox(
              height: dW * 0.06,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: faqTopic.length,
              itemBuilder: (context, int index) {
                final topic = faqTopic[index];

                return FaqTopicContainerWidget(
                  title: topic.name,
                  onTap: () => push(NamedRoute.faqsScreen,
                      arguments: FaqsScreenArguments(faqTopic: topic)),
                );
              },
            )
          ],
        ),
      )),
    );
  }
}

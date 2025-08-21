import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/model/user_model.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/colors.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:iteeha_app/moreModule/models/faq_model.dart';
import 'package:iteeha_app/moreModule/providers/faq_provider.dart';
import 'package:iteeha_app/moreModule/widgets/faq_collapsible_widget.dart';
import 'package:iteeha_app/navigation/arguments.dart';
import 'package:iteeha_app/navigation/navigators.dart';
import 'package:provider/provider.dart';

class FaqsScreen extends StatefulWidget {
  final FaqsScreenArguments args;

  const FaqsScreen({super.key, required this.args});

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
  double dW = 0.0;
  double dH = 0.0;
  double tS = 0.0;
  Map language = {};
  bool isLoading = false;
  TextTheme get textTheme => Theme.of(bContext).textTheme;
  late User user;
  List<Faq> faqs = [];

  fetchFaq() async {
    late String query;
    if (widget.args.topicName != '') {
      query = '?topicName=${widget.args.topicName}';
    } else {
      query = '?topic=${widget.args.faqTopic!.id}';
    }
    final response = await Provider.of<FaqProvider>(context, listen: false)
        .fetchFaqs(accessToken: user.accessToken, query: query);
    if (!response['success']) {
      showSnackbar(response['message']);
    }
  }

  init() async {
    setState(() {
      isLoading = true;
    });
    await fetchFaq();
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
    faqs = Provider.of<FaqProvider>(context).faqs;

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget(
                title: widget.args.topicName.isNotEmpty
                    ? widget.args.topicName
                    : widget.args.faqTopic!.name,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              SizedBox(
                height: dW * 0.08,
              ),
              ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: faqs.length,
                itemBuilder: (context, int index) {
                  return FaqCollapsibleDropdown(
                    faq: faqs[index],
                  );
                },
              )
            ],
          ),
        ),
      )),
    );
  }
}

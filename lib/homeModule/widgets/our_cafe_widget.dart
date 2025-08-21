import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/model/user_model.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/homeModule/providers/cafe_provider.dart';
import 'package:iteeha_app/homeModule/widgets/cafe_widget.dart';
import 'package:provider/provider.dart';

class OurCafeWidget extends StatefulWidget {
  const OurCafeWidget({super.key});

  @override
  State<OurCafeWidget> createState() => _OurCafeWidgetState();
}

class _OurCafeWidgetState extends State<OurCafeWidget> {
  //
  Map language = {};
  double dW = 0.0;
  double tS = 0.0;
  bool isLoading = false;
  TextTheme get textTheme => Theme.of(context).textTheme;
  late User user;

  fetchCafe() async {
    setState(() => isLoading = true);
    final response = await Provider.of<CafeProvider>(context, listen: false)
        .fetchCafe(accessToken: user.accessToken, query: '');
    if (!response['success']) {
      showSnackbar(response['message']);
    }
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    user = Provider.of<AuthProvider>(context, listen: false).user;
    fetchCafe();
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    final cafe = Provider.of<CafeProvider>(context).cafes;

    return Column(
      children: [...cafe.map((cafe) => CafeWidget(cafe: cafe))],
    );
  }
}

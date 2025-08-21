import 'package:iteeha_app/authModule/model/user_model.dart';
import 'package:iteeha_app/homeModule/models/cafe_model.dart';
import 'package:iteeha_app/moreModule/models/faq_topic_model.dart';
import 'package:iteeha_app/rewardsModule/models/offer_model.dart';

class SelectLanguageScreenArguments {
  final bool fromOnboarding;
  const SelectLanguageScreenArguments({this.fromOnboarding = false});
}

class BottomNavArgumnets {
  final int index;
  BottomNavArgumnets({this.index = 0});
}

class VerifyOtpArguments {
  final String mobileNo;
  VerifyOtpArguments({
    required this.mobileNo,
  });
}

class RegistrationArguments {
  final String mobileNo;
  RegistrationArguments({required this.mobileNo});
}

class LoadingScreenArguments {
  final String featureId;
  final String type;
  LoadingScreenArguments({required this.featureId, required this.type});
}

class PrivacyPolicyAndTcScreenArguments {
  final String contentType;
  final String title;
  PrivacyPolicyAndTcScreenArguments({
    required this.contentType,
    required this.title,
  });
}

class CafeDetailScreenArguments {
  final Cafe cafe;
  CafeDetailScreenArguments({required this.cafe});
}

class AllMenuScreenArguments {
  final Cafe cafe;
  AllMenuScreenArguments({required this.cafe});
}

class CafeImageArguments {
  final String otherPhoto;
  CafeImageArguments({required this.otherPhoto});
}

class MenuImageArguments {
  final String menuPhoto;
  MenuImageArguments({required this.menuPhoto});
}

class OffersBottomSheetArguments {
  final Offer offer;
  OffersBottomSheetArguments({required this.offer});
}

class EditProfileScreenArguments {
  final User user;
  EditProfileScreenArguments({required this.user});
}

class FaqsScreenArguments {
  final FaqTopic? faqTopic;
  final String topicName;
  FaqsScreenArguments({this.faqTopic, this.topicName = ''});
}

class PaymentScreenArguments {
  final String orderId;
  final num amount;
  final String type;
  final Map transaction;
  // final List subscription;
  // final String subType;

  PaymentScreenArguments({
    required this.orderId,
    required this.amount,
    required this.type,
    required this.transaction,
    // this.subscription = const [],
    // this.subType = '',
  });
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iteeha_app/authModule/model/user_model.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/colors.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/asset_svg_icon.dart';
import 'package:iteeha_app/common_widgets/custom_button.dart';
import 'package:iteeha_app/common_widgets/custom_text_field.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:iteeha_app/navigation/arguments.dart';
import 'package:iteeha_app/navigation/navigators.dart';
import 'package:iteeha_app/navigation/routes.dart';
import 'package:iteeha_app/walletModule/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

class AddMoneyBottomSheetWidget extends StatefulWidget {
  final double keyboardHeight;
  const AddMoneyBottomSheetWidget({super.key, required this.keyboardHeight});

  @override
  AddMoneyBottomSheetWidgetState createState() =>
      AddMoneyBottomSheetWidgetState();
}

class AddMoneyBottomSheetWidgetState extends State<AddMoneyBottomSheetWidget> {
  double dH = 0.0;
  double dW = 0.0;
  double tS = 0.0;
  TextTheme customTextTheme = const TextTheme();
  Map language = {};
  bool isPaying = false;
  bool isValidate = false;

  List<String> selectedWeekdays = [];
  final TextEditingController _amountController = TextEditingController();
  bool isPrefixSuffixVisible = false;
  Map? transaction;
  late User user;

  final FocusNode _textFieldFocusNode = FocusNode();

  List<bool> containerSelected = [false, false, false];
  List<Color> containerBorderColor = [
    const Color(0xffDBDBE3),
    const Color(0xffDBDBE3),
    const Color(0xffDBDBE3),
  ];
  void setTextFieldValue(int value, int index) {
    for (int i = 0; i < containerSelected.length; i++) {
      if (i == index) {
        if (containerSelected[i]) {
          _amountController.clear();
          containerSelected[i] = false;
          isPrefixSuffixVisible = false;
          isValidate = false;
        } else {
          _amountController.text = value.toString();
          containerSelected[i] = true;
          isPrefixSuffixVisible = true;
          isValidate = true;
        }
      } else {
        containerSelected[i] = false;
      }
      setState(() {
        containerBorderColor[i] = containerSelected[i]
            ? const Color(0xff272559)
            : const Color(0xffDBDBE3);
      });
    }
    _textFieldFocusNode.requestFocus();
  }

  void clearSelectedContainer() {
    for (int i = 0; i < containerSelected.length; i++) {
      containerSelected[i] = false;
      containerBorderColor[i] = const Color(0xffDBDBE3);
    }
  }

  bool isMultipleOf50Or100(int number) {
    return number % 50 == 0 || number % 100 == 0;
  }

  void clearTextField() {
    _amountController.clear();
    for (int i = 0; i < containerSelected.length; i++) {
      containerSelected[i] = false;
      setState(() {
        containerBorderColor[i] = const Color(0xffDBDBE3);
      });
    }
    isPrefixSuffixVisible = false;
  }

  bool get isGreaterThan20k {
    String amount = _amountController.text.trim();
    double parsedAmount = double.tryParse(amount) ?? 0;

    final user = Provider.of<AuthProvider>(context, listen: false).user;

    if ((user.walletBalance + parsedAmount) > 20000) {
      return true;
    }
    return false;
  }

  bool get validateAmount {
    setState(() {
      isValidate = false;
    });
    String amount = _amountController.text.trim();
    double parsedAmount = double.tryParse(amount) ?? 0;
    // final user = Provider.of<AuthProvider>(context, listen: false).user;

    if (amount.isEmpty ||
            parsedAmount <= 0 ||
            !isMultipleOf50Or100(parsedAmount.toInt()) ||
            isGreaterThan20k == true
        // ||
        // (user.walletBalance + parsedAmount) > 20000
        ) {
      setState(() {
        isValidate = false;
      });
      return false;
    }
    setState(() {
      isValidate = true;
    });
    return true;
  }

  gotoPaymentScreen() async {
    if (transaction != null) {
      push(NamedRoute.paymentScreen,
          arguments: PaymentScreenArguments(
            orderId: transaction!['rzpOrderId'],
            amount: transaction!['totalAmount'],
            type: 'walletRecharge',
            transaction: transaction!,
          ));
    } else {
      setState(() => isPaying = true);
      final response =
          await Provider.of<TransactionProvider>(context, listen: false)
              .walletRecharge(accessToken: user.accessToken, body: {
        'rechargeAmount': double.parse(_amountController.text),
        'total': double.parse(_amountController.text),
        // 'rechargeAmount': 1,
        // 'total': 1,
      });

      setState(() => isPaying = false);

      if (response['success']) {
        transaction = response['result'];
        push(NamedRoute.paymentScreen,
            arguments: PaymentScreenArguments(
              orderId: transaction!['rzpOrderId'],
              amount: transaction!['totalAmount'],
              type: 'walletRecharge',
              transaction: transaction!,
            ));
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _textFieldFocusNode.dispose();
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
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    final user = Provider.of<AuthProvider>(context).user;

    return Container(
      padding: EdgeInsets.only(
        bottom: widget.keyboardHeight,
      ),
      child: GestureDetector(
        onTap: () => hideKeyBoard(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: dW * horizontalPaddingFactor,
                    horizontal: dW * horizontalPaddingFactor),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget(
                            title: language['addMoney'],
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          GestureDetector(
                              onTap: () => pop(),
                              child: const AssetSvgIcon(
                                'cross_red',
                                color: Colors.black,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: dW * 0.06,
                      ),
                      Stack(children: [
                        Image.asset('assets/images/add_money_bg_new.png'),
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  left: dW * 0.06, top: dW * 0.075),
                              child: Row(
                                children: [
                                  Container(
                                    height: dW * 0.15,
                                    width: dW * 0.01,
                                    color: const Color(0xff272559),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: dW * 0.03),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextWidget(
                                          title: language['currentBalance'],
                                          color: const Color(0xff272559),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                        SizedBox(
                                          height: dW * 0.018,
                                        ),
                                        TextWidget(
                                          title:
                                              '\u20b9 ${user.walletBalance.toString()}',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: const Color(0xff292454),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ]),
                      SizedBox(
                        height: dW * 0.04,
                      ),
                      const Divider(
                        color: Color(0xff84858E),
                      ),
                      SizedBox(
                        height: dW * 0.04,
                      ),
                      CustomTextFieldWithLabel(
                        hintColor: const Color(0xff6B6C75),
                        hintFS: 14,
                        labelFS: 12,
                        borderColor: Colors.grey,
                        controller: _amountController,
                        // focusNode: _textFieldFocusNode,
                        border: 4,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                        ],
                        hintFontWeight: FontWeight.w600,
                        labelFontWeight: FontWeight.w600,
                        labelColor: const Color(0xff6B6C75),
                        inputType: TextInputType.number,
                        optional: true,
                        label: language['enterAmount'],
                        hintText: language['enterAmountToAdd'],
                        onChanged: (text) {
                          setState(() {
                            isPrefixSuffixVisible =
                                _amountController.text.isNotEmpty;
                            transaction = null;
                            validateAmount;
                            // isValidate = validateAmount();

                            clearSelectedContainer();
                          });
                        },
                        prefixIcon: isPrefixSuffixVisible
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () => _amountController.clear(),
                                    child: const TextWidget(
                                      title: '\u20b9',
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              )
                            : null,
                        suffixIcon: isPrefixSuffixVisible
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () => clearTextField(),
                                    child: Container(
                                      margin: EdgeInsets.only(right: dW * 0.04),
                                      child: TextWidget(
                                        title: language['clear'],
                                        color: const Color(0xff272559),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : null,
                      ),
                      SizedBox(
                        height: dW * 0.02,
                      ),
                      TextWidget(
                        title:
                            '* Amount should be multiple of \u20b950 or \u20b9100',
                        fontSize: 10,
                        color:
                            // amountTextWidgetColor
                            validateAmount
                                ? getThemeColor(context)
                                : const Color(0xff515259),
                      ),
                      SizedBox(
                        height: dW * 0.06,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setTextFieldValue(500, 0);
                                transaction = null;
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: dW * 0.05, vertical: dW * 0.03),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: containerSelected[0] ? 2.0 : 1.0,
                                      color: containerBorderColor[0],
                                    ),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Row(
                                  children: [
                                    const TextWidget(title: '\u20b9 500'),
                                    if (containerSelected[0])
                                      Container(
                                          margin:
                                              EdgeInsets.only(left: dW * 0.01),
                                          child: const AssetSvgIcon(
                                              'cross_bg_blue')),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setTextFieldValue(1000, 1);
                                transaction = null;
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: dW * 0.05, vertical: dW * 0.03),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: containerSelected[1] ? 2.0 : 1.0,
                                      color: containerBorderColor[1],
                                    ),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Row(
                                  children: [
                                    const TextWidget(title: '\u20b9 1000'),
                                    if (containerSelected[1])
                                      Container(
                                          margin:
                                              EdgeInsets.only(left: dW * 0.01),
                                          child: const AssetSvgIcon(
                                              'cross_bg_blue')),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setTextFieldValue(2000, 2);
                                transaction = null;
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: dW * 0.05, vertical: dW * 0.03),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: containerSelected[2] ? 2.0 : 1.0,
                                      color: containerBorderColor[2],
                                    ),
                                    borderRadius: BorderRadius.circular(25)),
                                child: Row(
                                  children: [
                                    const TextWidget(title: '\u20b9 2000'),
                                    if (containerSelected[2])
                                      Container(
                                          margin:
                                              EdgeInsets.only(left: dW * 0.01),
                                          child: const AssetSvgIcon(
                                              'cross_bg_blue')),
                                  ],
                                ),
                              ),
                            )
                          ])
                    ]),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: dW * horizontalPaddingFactor,
                    vertical: dW * 0.025),
                color: const Color(0xffFFFCE2),
                width: dW,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AssetSvgIcon(
                      'disclaimer',
                      color: isGreaterThan20k ? redColor : null,
                    ),
                    SizedBox(
                      width: dW * 0.02,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            title:
                                'A maximum of \u20b9 20,000  can be stored in one card',
                            color: isGreaterThan20k ? redColor : null,
                            fontWeight: FontWeight.w500,
                            fontSize: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    left: dW * horizontalPaddingFactor,
                    right: dW * horizontalPaddingFactor,
                    bottom: dW * 0.1,
                    top: dW * 0.06),
                child: CustomButton(
                  width: dW,
                  height: dW * 0.135,
                  radius: 8,
                  isLoading: isPaying,
                  buttonText: language['payNow'],
                  buttonTextSyle:
                      Theme.of(context).textTheme.displayLarge!.copyWith(
                            fontSize: tS * 18,
                            color: Colors.white,
                          ),
                  onPressed: () => isValidate ? gotoPaymentScreen() : null,
                  buttonColor: validateAmount
                      ? buttonColor
                      : buttonColor.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

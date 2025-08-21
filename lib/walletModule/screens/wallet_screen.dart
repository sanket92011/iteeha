// ignore_for_file: use_build_context_synchronously

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:iteeha_app/authModule/model/user_model.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/colors.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/circular_loader.dart';
import 'package:iteeha_app/common_widgets/empty_list_widget.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:iteeha_app/walletModule/providers/transaction_provider.dart';
import 'package:iteeha_app/walletModule/widgets/add_money_bottomsheet.dart';
import 'package:iteeha_app/homeModule/widgets/total_saving_widget.dart';
import 'package:iteeha_app/navigation/navigators.dart';
import 'package:iteeha_app/navigation/routes.dart';
import 'package:provider/provider.dart';

import '../widgets/transaction_widget.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with TickerProviderStateMixin {
  Map language = {};
  double dW = 0.0;
  double tS = 0.0;
  bool isLoading = false;

  TextTheme get textTheme => Theme.of(context).textTheme;
  late TabController _tabController;
  late User user;

  fetchTransactions() async {
    final response =
        await Provider.of<TransactionProvider>(context, listen: false)
            .fetchTransactions(
      accessToken: user.accessToken,
    );
    if (!response['success']) {
      showSnackbar(response['message']);
    } else {
      if (response['walletBalance'] != null) {
        Provider.of<AuthProvider>(context, listen: false)
            .updateWalletBalance(response['walletBalance']);
      }
    }
  }

  void addMoneyBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (context) => AddMoneyBottomSheetWidget(
        keyboardHeight: MediaQuery.of(context).viewInsets.bottom,
      ),
    ).then((value) {
      if (value != null) {
        fetchTransactions();
      }
    });
  }

  Widget scanBarcode() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: dW * horizontalPaddingFactor),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: dW * .08),
            Container(
              width: dW,
              padding: EdgeInsets.symmetric(vertical: dW * 0.04),
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: const Color(0xffDBDBE3),
                  ),
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  TextWidget(
                    title: language['scanTheBarcode'],
                    color: const Color(0xff515259),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: dW * 0.04),
                  BarcodeWidget(
                    barcode: Barcode.code128(),
                    textPadding: dW * 0.04,
                    data: user.phone,
                    width: dW * 0.7,
                    height: dW * 0.17,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget transactionHistory() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: dW * horizontalPaddingFactor),
  //     child: SingleChildScrollView(
  //       physics: const BouncingScrollPhysics(),
  //       child: transaction.isEmpty
  //           ? EmptyListWidget(
  //               text: language['noTransactionsYet'], topPadding: 0.2)
  //           : isLoading
  //               ? Container(
  //                   margin: EdgeInsets.only(top: dW * 0.1),
  //                   child: const CircularLoader(),
  //                 )
  //               : Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     SizedBox(height: dW * .08),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         const TextWidget(
  //                           title: 'Transactions history',
  //                           fontWeight: FontWeight.w500,
  //                           fontSize: 16,
  //                         ),
  //                         GestureDetector(
  //                           onTap: () => push(NamedRoute.allTransactionScreen),
  //                           child: Row(
  //                             children: [
  //                               TextWidget(
  //                                 title: language['viewAll'],
  //                                 fontSize: 14,
  //                                 fontWeight: FontWeight.w500,
  //                                 color: const Color(0xffAAABB5),
  //                               ),
  //                               const Icon(
  //                                 Icons.arrow_forward_ios,
  //                                 color: Color(0xffAAABB5),
  //                                 size: 15,
  //                               )
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(
  //                       height: dW * 0.04,
  //                     ),
  //                     ...transaction.take(4).map(
  //                           (transaction) => Container(
  //                             margin: EdgeInsets.only(bottom: dW * 0.05),
  //                             padding: EdgeInsets.all(dW * 0.025),
  //                             decoration: BoxDecoration(
  //                                 border: Border.all(
  //                                   color: const Color(0xffF4F4F4),
  //                                 ),
  //                                 borderRadius: BorderRadius.circular(16)),
  //                             child: Row(
  //                               crossAxisAlignment: CrossAxisAlignment.center,
  //                               children: [
  //                                 AssetSvgIcon(transaction.transactionStatus
  //                                         .contains('Debit')
  //                                     ? 'wallet_debit'
  //                                     : 'wallet_credit'),
  //                                 SizedBox(
  //                                   width: dW * 0.03,
  //                                 ),
  //                                 Expanded(
  //                                   child: Column(
  //                                     crossAxisAlignment:
  //                                         CrossAxisAlignment.start,
  //                                     children: [
  //                                       TextWidget(
  //                                         title: transaction.transactionStatus
  //                                                 .contains('Debit')
  //                                             ? transaction.title
  //                                             : "Money Added To Card",
  //                                         fontWeight: FontWeight.w500,
  //                                       ),
  //                                       SizedBox(
  //                                         height: dW * 0.015,
  //                                       ),
  //                                       Row(
  //                                         children: [
  //                                           TextWidget(
  //                                             title: DateFormat('dd/MM/yyyy')
  //                                                 .format(
  //                                                     transaction.createdAt),
  //                                             fontSize: 10,
  //                                             color: const Color(0xff515259),
  //                                           ),
  //                                           if (transaction.transactionStatus
  //                                               .contains('Debit')) ...[
  //                                             SizedBox(
  //                                               width: dW * 0.01,
  //                                             ),
  //                                             const Icon(
  //                                               Icons.circle,
  //                                               size: 5,
  //                                               color: Color(0xffAAABB5),
  //                                             ),
  //                                             SizedBox(
  //                                               width: dW * 0.01,
  //                                             ),
  //                                             // if (transaction.cafe != null)
  //                                             //   TextWidget(
  //                                             //     title: transaction.cafe!.area,
  //                                             //     fontSize: 10,
  //                                             //     color: const Color(0xff515259),
  //                                             //   ),
  //                                           ],
  //                                         ],
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                                 Column(
  //                                   mainAxisAlignment: MainAxisAlignment.center,
  //                                   children: [
  //                                     if (transaction.transactionStatus
  //                                         .contains('Debit')) ...[
  //                                       TextWidget(
  //                                         title:
  //                                             '- \u20B9 ${transaction.totalAmount}',
  //                                         color: const Color(0xff515259),
  //                                         fontWeight: FontWeight.w600,
  //                                       ),
  //                                       SizedBox(
  //                                         height: dW * 0.02,
  //                                       ),
  //                                     ] else
  //                                       TextWidget(
  //                                         title:
  //                                             '+ \u20B9 ${transaction.totalAmount}',
  //                                         color: greenColor,
  //                                         fontWeight: FontWeight.w600,
  //                                       ),
  //                                   ],
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                   ],
  //                 ),
  //     ),
  //   );
  // }

  init() async {
    setState(() {
      isLoading = true;
    });

    await fetchTransactions();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    user = Provider.of<AuthProvider>(context, listen: false).user;
    init();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    final transaction = Provider.of<TransactionProvider>(context).transactions;
    final user = Provider.of<AuthProvider>(context).user;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: dW * horizontalPaddingFactor,
                  vertical: dW * 0.04),
              child: TextWidget(
                title: language['wallet'],
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: dW * 0.04,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: dW * horizontalPaddingFactor),
              child: TotalSavingWidget(),
            ),
            SizedBox(
              height: dW * 0.08,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: dW * horizontalPaddingFactor),
              child: Stack(
                children: [
                  // Image.asset('assets/images/wallet_bg.png'),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset('assets/images/wallet_bg_new.png')),
                  Column(
                    children: [
                      Container(
                        width: dW,
                        margin:
                            EdgeInsets.only(left: dW * 0.19, top: dW * 0.07),
                        child: TextWidget(
                          title: user.fullName,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: const Color(0xff272559),
                        ),
                      ),
                      Container(
                          width: dW,
                          margin:
                              EdgeInsets.only(left: dW * 0.1, top: dW * 0.23),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget(
                                      title: language['currentBalance'],
                                      color: const Color(0xff272559),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: dW * 0.05),
                                      child: TextWidget(
                                        title:
                                            '\u20b9 ${user.walletBalance.toString()}',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: const Color(0xff292454),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: dW * 0.02,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: dW * 0.05),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: dW * horizontalPaddingFactor),
                    child: Container(
                      padding: EdgeInsets.all(dW * .02),
                      decoration: BoxDecoration(
                          color: const Color(0xffEFF6F8),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.15),
                                blurRadius: 10,
                                offset: const Offset(0, 4))
                          ]),
                      child: TabBar(
                        physics: const BouncingScrollPhysics(),
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        splashBorderRadius: BorderRadius.circular(8),
                        splashFactory: NoSplash.splashFactory,
                        overlayColor:
                            const MaterialStatePropertyAll(Colors.transparent),
                        unselectedLabelColor: getUnselectedLabelColor(context),
                        labelColor: const Color(0xff434343),
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
                        ),
                        tabs: [
                          Tab(
                            height: dW * .1,
                            child: Text(
                              language['scanBarcode'],
                              style: const TextStyle(
                                  fontSize: 12, fontFamily: 'Inter'),
                              // language['pending'],
                            ),
                          ),
                          Tab(
                            height: dW * .1,
                            child: Text(
                              language['transactionsHistory'],
                              style: const TextStyle(
                                  fontSize: 12, fontFamily: 'Inter'),
                            ),
                          ),
                        ],
                        controller: _tabController,
                      ),
                    ),
                  ),
                  Flexible(
                    child: TabBarView(
                      physics: const BouncingScrollPhysics(),
                      controller: _tabController,
                      children: [
                        scanBarcode(),
                        // transactionHistory(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: dW * horizontalPaddingFactor),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: transaction.isEmpty
                                ? EmptyListWidget(
                                    text: language['noTransactionsYet'],
                                    topPadding: 0.2)
                                : isLoading
                                    ? Container(
                                        margin: EdgeInsets.only(top: dW * 0.1),
                                        child: const CircularLoader(),
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: dW * .08),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextWidget(
                                                title: language[
                                                    'transactionHistory'],
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                              ),
                                              GestureDetector(
                                                onTap: () => push(NamedRoute
                                                    .allTransactionScreen),
                                                child: Row(
                                                  children: [
                                                    TextWidget(
                                                      title:
                                                          language['viewAll'],
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: const Color(
                                                          0xffAAABB5),
                                                    ),
                                                    const Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: Color(0xffAAABB5),
                                                      size: 15,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: dW * 0.04,
                                          ),
                                          ...transaction.take(4).map(
                                                (transaction) =>
                                                    TransactionWidget(
                                                  transaction: transaction,
                                                ),
                                              ),
                                        ],
                                      ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => addMoneyBottomSheet(),
        backgroundColor: const Color(0xff272559),
        label: TextWidget(
          title: language['addMoney'],
          color: white,
          fontWeight: FontWeight.w500,
        ),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

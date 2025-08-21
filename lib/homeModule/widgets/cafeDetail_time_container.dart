import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iteeha_app/authModule/providers/auth_provider.dart';
import 'package:iteeha_app/colors.dart';
import 'package:iteeha_app/common_functions.dart';
import 'package:iteeha_app/common_widgets/text_widget.dart';
import 'package:iteeha_app/homeModule/models/cafe_model.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CafeDetailTimeContainer extends StatefulWidget {
  Cafe cafe;
  CafeDetailTimeContainer({super.key, required this.cafe});

  @override
  State<CafeDetailTimeContainer> createState() =>
      _CafeDetailTimeContainerState();
}

class _CafeDetailTimeContainerState extends State<CafeDetailTimeContainer> {
  Map language = {};
  double dW = 0.0;
  double tS = 0.0;
  TextTheme get textTheme => Theme.of(context).textTheme;
  bool isOpen = true;
  late String currentDay;
  num? nextCafeStartTiming;
  String? nextOpeningDay;

  String getCurrentDayName() {
    return DateFormat('EEEE').format(DateTime.now());
  }

  Map<String, String> getTimingsForToday() {
    String currentDay = getCurrentDayName();
    int index =
        widget.cafe.timings.indexWhere((timing) => timing['day'] == currentDay);

    if (index != -1) {
      String startTime = widget.cafe.timings[index]['startTime'].toString();
      String endTime = widget.cafe.timings[index]['endTime'].toString();
      return {'startTime': startTime, 'endTime': endTime};
    } else {
      return {'startTime': '--', 'endTime': '--'};
    }
  }

  // String convertDecimalTimeTo12HourFormat(double decimalTime) {
  //   int hours = decimalTime.floor();
  //   double minutesDecimal = (decimalTime - hours) * 60;
  //   int minutes = minutesDecimal.round();
  //   if (minutes == 60) {
  //     minutes = 0;
  //     hours += 1;
  //   }

  //   String period = hours >= 12 ? 'PM' : 'AM';

  //   if (hours > 12) {
  //     hours -= 12;
  //   }

  //   String timeIn12HourFormat =
  //       '$hours:${minutes.toString().padLeft(2, '0')} $period';
  //   return timeIn12HourFormat;
  // }

  setNextOpening(int index) {
    for (int i = index; i < widget.cafe.timings.length; i++) {
      if (widget.cafe.timings[i]['status'] == 'OPEN') {
        nextCafeStartTiming = widget.cafe.timings[i]['startTime'];
        if (i != index) {
          nextOpeningDay = widget.cafe.timings[i]['day'];
        }
        break;
      }
    }

    if (nextCafeStartTiming == null) {
      for (int j = 0; j < widget.cafe.timings.length; j++) {
        if (widget.cafe.timings[j]['status'] == 'OPEN') {
          nextCafeStartTiming = widget.cafe.timings[j]['startTime'];
          nextOpeningDay = widget.cafe.timings[j]['day'];
          break;
        }
      }
    }
  }

  bool isCafeOpen() {
    int i = widget.cafe.timings.indexWhere(
      (timing) => timing['day'] == getCurrentDayName(),
    );
    if (i == -1) {
      return false;
    } else {
      if (widget.cafe.timings[i]['status'] == 'OPEN' &&
          DateTime.now().isAfter(
              convertNumberToDate(widget.cafe.timings[i]['startTime'])) &&
          DateTime.now().isBefore(
              convertNumberToDate(widget.cafe.timings[i]['endTime']))) {
        return true;
      } else if (widget.cafe.timings[i]['status'] == 'CLOSE') {
        setNextOpening(i);
        return false;
      } else {
        return false;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    currentDay = getCurrentDayName();
    isOpen = isCafeOpen();
  }

  @override
  Widget build(BuildContext context) {
    dW = MediaQuery.of(context).size.width;
    tS = MediaQuery.of(context).textScaleFactor;
    language = Provider.of<AuthProvider>(context).selectedLanguage;
    Map<String, String> timings = getTimingsForToday();
    String formattedStartTime = convertToTime(double.tryParse(
            (nextCafeStartTiming ?? timings['startTime']).toString()) ??
        0.0);
    String formattedEndTime =
        convertToTime(double.tryParse(timings['endTime'].toString()) ?? 0.0);

    return Container(
      margin: EdgeInsets.only(top: dW * 0.01),
      padding: EdgeInsets.only(top: dW * 0.1, bottom: dW * 0.03),
      decoration: const BoxDecoration(
        color: white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      // height: dW * 0.28,
      width: dW,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isOpen
              ? TextWidget(
                  title: language['open'],
                  color: greenColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                )
              : TextWidget(
                  title: language['closed'],
                  color: redColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
          // if (isOpen) ...[
          SizedBox(width: dW * 0.02),
          const Icon(
            Icons.circle,
            color: Color(0xffD9D9D9),
            size: 6,
          ),
          SizedBox(width: dW * 0.02),
          isOpen
              ? Row(
                  children: [
                    TextWidget(
                      title: language['closes'],
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    TextWidget(
                      title: formattedEndTime,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    )
                  ],
                )
              : Row(
                  children: [
                    TextWidget(
                      title: language['opens'],
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    if (nextOpeningDay != null)
                      TextWidget(
                        title: ' ${nextOpeningDay!}, ',
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    TextWidget(
                      title: formattedStartTime,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    )
                  ],
                ),
          // ]
        ],
      ),
    );
  }
}

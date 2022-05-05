import 'package:flutter/material.dart';
import 'package:money_app/utils/calculate.dart';
import 'package:money_app/utils/extension.dart';
import 'package:money_app/widgets/chart_widget.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(right: 15.0, top: 15.0, left: 5.0),
                child: Text(
                  'Manage transactions in euros',
                  style: TextStyle(
                      fontSize: ScreenSize(context).screenWidth < 1004
                          ? 14
                          : ScreenSize(context).screenWidth * 0.01),
                ),
              ),
              MoneyInfoWidget(
                firstText: 'Received today :',
                firstPrice: Calculate.dToday().toString(),
                secondText: 'Payment today :',
                secondPrice: Calculate.pToday().toString(),
              ),
              MoneyInfoWidget(
                firstText: 'Received this month :',
                firstPrice: Calculate.dMonth().toString(),
                secondText: 'Payment this month :',
                secondPrice: Calculate.pMonth().toString(),
              ),
              MoneyInfoWidget(
                firstText: 'Received this year :',
                firstPrice: Calculate.dYear().toString(),
                secondText: 'Payment this year :',
                secondPrice: Calculate.pYear().toString(),
              ),
              const SizedBox(height: 20),
              Calculate.dYear() == 0 && Calculate.pYear() == 0
                  ? Container()
                  : Container(
                      padding: const EdgeInsets.all(20.0),
                      height: 200,
                      child: const BarChartWidget(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

//! Money Info Widget
class MoneyInfoWidget extends StatelessWidget {
  final String firstText;
  final String secondText;
  final String firstPrice;
  final String secondPrice;

  const MoneyInfoWidget({
    Key? key,
    required this.firstText,
    required this.secondText,
    required this.firstPrice,
    required this.secondPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, top: 20.0, left: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              secondPrice,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: ScreenSize(context).screenWidth < 1004
                      ? 14
                      : ScreenSize(context).screenWidth * 0.01),
            ),
          ),
          Expanded(
            child: Text(
              secondText,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: ScreenSize(context).screenWidth < 1004
                      ? 14
                      : ScreenSize(context).screenWidth * 0.01),
            ),
          ),
          Expanded(
            child: Text(
              firstPrice,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: ScreenSize(context).screenWidth < 1004
                      ? 14
                      : ScreenSize(context).screenWidth * 0.01),
            ),
          ),
          Expanded(
            child: Text(
              firstText,
              style: TextStyle(
                  fontSize: ScreenSize(context).screenWidth < 1004
                      ? 14
                      : ScreenSize(context).screenWidth * 0.01),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_app/utils/extension.dart';
import '../constant.dart';
import '../main.dart';
import '../models/money.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class NewTransactionsScreen extends StatefulWidget {
  const NewTransactionsScreen({Key? key}) : super(key: key);
  static int groupId = 0;
  static TextEditingController descriptionController = TextEditingController();
  static TextEditingController priceController = TextEditingController();
  static bool isEditing = false;
  static int id = 0;
  static String date = 'Date';
  @override
  _NewTransactionsScreenState createState() => _NewTransactionsScreenState();
}

class _NewTransactionsScreenState extends State<NewTransactionsScreen> {
  Box<Money> hiveBox = Hive.box<Money>('moneyBox');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                NewTransactionsScreen.isEditing
                    ? 'Edit transaction'
                    : 'New transaction',
                style: TextStyle(
                    fontSize: ScreenSize(context).screenWidth < 1004
                        ? 14
                        : ScreenSize(context).screenWidth * 0.015),
              ),
              MyTextField(
                hintText: 'Description',
                controller: NewTransactionsScreen.descriptionController,
              ),
              MyTextField(
                hintText: 'Amount',
                type: TextInputType.number,
                controller: NewTransactionsScreen.priceController,
              ),
              const SizedBox(height: 20),
              const TypeAndDateWidget(),
              const SizedBox(height: 20),
              MyButton(
                text: NewTransactionsScreen.isEditing
                    ? 'Edit'
                    : 'Add',
                onPressed: () {
                  //
                  Money item = Money(
                    id: Random().nextInt(99999999),
                    title: NewTransactionsScreen.descriptionController.text,
                    price: NewTransactionsScreen.priceController.text,
                    date: NewTransactionsScreen.date,
                    isReceived:
                        NewTransactionsScreen.groupId == 1 ? true : false,
                  );
                  //
                  if (NewTransactionsScreen.isEditing) {
                    int index = 0;
                    MyApp.getData();
                    for (int i = 0; i < hiveBox.values.length; i++) {
                      if (hiveBox.values.elementAt(i).id ==
                          NewTransactionsScreen.id) {
                        index = i;
                      }
                    }

                    hiveBox.putAt(index, item);
                  } else {
                    //HomeScreen.moneys.add(item);
                    hiveBox.add(item);
                  }
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

//! MyButton
class MyButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const MyButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: TextButton.styleFrom(
          backgroundColor: kPurpleColor,
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}

//! Type And Date Widget
class TypeAndDateWidget extends StatefulWidget {
  const TypeAndDateWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<TypeAndDateWidget> createState() => _TypeAndDateWidgetState();
}

class _TypeAndDateWidgetState extends State<TypeAndDateWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: MyRadioButton(
            value: 1,
            groupValue: NewTransactionsScreen.groupId,
            onChanged: (value) {
              setState(() {
                NewTransactionsScreen.groupId = value!;
              });
            },
            text: 'Received',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: MyRadioButton(
            value: 2,
            groupValue: NewTransactionsScreen.groupId,
            onChanged: (value) {
              setState(() {
                NewTransactionsScreen.groupId = value!;
              });
            },
            text: 'Payment',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 50,
            child: OutlinedButton(
              onPressed: () async {
                var pickedDate = await showPersianDatePicker(
                  context: context,
                  initialDate: Jalali.now(),
                  firstDate: Jalali(1400),
                  lastDate: Jalali(1499),
                );
                setState(() {
                  String year = pickedDate!.year.toString();
                  //
                  String month = pickedDate.month.toString().length == 1
                      ? '0${pickedDate.month.toString()}'
                      : pickedDate.month.toString();
                  //
                  String day = pickedDate.day.toString().length == 1
                      ? '0${pickedDate.day.toString()}'
                      : pickedDate.day.toString();
                  //
                  NewTransactionsScreen.date = year + '/' + month + '/' + day;
                });
              },
              child: Text(
                NewTransactionsScreen.date,
                style: TextStyle(
                  fontSize: ScreenSize(context).screenWidth < 1004
                      ? 14
                      : ScreenSize(context).screenWidth * 0.01,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//! My Radio Button
class MyRadioButton extends StatelessWidget {
  final int value;
  final int groupValue;
  final Function(int?) onChanged;
  final String text;

  const MyRadioButton(
      {Key? key,
      required this.value,
      required this.groupValue,
      required this.onChanged,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Radio(
            activeColor: kPurpleColor,
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
                fontSize: ScreenSize(context).screenWidth < 1004
                    ? 14
                    : ScreenSize(context).screenWidth * 0.01),
          ),
        ),
      ],
    );
  }
}

//! My TextField
class MyTextField extends StatelessWidget {
  final String hintText;
  final TextInputType type;
  final TextEditingController controller;
  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.type = TextInputType.text,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: type,
      cursorColor: Colors.black38,
      decoration: InputDecoration(
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
            fontSize: ScreenSize(context).screenWidth < 1004
                ? 14
                : ScreenSize(context).screenWidth * 0.012),
      ),
    );
  }
}

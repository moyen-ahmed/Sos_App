import 'package:flutter/material.dart';

const Color kColorDarkRed = Color(0xFFB83B5E);
const Color kColorLightRed = Color(0xFFE23E57);
const Color kColorRed = Color(0xFFCC2029);
const Color kColorLightRed1 = Color(0xFFf67280);
const Color kLightBackground = Color(0xFFF5F5F5);
const Color kColorLightBlue = Color(0xFFA7CAFC);
const Color kColorViolet = Color(0xFFAB40CA);
const Color darkGrey = Color(0xff707070);
const Color darkGreen = Color(0xff13D900);
const Color lightGrey = Color(0xff13D900);

void goTo(BuildContext context, Widget nextScreen) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => nextScreen,
      ));
}

void dialogueBox(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Error"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("OK"),
        ),
      ],
    ),
  );
}
alertbox(BuildContext context,String text){
  showDialog(context: context, builder: (context) => AlertDialog(
    title: Text(text),
  ),);
}
// progressIndicator(BuildContext context) {
//   showDialog(
//     barrierDismissible: false,
//     context: context,
//     builder: (context) => Center(child: CircularProgressIndicator(
//       backgroundColor: kColorRed,
//       color: Colors.tealAccent,
//       strokeWidth: 7,
//     )),);
// }
Widget progressIndicator(BuildContext context) {
  return Center(
      child: CircularProgressIndicator(
        backgroundColor: kColorRed,
        color: Colors.red,
        strokeWidth: 7,
      ));
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sos_app/utils/quotes.dart';

class CustomAppbar extends StatelessWidget {
  //const CustomAppbar({super.key});
  Function? onTap;
  int? quoteIndex;
  CustomAppbar({this.onTap,this.quoteIndex});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap!();
      },
      child: Container(
          child: Text(
            sweetSayings[quoteIndex!],
            style: TextStyle(
                fontSize: 22),
          )
      ),
    );

  }
}

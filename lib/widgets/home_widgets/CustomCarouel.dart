import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sos_app/utils/quotes.dart';

class Customcarouel extends StatelessWidget {
  const Customcarouel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 2.0,
          autoPlay: true,
        ),
          items:List.generate(imageSliders.length,
                (index)=>Card(
                  elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                    ),
               child:Container(
                 decoration: BoxDecoration(
                   image: DecorationImage(image: NetworkImage(imageSliders[index]))
                 ),
               ) ,
                ),
          ) ,

      ),
    );
  }
}

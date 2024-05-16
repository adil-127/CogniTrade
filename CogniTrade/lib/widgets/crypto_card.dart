import '../core/res/color.dart';
// import '../views/home.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.cardColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(children: [
        const PositionedCircle(
          size: 240,
          left: -100,
          top: -100,
        ),
        const PositionedCircle(
          size: 220,
          bottom: -160,
          left: 55,
        ),
        const PositionedCircle(
          size: 180,
          top: -100,
          right: -100,
        ),
        Stack(
          // alignment: AlignmentDirectional.topCenter,
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Spacer(),
                  const Spacer(),
                  const Spacer(),
        
        
        
                  Row(
                    children: [
                      // Icon(
                      //   Icons.currency_exchange,
                      //   color: Colors.blue[100],
                      // ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        "Simulation Trading Bot",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      "CogniTrade",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -40,
              left: 65,
              child: Image.asset("assets/image/cogni.png",width: 200,))
          ],
        )
      ]),
    );
  }
}

class PositionedCircle extends StatelessWidget {
  final double? top, bottom, left, right;
  final double size;
  const PositionedCircle({
    Key? key,
    this.top,
    this.bottom,
    this.left,
    this.right,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      bottom: bottom,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.001),
              spreadRadius: 50,
              blurRadius: 0,
            )
          ],
          color:  Colors.blue.withOpacity(0.5),
          //     shape: BoxShape.circle,
        ),
      ),
    );
  }
}

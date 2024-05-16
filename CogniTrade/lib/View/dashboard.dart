
import 'dart:math';

import 'package:crypto/controllers/card_controller.dart';
import 'package:crypto/controllers/portfolio_coin_controller.dart';
import 'package:get/get.dart';

import '../../core/res/color.dart';
import '../../core/res/particles.dart';
import 'package:crypto/Model/particle.dart';
import 'package:crypto/Model/spline_area.dart';

import '../../widgets/credit_painter.dart';
import '../../widgets/crypto_card.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DashboardScreen extends StatefulWidget {
  
  const DashboardScreen({Key? key,}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
      CardController controller=Get.put(CardController());
      PortfolioCoinController portfoliocontroller=Get.put(PortfolioCoinController());
      
  List<Particle> _particlesList = [];
  final Random _random = Random(DateTime.now().millisecondsSinceEpoch);
  final maxSpeed = 2;
  final maxTheta = 2 * pi;
  final maxRadius = 10;
  late AnimationController _particleAnimationController;
  late Animation<double> _particleAnimation;
  List<SplineAreaData>? firstChartData, secondChartData;

  @override
  initState() {
    controller.fetchCardDetails();
    portfoliocontroller.fetchUserData();
    super.initState();
    firstChartData = <SplineAreaData>[
      SplineAreaData(2010, 8.53, 3.3),
      SplineAreaData(2011, 9.5, 5.4),
      SplineAreaData(2012, 10, 2.65),
      SplineAreaData(2013, 9.4, 2.62),
      SplineAreaData(2014, 5.8, 1.99),
      SplineAreaData(2015, 4.9, 1.44),
      SplineAreaData(2016, 4.5, 2),
      SplineAreaData(2017, 3.6, 1.56),
      SplineAreaData(2018, 3.43, 2.1),
    ];
    secondChartData = <SplineAreaData>[
      SplineAreaData(2010, 4.53, 3.3),
      SplineAreaData(2011, 8.5, 5.4),
      SplineAreaData(2012, 2, 2.65),
      SplineAreaData(2013, 9.4, 2.62),
      SplineAreaData(2014, 5.8, 1.99),
      SplineAreaData(2015, 4.9, 1.44),
      SplineAreaData(2016, 4.5, 2),
      SplineAreaData(2017, 9.6, 1.56),
      SplineAreaData(2018, 12.43, 2.1),
    ];

    _particleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _particleAnimation =
        Tween<double>(begin: 0, end: 300).animate(_particleAnimationController)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _particleAnimationController.repeat();
            } else if (status == AnimationStatus.dismissed) {
              _particleAnimationController.forward();
            }
          });
    _particleAnimationController.forward();

    _particlesList = List.generate(5, (index) {
      final color = ParticleGenerator.getRandomColor(_random);
      return Particle(
        position: const Offset(-1, -1),
        color: color,
        speed: _random.nextDouble() * maxSpeed,
        theta: _random.nextDouble() * maxTheta,
        radius: _random.nextDouble() * maxRadius,
      );
    }).toList();
  }

  @override
  void dispose() {
    _particleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.yellow[200],
      body: SingleChildScrollView(
        
        child: Container(
          height: 100.h,
        decoration: BoxDecoration(
          //  color: Colors.yellow[200]
          gradient: AppColors.getLinearGradient(Colors.amber),
          
          
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Column(
            children: [
              SizedBox(
                height: 70,
              ),
              const CryptoCard(),
              const SizedBox(
                height: 20,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: [
              //     Icons.send,
              //     Icons.download,
              //     Icons.qr_code_scanner_sharp,
              //     Icons.settings,
              //   ]
              //       .map((e) => Container(
              //             margin: const EdgeInsets.all(10),
              //             padding: const EdgeInsets.all(16),
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(10),
              //               border: Border.all(
              //                 color: Colors.black.withOpacity(0.2),
              //                 width: 2,
              //               ),
              //             ),
              //             child: Icon(
              //               e,
              //               color: Colors.black.withOpacity(0.8),
              //               size: 20,
              //             ),
              //           ))
              //       .toList(),
              // ),
              const SizedBox(
                height: 70,
              ),
              Container(
                width: 100.w,
                height: 210,
                decoration: BoxDecoration(
                  gradient: AppColors.getDarkLinearGradient(Colors.blue),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomPaint(
                  painter: CreditCardPainter(
                    _particleAnimation.value,
                    particlesList: _particlesList,
                    random: _random,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                  
                       _buildCardWidget(context,controller), // Build card widget based on cardDetails
                      ],
                    ),
                  ),
                ),
              ),
             
            ],
          ),
        ),
      ),
    );
  }









Widget _buildCardWidget( BuildContext context,CardController cardController) {
  if (cardController.cardDetails.value.cardNumber.isEmpty) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          "Add Credit / Debit Card",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "VISA / Mastercard",
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontWeight: FontWeight.w300,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: 
          GestureDetector(
            onTap: () {
              _showPopup(context, cardController);
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 18,
            ),
          ),
        )
      ],
    );
  } else {
    // Show updated card details
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          " ${cardController.cardDetails.value.cardNumber}",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 1.6,
          ),
        ),
        const SizedBox(height: 30),
         Text(
          "Amount: ${cardController.cardDetails.value.amount}",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 1.6,
          ),
        ),
         const SizedBox(height: 10),
         Text(
          "Portfolio: ${portfoliocontroller.portfolio.value}",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 1.6,
          ),
        ),
         
        const SizedBox(height: 50),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Text(
          "Expiry Date: ${cardController.cardDetails.value.expiryDate}",
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontWeight: FontWeight.w300,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),

           Text(
          "cvv: ${cardController.cardDetails.value.cvv}",
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontWeight: FontWeight.w300,
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
          ],
        ),
       
       
        // Add other card details here...
      ],
    );
  }
}







void _showPopup(BuildContext context, CardController cardController) {
  String cardNumber = '';
  String expiryDate = '';
  String cvv = '';
  double amount = 0.0;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: AlertDialog(
          title: Text('Enter Debit Card Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Card Number'),
                onChanged: (num) {
                  cardNumber = num;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Expiry Date'),
                onChanged: (exp) {
                  expiryDate = exp;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'CVV'),
                onChanged: (cvvD) {
                  cvv = cvvD;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  amount = double.tryParse(value) ?? 0.0;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async{
                // Access CardController and update amount
                cardController.updateAmount(amount);
                cardController.updatecardNumber(cardNumber);
                cardController.updatecvv(cvv);
                cardController.updateexpiryDate(expiryDate);    
                await cardController.saveCardDetails();
        
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      );
    },
  );
}
    }
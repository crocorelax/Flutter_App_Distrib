import 'package:flutter/material.dart';

class SwapIndicator extends StatelessWidget {
  final int currentIndex;

  const SwapIndicator({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 4,
          width: double.infinity,
          color: Colors.grey.shade300,
        ),
        AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          alignment: currentIndex == 0 ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            height: 4,
            width: MediaQuery.of(context).size.width / 2,
            color: const Color(0xFF2B626E),
          ),
        ),
      ],
    );
  }
}
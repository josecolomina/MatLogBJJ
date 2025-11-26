import 'package:flutter/material.dart';
import '../features/authentication/domain/belt_info.dart';

class BeltDisplayWidget extends StatelessWidget {
  final BeltInfo beltInfo;
  final double height;
  final double width;

  const BeltDisplayWidget({
    super.key,
    required this.beltInfo,
    this.height = 24,
    this.width = 100,
  });

  @override
  Widget build(BuildContext context) {
    final isBlackBelt = beltInfo.color == BeltColor.black;
    final tipColor = isBlackBelt ? Colors.red : Colors.black;

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: beltInfo.color.colorValue,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Black/Red Tip
          Container(
            width: width * 0.25, // Tip takes 25% of width
            height: height,
            decoration: BoxDecoration(
              color: tipColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(beltInfo.stripes, (index) {
                return Container(
                  width: 4,
                  height: height * 0.8,
                  color: Colors.white,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

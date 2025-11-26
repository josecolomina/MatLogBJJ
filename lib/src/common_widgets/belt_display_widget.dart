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
            child: beltInfo.stripes > 0
                ? (beltInfo.stripes > 4
                    ? Center(
                        child: Text(
                          '${beltInfo.stripes}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(beltInfo.stripes, (index) {
                          return Flexible(
                            child: Container(
                              width: 3,
                              margin: const EdgeInsets.symmetric(horizontal: 0.5),
                              height: height * 0.7,
                              color: Colors.white,
                            ),
                          );
                        }),
                      ))
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

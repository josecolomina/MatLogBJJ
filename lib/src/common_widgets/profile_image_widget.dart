import 'package:flutter/material.dart';
import '../features/authentication/domain/belt_info.dart';

import 'dart:io';

class ProfileImageWidget extends StatelessWidget {
  final String? photoUrl;
  final File? imageFile;
  final BeltInfo? beltInfo;
  final double radius;

  const ProfileImageWidget({
    super.key,
    this.photoUrl,
    this.imageFile,
    this.beltInfo,
    this.radius = 20,
  });

  String get _defaultImage {
    if (beltInfo == null) return 'assets/images/kimono_white_belt.png';
    
    switch (beltInfo!.color) {
      case BeltColor.white:
        return 'assets/images/kimono_white_belt.png';
      case BeltColor.blue:
        return 'assets/images/kimono_blue_belt.png';
      case BeltColor.purple:
        return 'assets/images/kimono_purple_belt.png';
      case BeltColor.brown:
        return 'assets/images/kimono_brown_belt.png';
      case BeltColor.black:
        return 'assets/images/kimono_black_belt.png';
        return 'assets/images/kimono_black_belt.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imageFile != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: FileImage(imageFile!),
        backgroundColor: Colors.grey[200],
      );
    }

    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(photoUrl!),
        backgroundColor: Colors.grey[200],
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.transparent, // Transparent for PNGs
      backgroundImage: AssetImage(_defaultImage),
    );
  }
}

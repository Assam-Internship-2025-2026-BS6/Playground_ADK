import 'package:flutter/material.dart';
import 'landing_form.dart';

class RightLoginContainer extends StatelessWidget {
  final double? width;
  final double? height;

  const RightLoginContainer({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/right_back.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: LandingFormOrganism(
            width: double.infinity,
            height: height ?? 750,
            tintColor: const Color(0x33FFFFFF), // Translucent glass effect
          ),
        ),
      ),
    );
  }
}
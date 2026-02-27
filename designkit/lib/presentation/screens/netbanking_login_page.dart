import 'package:flutter/material.dart';
import '../../components/organisms/left_info_section.dart';
import '../../components/organisms/right_login_container.dart';

class NetBankingLoginPage extends StatelessWidget {
  final double width;
  final double height;

  const NetBankingLoginPage({
    super.key,
    this.width = 1200,
    this.height = 720,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: Row(
          children: const [
            // Left Panel: Info Section (Blue Background)
            Expanded(flex: 1, child: LeftInfoSection()),
            // Right Panel: Login Form (Starry Background)
            Expanded(flex: 1, child: RightLoginContainer()),
          ],
        ),
      ),
    );
  }
}
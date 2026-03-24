import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'components/profile_header.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.cardColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(), // header (already has vertical spacing)
            // ProfileMenuOptions(),   // menu options
          ],
        ),
      ),
    );
  }
}

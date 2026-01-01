import 'package:flutter/material.dart';
import 'package:grocery/core/constants/apiCall.dart';
import 'package:grocery/core/models/userModel.dart';

import '../../../core/components/network_image.dart';
import '../../../core/constants/constants.dart';
import 'profile_header_options.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = getUser(); // directly assign the future
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Background
        Image.asset('assets/images/profile_page_background.png'),

        /// Content
        Column(
          children: [
            AppBar(
              title: const Text('Profile'),
              elevation: 0,
              automaticallyImplyLeading:false,
              backgroundColor: Colors.transparent,
              titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            FutureBuilder<User>(
              future: _userFuture,
              builder: (context, snapshot) {
                debugPrint('SNAPSHOT: $snapshot');

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(color: Colors.white);
                }

                if (!snapshot.hasData) {
                  return const Text(
                    'User data not available',
                    style: TextStyle(color: Colors.white),
                  );
                }

                return UserData(user: snapshot.data!);
              },
            ),
            const ProfileHeaderOptions(),
          ],
        ),
      ],
    );
  }
}

class UserData extends StatelessWidget {
  final User user;

  const UserData({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: AppDefaults.padding),

          /// Profile Image
          SizedBox(
            width: 100,
            height: 100,
            child: ClipOval(
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: NetworkImageWithLoader(
                  user.profileImagePath ?? '',
                ),
              ),
            ),
          ),

          const SizedBox(width: AppDefaults.padding),

          /// Text area MUST be Expanded
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


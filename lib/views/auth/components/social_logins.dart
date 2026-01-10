
import 'package:EazySupplies/core/constants/app_defaults.dart';
import 'package:EazySupplies/core/constants/app_icons.dart';
import 'package:EazySupplies/core/enums/login_type.dart';
import 'package:EazySupplies/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialLogins extends StatelessWidget {
  final LoginType loginType;

  const SocialLogins({
    super.key,
    required this.loginType,
  });

  @override
  Widget build(BuildContext context) {
    final otherTypes =
        LoginType.values.where((type) => type != loginType).toList();

    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Row(
        children: otherTypes.map((type) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDefaults.margin / 2,
              ),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.login,
                    arguments: type,
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.black),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDefaults.padding * 2,
                    vertical: AppDefaults.padding,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      _icon(type),
                      width: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _label(type),
                      style:
                          Theme.of(context).textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ---- Helpers ----

  String _label(LoginType type) {
    switch (type) {
      case LoginType.email:
        return 'Email';
      case LoginType.phone:
        return 'Phone';
      case LoginType.gst:
        return 'GST';
    }
  }

  String _icon(LoginType type) {
    switch (type) {
      case LoginType.email:
        return AppIcons.googleIconRounded;
      case LoginType.phone:
        return AppIcons.appleIconRounded;
      case LoginType.gst:
        return AppIcons.appleIconRounded;
    }
  }
}



// import 'package:EazySupplies/core/enums/login_type.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// import '../../../core/constants/constants.dart';

// class SocialLogins extends StatelessWidget {
//   final LoginType loginType;
//   const SocialLogins({super.key, required this.loginType});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(AppDefaults.padding),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Expanded(
//             if(widget.loginType === LoginType.email) ...[
//             child: OutlinedButton(
//               onPressed: () {},
//               style: OutlinedButton.styleFrom(
//                 side: const BorderSide(color: Colors.red),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: AppDefaults.padding * 2,
//                   vertical: AppDefaults.padding,
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SvgPicture.asset(
//                     AppIcons.googleIconRounded,
//                     width: 24,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Email',
//                     style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                           color: Colors.red,
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(width: AppDefaults.margin),
//         ],
//         if(widget.loginType === LoginType.email) ...[
//           Expanded(
//             child: OutlinedButton(
//               onPressed: () {},
//               style: OutlinedButton.styleFrom(
//                 side: const BorderSide(color: Colors.black),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: AppDefaults.padding * 2,
//                   vertical: AppDefaults.padding,
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SvgPicture.asset(
//                     AppIcons.appleIconRounded,
//                     width: 24,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Phone',
//                     style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(width: AppDefaults.margin),
//         ],
//         if(widget.loginType === LoginType.email) ...[
//           Expanded(
//             child: OutlinedButton(
//               onPressed: () {},
//               style: OutlinedButton.styleFrom(
//                 side: const BorderSide(color: Colors.black),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: AppDefaults.padding * 2,
//                   vertical: AppDefaults.padding,
//                 ),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SvgPicture.asset(
//                     AppIcons.appleIconRounded,
//                     width: 24,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     'GST',
//                     style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ]
//         ],
//       ),
//     );
//   }
// }

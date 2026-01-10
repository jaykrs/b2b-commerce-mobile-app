import 'package:EazySupplies/core/constants/app_icons.dart';

enum LoginType {
  email,
  phone,
  gst,
}


extension LoginTypeX on LoginType {
  String get label {
    switch (this) {
      case LoginType.email:
        return 'Email';
      case LoginType.phone:
        return 'Phone';
      case LoginType.gst:
        return 'GST';
    }
  }

  String get icon {
    switch (this) {
      case LoginType.email:
        return AppIcons.googleIconRounded;
      case LoginType.phone:
        return AppIcons.appleIconRounded;
      case LoginType.gst:
        return AppIcons.appleIconRounded;
    }
  }
}


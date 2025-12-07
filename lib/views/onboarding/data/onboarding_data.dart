import '../../../core/constants/app_images.dart';
import 'onboarding_model.dart';

class OnboardingData {
  static List<OnboardingModel> items = [
    OnboardingModel(
      imageUrl: AppImages.onboarding1,
      headline: 'Browse all the category',
      description:
          'Discover deals, essentials, and top-selling products...',
    ),
    OnboardingModel(
      imageUrl: AppImages.onboarding2,
      headline: 'Amazing Discounts & Offers',
      description:
          'Limited-time deals—don’t miss your chance to save!...',
    ),
    OnboardingModel(
      imageUrl: AppImages.onboarding3,
      headline: 'Fastest Delivery',
      description:
          'Get your orders delivered to your doorstep in record time...',
    ),
  ];
}

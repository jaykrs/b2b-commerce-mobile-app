import 'package:EazySupplies/core/utils/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/constants.dart';

class CardDetails extends StatelessWidget {
  const CardDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name Field
          const Text("Card Name"),
          SizedBox(height: Responsive.hp(context, 8 / 8)),
          TextFormField(
            keyboardType: TextInputType.number,
            // validator: Validators.requiredWithFieldName('Card'),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppDefaults.padding),

          // Number Field
          const Text("Card Number"),
          SizedBox(height: Responsive.hp(context, 8 / 8)),
          TextFormField(
            keyboardType: TextInputType.number,
            // validator: Validators.requiredWithFieldName('Card Number'),
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppDefaults.padding),

          /* <---- Expiration Date And CVV -----> */
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Number Field
                    const Text("Expiration Date"),
                    SizedBox(height: Responsive.hp(context, 8 / 8)),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      // validator: Validators.requiredWithFieldName('Card'),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppDefaults.padding),
                  ],
                ),
              ),
              SizedBox(width: Responsive.wp(context, 16 / 4)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Number Field
                    const Text("CVV"),
                    SizedBox(height: Responsive.hp(context, 8 / 8)),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      // validator: Validators.requiredWithFieldName('Card'),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppDefaults.padding),
                  ],
                ),
              ),
            ],
          ),

          Row(
            children: [
              Text(
                'Remember My Card Details',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.black),
              ),
              const Spacer(),
              CupertinoSwitch(value: true, onChanged: (v) {})
            ],
          )
        ],
      ),
    );
  }
}

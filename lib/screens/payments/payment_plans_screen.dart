import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/widgets/common/buttons/offset_full_button.dart';
import 'package:catchmflixx/widgets/common/flex/flex_items.dart';
import 'package:catchmflixx/widgets/payments/payment_basic.dart';
import 'package:catchmflixx/widgets/settings/settings_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentsPlansScreen extends StatelessWidget {
  const PaymentsPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final translation = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 19, 24),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar.large(
            stretch: true,
            backgroundColor: Colors.black,
            title: Text(
              translation.pricingPlans,
              style: TextStyles.cardHeading,
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                )),
            expandedHeight: size.height / 3,
            flexibleSpace: SettingsTopBar(
              plans: translation.pricingPlans,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: FlexItems(widgetList: [
                  PaymentBasic(
                      imageUrl:
                          "https://source.unsplash.com/random/1920×1080/?night",
                      firstAmt: "₹129",
                      planName: translation.premiumPlan,
                      firstDet: translation.premiumOne,
                      secAmt: "₹50",
                      secDet: translation.premiumTwo,
                      styleIcon: Icons.star,
                      color: const Color(0xFFFFF5A0)),
                  PaymentBasic(
                      imageUrl:
                          "https://source.unsplash.com/random/1920×1080/?afternoon",
                      firstAmt: "₹229",
                      planName: translation.primePlan,
                      firstDet: translation.primeOne,
                      secAmt: "₹80",
                      secDet: translation.primeTwo,
                      styleIcon: Icons.verified_outlined,
                      color: const Color(0xFFA0FFF7)),
                  PaymentBasic(
                      imageUrl:
                          "https://source.unsplash.com/random/1920×1080/?party",
                      firstAmt: "₹429",
                      planName: translation.familyPlan,
                      firstDet: translation.familyOne,
                      secAmt: "₹160",
                      styleIcon: Icons.workspace_premium,
                      secDet: translation.familyTwo,
                      color: const Color(0xFFFFA0FF)),
                  PaymentBasic(
                      imageUrl:
                          "https://source.unsplash.com/random/1920×1080/?dark+sky",
                      firstAmt: "₹0",
                      planName: "free 😎",
                      firstDet: translation.freeDet,
                      styleIcon: Icons.generating_tokens,
                      color: const Color(0xFFFFA0FF)),
                  OffsetFullButton(
                    content: translation.subscribeNow,
                    fn: () {},
                    icon: Icons.diamond,
                  )
                ], space: 20)),
          )
        ],
      ),
    );
  }
}

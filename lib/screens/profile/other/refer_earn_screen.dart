import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';
import 'package:share_plus/share_plus.dart';

class ReferEarnScreen extends StatefulWidget {
  const ReferEarnScreen({super.key});

  @override
  State<ReferEarnScreen> createState() => _ReferEarnScreenState();
}

class _ReferEarnScreenState extends State<ReferEarnScreen> {
  final String referralCode = "RUNAAR25";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text("Refer & Earn")),
      bottomNavigationBar: _shareButton(theme),
      body: SingleChildScrollView(
        padding: 10.all,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _rewardBanner(theme),
            24.height,
            _howItWorks(theme),
            24.height,
            _referralCodeCard(theme),
          ],
        ),
      ),
    );
  }

  Widget _rewardBanner(TextTheme theme) {
    return Container(
      width: double.infinity,
      padding: 20.all,
      decoration: BoxDecoration(
        borderRadius: .circular(16.r),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Earn ₹100 on every referral",
            style: theme.headlineSmall?.copyWith(color: Colors.white),
          ),
          8.height,
          Text(
            "Invite your friends and earn rewards when they complete their first ride.",
            style: theme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _howItWorks(TextTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("How it works", style: theme.titleMedium),
        12.height,
        _stepTile(theme, "1", "Share your referral code"),
        _stepTile(theme, "2", "Friend signs up using your code"),
        _stepTile(theme, "3", "You both earn rewards"),
      ],
    );
  }

  Widget _stepTile(TextTheme theme, String step, String title) {
    return Padding(
      padding: 8.all,
      child: Row(
        children: [
          CircleAvatar(
            radius: 14.h,
            backgroundColor: const Color(0XFF000000),
            child: Text(
              step,
              style: theme.labelLarge?.copyWith(color: Colors.white),
            ),
          ),
          12.width,
          Expanded(child: Text(title, style: theme.bodyMedium)),
        ],
      ),
    );
  }

  Widget _referralCodeCard(TextTheme theme) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: .circular(10.r),
        side: const BorderSide(color: Color(0XFF000000)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: 16.all,
          child: Column(
            children: [
              Text("Your Referral Code", style: theme.bodyMedium),
              5.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText(referralCode, style: theme.headlineSmall),
                  3.width,
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: referralCode));
                      appSnackbar.showSingleSnackbar(
                        context,
                        "Referral code copied",
                      );
                    },
                    child: Icon(Icons.copy, color: appColor.secondColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shareButton(TextTheme theme) {
    return BottomAppBar(
      child: SizedBox(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton(
          onPressed: _shareReferralCode,
          child: const Text("Refer a friend"),
        ),
      ),
    );
  }

  void _shareReferralCode() {
    final String message =
        "🚗 Join RunAar and earn rewards!\n\n"
        "Use my referral code: $referralCode\n\n"
        "Download the app now and start earning.";

    Share.share(message);
  }
}

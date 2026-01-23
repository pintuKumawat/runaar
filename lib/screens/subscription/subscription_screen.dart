import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/models/subscription/active_subscription_model.dart';
import 'package:runaar/models/subscription/subscription_plan_model.dart';
import 'package:runaar/provider/subscription/active_subscription_provider.dart';
import 'package:runaar/provider/subscription/subscription_provider.dart';
import 'package:runaar/screens/subscription/subscription_details_screen.dart';

class SubscriptionScreen extends StatefulWidget {
  final int userId;
  const SubscriptionScreen({super.key, required this.userId});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionProvider>().getSubscriptions();
      context
          .read<ActiveSubscriptionProvider>()
          .ActiveSubscription(userId: widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Subscriptions"),
        backgroundColor: Colors.black,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<SubscriptionProvider>().getSubscriptions();
          await context
              .read<ActiveSubscriptionProvider>()
              .ActiveSubscription(userId: widget.userId);
        },
        child: Consumer2<SubscriptionProvider, ActiveSubscriptionProvider>(
          builder: (context, provider, activeProvider, _) {
            /// 🔄 LOADING
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            /// ❌ ERROR
            if (provider.errorMessage != null) {
              return Center(
                child: Text(
                  provider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            /// EMPTY
            if (provider.response?.data == null ||
                provider.response!.data!.isEmpty) {
              return const Center(
                child: Text(
                  "No subscription plans found",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final plans = provider.response!.data!;

            return ListView(
              padding: 14.all,
              children: [
                /// 🔥 ACTIVE SUBSCRIPTION
                if (activeProvider.isLoading)
                  const Center(child: CircularProgressIndicator()),

                if (activeProvider.activeSubscription != null)
                  _activeSubscriptionCard(
                    theme,
                    activeProvider.activeSubscription!,
                  ),

                if (activeProvider.activeSubscription != null) 24.height,

                /// HEADER
                Text(
                  "Subscribe and enjoy rides",
                  style: theme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                16.height,

                /// SUBSCRIPTION LIST
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedIndex = index);
                      },
                      child: _subscriptionCard(
                        theme,
                        plan,
                        isSelected: selectedIndex == index,
                      ),
                    );
                  },
                ),

                24.height,

                /// CONTINUE BUTTON
                _planSelectButton(plans),
              ],
            );
          },
        ),
      ),
    );
  }

  /// 🔘 CONTINUE BUTTON
  Widget _planSelectButton(List<Data> plans) {
    return SizedBox(
      height: 40.h,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            appColor.backgroundColor,
          ),
        ),
        onPressed: () {
          final selectedPlan = plans[selectedIndex];
          appNavigator.push(
            SubscriptionDetailsScreen(
              plan: selectedPlan,
              userId: widget.userId,
            ),
          );
        },
        child: Text(
          "Continue",
          style: TextStyle(color: appColor.textColor),
        ),
      ),
    );
  }

  /// ✅ ACTIVE SUBSCRIPTION CARD
  Widget _activeSubscriptionCard(TextTheme theme, Message plan) {
    return Container(
      padding: 16.all,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: Colors.green.withOpacity(0.15),
        border: Border.all(color: Colors.green, width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified, color: Colors.green),
              8.width,
              Text(
                "Active Subscription",
                style: theme.titleMedium?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          12.height,

          Text(
            plan.subscriptionType ?? "",
            style: theme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          6.height,

          Text(
            plan. ?? "",
            style: theme.bodyMedium?.copyWith(
              color: Colors.grey.shade400,
            ),
          ),

          12.height,

          Row(
            children: [
              Icon(Icons.schedule, size: 14.sp, color: Colors.grey),
              6.width,
              Text(
                "${plan.} Days",
                style: theme.bodySmall?.copyWith(color: Colors.grey),
              ),
              12.width,
              Icon(Icons.directions_car, size: 14.sp, color: Colors.grey),
              6.width,
              Text(
                "${plan.totalRides} Rides",
                style: theme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ],
          ),

          12.height,

          Text(
            "₹${plan.amount}",
            style: theme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔥 SUBSCRIPTION CARD
  Widget _subscriptionCard(
    TextTheme theme,
    Data plan, {
    bool isSelected = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22.r),
        gradient: LinearGradient(
          colors: [
            appColor.subscriptionCardColor1,
            appColor.subscriptionCardColor2,
          ],
        ),
        border: Border.all(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
          width: isSelected ? 1.6 : 1,
        ),
      ),
      child: Padding(
        padding: 16.all,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.subscriptionType ?? "",
                    style: theme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  6.height,
                  Text(
                    plan.subscriptionDescription ?? "",
                    style: theme.bodyMedium?.copyWith(
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "₹${plan.amount}",
              style: theme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

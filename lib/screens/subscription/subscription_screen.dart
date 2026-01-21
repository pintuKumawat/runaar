import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/models/subscription/subscription_plan_model.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Subscriptions")),
      body: RefreshIndicator(
        onRefresh: () =>
            context.read<SubscriptionProvider>().getSubscriptions(),
        child: Consumer<SubscriptionProvider>(
          builder: (context, provider, _) {
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
            if (provider.response == null ||
                provider.response!.data == null ||
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
                /// HEADER
                Text(
                  "Subscribe and enjoy rides",
                  style: theme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                16.height,

                /// LIST
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
                _planSelectButton(plans),

                
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _planSelectButton(List<Data> plans) {
    return SizedBox(
      height: 40.h,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateColor.resolveWith(
            (states) => appColor.backgroundColor,
          ),
        ),
        onPressed: () {
          final selectedPlan = plans[selectedIndex];
          appNavigator.push(SubscriptionDetailsScreen(plan: selectedPlan,userId:widget.userId));
        },

        child: Text("Continue", style: TextStyle(color: appColor.textColor)),
      ),
    );
  }

  /// 🔥 SUBSCRIPTION CARD
  Widget _subscriptionCard(
    TextTheme theme,
    Data plan, {
    bool isSelected = false,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        /// MAIN CARD
        Container(
          margin: EdgeInsets.only(top: 22.h, bottom: 14.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                appColor.subscriptionCardColor1,
                appColor.subscriptionCardColor2,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.45),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.06),
              width: isSelected ? 1.6 : 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// LEFT CONTENT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// PLAN TITLE
                      Text(
                        plan.subscriptionType ?? " ",
                        style: theme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      6.height,

                      /// DESCRIPTION
                      Text(
                        plan.subscriptionDescription ?? "",
                        style: theme.bodyMedium?.copyWith(
                          color: Colors.grey.shade400,
                          height: 1.3,
                        ),
                      ),

                      10.height,

                      /// META INFO
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 14.sp,
                            color: Colors.grey.shade500,
                          ),
                          6.width,
                          Text(
                            "${plan.duration ?? 0} Days",
                            style: theme.bodySmall?.copyWith(
                              color: Colors.grey.shade500,
                            ),
                          ),
                          12.width,
                          Icon(
                            Icons.directions_car,
                            size: 14.sp,
                            color: Colors.grey.shade500,
                          ),
                          6.width,
                          Text(
                            "${plan.totalRides ?? 0}",
                            style: theme.bodySmall?.copyWith(
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// PRICE BADGE
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Text(
                    "₹${plan.amount.toString()}",
                    style: theme.titleMedium?.copyWith(
                      color: isSelected ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        /// 🔥 PREMIUM BADGE
        Positioned(
          top: 0,
          left: 18.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.r),
                bottomRight: Radius.circular(14.r),
              ),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8),
              ],
            ),
            child: const Text(
              "BEST VALUE • ₹1 FIRST MONTH",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 11,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

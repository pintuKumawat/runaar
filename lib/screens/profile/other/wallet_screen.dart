import 'package:flutter/material.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final double walletBalance = 450.00;

  final List<Map<String, dynamic>> transactions = [
    {
      "title": "Referral Reward",
      "date": "12 Sep 2025",
      "amount": 100,
      "isCredit": true,
    },
    {
      "title": "Ride Payment",
      "date": "10 Sep 2025",
      "amount": 150,
      "isCredit": false,
    },
    {
      "title": "Referral Reward",
      "date": "05 Sep 2025",
      "amount": 200,
      "isCredit": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text("Wallet")),
      body: SingleChildScrollView(
        padding: 10.all,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            _balanceCard(theme),
            24.height,
            Text("Transaction History", style: theme.titleMedium),
            12.height,
            _transactionList(theme),
          ],
        ),
      ),
    );
  }

  // 💰 Wallet Balance Card
  Widget _balanceCard(TextTheme theme) {
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
            "Available Balance",
            style: theme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          8.height,
          Text(
            "₹${walletBalance.toStringAsFixed(2)}",
            style: theme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // 📜 Transaction List
  Widget _transactionList(TextTheme theme) {
    if (transactions.isEmpty) {
      return Center(
        child: Text("No transactions yet", style: theme.bodyMedium),
      );
    }

    return Column(
      children: List.generate(
        transactions.length,
        (index) => _transactionTile(theme, transactions[index]),
      ),
    );
  }

  Widget _transactionTile(TextTheme theme, Map<String, dynamic> data) {
    final bool isCredit = data["isCredit"];

    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            radius: 20.r,
            backgroundColor: isCredit ? Colors.green : Colors.red,
            child: Icon(
              isCredit ? Icons.arrow_downward : Icons.arrow_upward,
              color: Colors.white,
            ),
          ),
          title: Text(data["title"], style: theme.bodyMedium),
          subtitle: Text(
            data["date"],
            style: theme.bodySmall?.copyWith(
              color: appColor.mainColor.withOpacity(.5),
            ),
          ),
          trailing: Text(
            "${isCredit ? '+' : '-'}₹${data["amount"]}",
            style: theme.bodyMedium?.copyWith(
              color: isCredit ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}

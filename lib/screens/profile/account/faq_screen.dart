import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/provider/faqs/faqs_provider.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => fetchData());
  }

  Future<void> fetchData() async {
    await context.read<FaqsProvider>().getFaqs();
  }

  List<IconData> data = [
    Icons.business,
    Icons.support_agent,
    Icons.security,
    Icons.lock_reset,
    Icons.star,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("FAQs"),
        centerTitle: true,
      ),
      body: Consumer<FaqsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: const CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage ?? ""));
          }
          return ListView.builder(
            padding: 10.all,
            itemCount: provider.response?.faqs?.length,
            itemBuilder: (context, index) {
              final item = provider.response?.faqs?[index];

              return FaqItem(
                icon: data[index % data.length],
                question: item?.title ?? "Question",
                answer: item?.description ?? "Answer",
              );
            },
          );
        },
      ),
    );
  }
}
// FaqItem(
//   icon: Icons.support_agent,
//   question: "How can I contact support?",
//   answer:
//       "You can contact support through email, WhatsApp, or in-app chat support.",
// ),
// FaqItem(
//   icon: Icons.security,
//   question: "Is my data secure?",
//   answer:
//       "Yes, we use secure servers, encryption, and industry best practices to protect your data.",
// ),
// FaqItem(
//   icon: Icons.lock_reset,
//   question: "How do I reset my password?",
//   answer:
//       "Go to Login screen → Tap Forgot Password → Enter your registered email.",
// ),
// FaqItem(
//   icon: Icons.star,
//   question: "Is the app free to use?",
//   answer:
//       "Yes, basic features are free. Premium plans are optional for extra features.",
// ),

class FaqItem extends StatelessWidget {
  final String question;
  final String answer;
  final IconData icon;

  const FaqItem({
    super.key,
    required this.question,
    required this.answer,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: .circular(16)),
        elevation: 0,
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.all(16),
          leading: CircleAvatar(
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.1),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary),
          ),
          title: Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          children: [
            Text(
              answer,
              style: TextStyle(color: Colors.grey[700], height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

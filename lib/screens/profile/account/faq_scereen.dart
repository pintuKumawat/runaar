import 'package:flutter/material.dart';
class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("FAQs"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          FaqItem(
            icon: Icons.business,
            question: "What is Kvon Tech?",
            answer:
                "Kvon Tech is a technology company focused on building modern apps and digital solutions.",
          ),
          FaqItem(
            icon: Icons.support_agent,
            question: "How can I contact support?",
            answer:
                "You can contact support through email, WhatsApp, or in-app chat support.",
          ),
          FaqItem(
            icon: Icons.security,
            question: "Is my data secure?",
            answer:
                "Yes, we use secure servers, encryption, and industry best practices to protect your data.",
          ),
          FaqItem(
            icon: Icons.lock_reset,
            question: "How do I reset my password?",
            answer:
                "Go to Login screen → Tap Forgot Password → Enter your registered email.",
          ),
          FaqItem(
            icon: Icons.star,
            question: "Is the app free to use?",
            answer:
                "Yes, basic features are free. Premium plans are optional for extra features.",
          ),
        ],
      ),
    );
  }
}


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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.all(16),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary),
          ),
          title: Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          children: [
            Text(
              answer,
              style: TextStyle(
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



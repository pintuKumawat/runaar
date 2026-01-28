import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/provider/privacyPolicy/privacy_policy_provider.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<PrivacyPolicyProvider>().PrivacyPolicy(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final List<Map<String, String>> privacyPolicy = [
    //   {
    //     "title": "App Information",
    //     "description":
    //         "Company: KvonTech Consultancy Services Pvt Ltd\n"
    //         "App Name: Runaar\n"
    //         "Contact Email: runaar.services@gmail.com"
    //   },
    //   {
    //     "title": "Introduction",
    //     "description":
    //         "Runaar (“we”, “our”, “us”), developed by KvonTech Consultancy Services Pvt Ltd, provides a ride-sharing and trip-matching platform where users can offer rides as drivers, book rides as passengers, share their travel route and trip details, track rides in real-time, verify identity and vehicle documents for safety and trust, and use location for navigation and ride matching.\n\n"
    //         "This Privacy Policy explains how we collect, use, store, and protect your information when you use Runaar. By using Runaar, you agree to the data practices described here."
    //   },
    //   {
    //     "title": "Account Information (Login Required)",
    //     "description":
    //         "When you register or log in, we collect your name, phone number, email address, encrypted password, and optional profile photo. This information is used for account creation, authentication, and communication."
    //   },
    //   {
    //     "title": "Location Information",
    //     "description":
    //         "We collect foreground GPS location and background location if permitted. This data is used to show nearby rides, track driver routes, improve trip accuracy, and support safety and fraud prevention. We do not sell or share your location with third parties."
    //   },
    //   {
    //     "title": "Camera and Gallery Access",
    //     "description":
    //         "Camera and gallery access is used for uploading profile pictures, vehicle photos, and driver verification documents. We do not access your camera or gallery without your permission."
    //   },
    //   {
    //     "title": "Notifications",
    //     "description":
    //         "We collect your device Firebase Cloud Messaging token to send ride updates, trip reminders, verification status updates, and important service alerts. You may disable notifications at any time."
    //   },
    //   {
    //     "title": "Driver Verification",
    //     "description":
    //         "Only users applying as drivers must upload verification documents such as Aadhaar details, vehicle registration certificate images, driver profile information, and vehicle photos. These documents are used strictly for identity verification, vehicle ownership verification, safety, trust, and legal compliance.\n\n"
    //         "Documents are verified internally, not shared publicly, and are shared with law enforcement only if legally required. Data is stored securely with encrypted storage and restricted access and is deleted when no longer required or when the account is removed."
    //   },
    //   {
    //     "title": "How We Use the Information",
    //     "description":
    //         "We use the collected information to create and manage user accounts, match drivers and riders, display accurate location-based rides, verify driver identity, send notifications, improve application functionality, and maintain platform safety. We never sell personal data."
    //   },
    //   {
    //     "title": "Third-Party Services Used",
    //     "description":
    //         "Runaar uses trusted third-party services including Firebase Cloud Messaging for notifications, MySQL database for data storage, and Google Maps API for location services. These services operate under their own privacy policies."
    //   },
    //   {
    //     "title": "Data Sharing",
    //     "description":
    //         "We do not share your data with advertisers, marketers, other users, or third-party companies. Data is shared only with law enforcement when legally required or with service providers such as Google Firebase for operational purposes."
    //   },
    //   {
    //     "title": "Data Security",
    //     "description":
    //         "We implement strong security measures including encrypted databases, secure servers, limited staff access, and regular audits. However, no system can guarantee complete security."
    //   },
    //   {
    //     "title": "Data Retention",
    //     "description":
    //         "User data is retained as long as the account remains active. After account deletion, profile information is removed, verification documents are deleted, and backup logs may be retained for up to ninety days as part of standard operational practices."
    //   },
    //   {
    //     "title": "Your Rights",
    //     "description":
    //         "Users have the right to access, update, or delete their data, request removal of verification documents, and disable location services or notifications at any time. Requests can be made by contacting Runaar support."
    //   },
    //   {
    //     "title": "Children’s Privacy",
    //     "description":
    //         "Runaar is not intended for children under the age of eighteen. We do not knowingly collect personal data from minors."
    //   },
    //   {
    //     "title": "Changes to This Policy",
    //     "description":
    //         "This Privacy Policy may be updated periodically. Any changes will be posted within the application and on the official website."
    //   },
    //   {
    //     "title": "Contact Us",
    //     "description":
    //         "Company: KvonTech Consultancy Services Pvt Ltd\n"
    //         "Email: runaar.services@gmail.com\n"
    //         "Phone: Optional"
    //   },
    // ];

    return Scaffold(
      appBar: AppBar(title: const Text("Privacy Policy")),
      body: Consumer<PrivacyPolicyProvider>(
        builder: (BuildContext context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(
              child: Text(
                provider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (provider.response == null ||
              provider.response!.privacyPolicy!.isEmpty) {
            return const Center(child: Text("No privacy policy found"));
          }
          return ListView.builder(
            padding: 10.all,
            itemCount: provider.response?.privacyPolicy?.length,
            itemBuilder: (context, index) {
              final item = provider.response?.privacyPolicy?[index];
             return Card(
  elevation: 2,
  margin: const EdgeInsets.only(bottom: 12),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item?.title ?? "title",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item?.description ?? "description",
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            color: Colors.black87,
          ),
        ),
      ],
    ),
  ),
);

            },
          );
        },
      ),
    );
  }
}




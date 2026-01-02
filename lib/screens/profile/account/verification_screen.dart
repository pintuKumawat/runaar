import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';

enum VerificationStatus { verified, pending, inProgress }

class VerificationScreen extends StatefulWidget {
 
  final int? isLicenceVerified;
  final int? isDocumentVerified;
  final int? isNumberVerified;
  final int? isEmailVerified;

  const VerificationScreen({
    super.key,
   
    required this.isLicenceVerified,
    required this.isDocumentVerified,
    required this. isNumberVerified,
    required this.isEmailVerified,
  });

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final ImagePicker _picker = ImagePicker();

  VerificationStatus drivingLicenseStatus = VerificationStatus.pending;
  VerificationStatus identityStatus = VerificationStatus.inProgress;
  VerificationStatus emailStatus = VerificationStatus.verified;
  VerificationStatus phoneStatus = VerificationStatus.pending;

  String selectedIdentity = "Aadhaar";

  File? drivingLicenseFile;
  File? identityFile;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final phoneVerified = phoneStatus == VerificationStatus.pending;
    final emailVerified = emailStatus == VerificationStatus.pending;
    return Scaffold(
      appBar: AppBar(title: const Text("Verification")),
      body: ListView(
        padding: 10.all,
        children: [
          _verificationCard(
            title: "Driving License",
            subtitle: "Upload and verify your driving license",
            status: drivingLicenseStatus,
            onUpload: () => _pickFile(
              onPicked: (file) {
                setState(() {
                  drivingLicenseFile = file;
                  drivingLicenseStatus = VerificationStatus.inProgress;
                });
              },
            ),
          ),
          6.height,
          const Divider(),
          6.height,

          _identityVerificationCard(),

          6.height,
          const Divider(),
          6.height,

          ListTile(
            onTap: () {},
            leading: _statusIconCircle(emailStatus),
            title: Text(
              "Email Verification",
              style: textTheme.titleSmall?.copyWith(fontWeight: .w600),
            ),
            subtitle: Text(
              "Verify your email address",
              style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
            ),
            trailing: (emailVerified)
                ? Icon(Icons.keyboard_arrow_right)
                : _statusBadge(emailStatus),
          ),

          6.height,
          const Divider(),
          6.height,

          ListTile(
            onTap: () {},
            leading: _statusIconCircle(phoneStatus),
            title: Text(
              "Phone Verification",
              style: textTheme.titleSmall?.copyWith(fontWeight: .w600),
            ),
            subtitle: Text(
              "Verify your mobile number",
              style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
            ),
            trailing: (phoneVerified)
                ? Icon(Icons.keyboard_arrow_right)
                : _statusBadge(phoneStatus),
          ),
        ],
      ),
    );
  }

  // -------------------- VERIFICATION CARD (OLD UI) --------------------
  Widget _verificationCard({
    required String title,
    required String subtitle,
    required VerificationStatus status,
    VoidCallback? onUpload,
  }) {
    final canUpload = status == VerificationStatus.pending;
    TextTheme textTheme = Theme.of(context).textTheme;
    return ListTile(
      leading: _statusIconCircle(status),
      title: Text(
        title,
        style: textTheme.titleSmall?.copyWith(fontWeight: .w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
      ),
      trailing: (canUpload && onUpload != null)
          ? _uploadButton(onUpload)
          : _statusBadge(status),
    );
  }

  Widget _identityVerificationCard() {
    final canUpload = identityStatus == VerificationStatus.pending;
    TextTheme textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: _statusIconCircle(identityStatus),
      title: Text(
        "Identity Verification",
        style: textTheme.titleSmall?.copyWith(fontWeight: .w600),
      ),
      subtitle: Text(
        "Using $selectedIdentity",
        style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600),
      ),
      trailing: canUpload
          ? _uploadButton(
              () => _pickFile(
                onPicked: (file) {
                  setState(() {
                    identityFile = file;
                    identityStatus = VerificationStatus.inProgress;
                  });
                },
              ),
            )
          : _statusBadge(identityStatus),
    );
  }

  Widget _uploadButton(VoidCallback onTap) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(shape: CircleBorder()),
      onPressed: onTap,
      child: Icon(Icons.add, size: 20.sp, color: appColor.secondColor),
    );
  }

  Future<void> _pickFile({required Function(File file) onPicked}) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      onPicked(File(picked.path));
    }
  }

  // -------------------- STATUS UI --------------------
  Widget _statusBadge(VerificationStatus status) {
    return Container(
      padding: 10.hv(4),
      decoration: BoxDecoration(
        color: _statusColor(status).withOpacity(.15),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        _statusText(status),
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: _statusColor(status),
        ),
      ),
    );
  }

  Widget _statusIconCircle(VerificationStatus status) {
    return CircleAvatar(
      radius: 22.r,
      backgroundColor: _statusColor(status).withOpacity(.15),
      child: Icon(
        _statusIcon(status),
        size: 20.sp,
        color: _statusColor(status),
      ),
    );
  }

  // -------------------- HELPERS --------------------
  String _statusText(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.verified:
        return "Verified";
      case VerificationStatus.inProgress:
        return "In Progress";
      case VerificationStatus.pending:
        return "Pending";
    }
  }

  IconData _statusIcon(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.verified:
        return Icons.verified;
      case VerificationStatus.inProgress:
        return Icons.autorenew;
      case VerificationStatus.pending:
        return Icons.pending_outlined;
    }
  }

  Color _statusColor(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.verified:
        return Colors.green;
      case VerificationStatus.inProgress:
        return Colors.blue;
      case VerificationStatus.pending:
        return Colors.orange;
    }
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/controllers/profile/edit_profile_controller.dart';
import 'package:runaar/core/utils/helpers/Navigate/app_navigator.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';
import 'package:runaar/core/utils/helpers/Text_Formatter/text_formatter.dart';
import 'package:runaar/core/utils/helpers/default_image/default_image.dart';
import 'package:runaar/provider/profile/user_profile_update_provider.dart';

class EditProfileScreen extends StatefulWidget {
  final int userId;
  const EditProfileScreen({super.key, required this.userId});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String gender = "Male";
  File? profileImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    editProfileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      bottomNavigationBar: _saveButton(textTheme),
      body: SingleChildScrollView(
        padding: 10.all,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: .start,
            children: [
              20.height,
              _profileImageSection(),
              20.height,
              _labelText(label: "Name", textTheme: textTheme),
              _nameField(textTheme),
              10.height,
              _labelText(label: "Email", textTheme: textTheme),
              _emailField(textTheme),
              10.height,
              _genderSection(textTheme),
              8.height,
              _labelText(label: "Date of birth", textTheme: textTheme),
              _dobField(textTheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileImageSection() {
    return Center(
      child: Stack(
        children: [
          defaultImage.userProvider("", 55.r),
          Positioned(
            bottom: 4.h,
            right: 4.w,
            child: InkWell(
              onTap: _showImageSourceSheet,
              child: CircleAvatar(
                radius: 12.r,
                backgroundColor: appColor.secondColor,
                child: Icon(Icons.camera_alt, size: 14.sp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 80);

    if (picked != null) {
      setState(() => profileImage = File(picked.path));
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) {
        final textTheme = Theme.of(context).textTheme;

        return Padding(
          padding: 16.all,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                margin: 5.vertical,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),

              Text("Select Image Source", style: textTheme.titleMedium),
              20.height,

              _imageSourceTile(
                icon: Icons.camera_alt_outlined,
                title: "Camera",
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),

              12.height,

              _imageSourceTile(
                icon: Icons.photo_library_outlined,
                title: "Gallery",
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),

              12.height,
            ],
          ),
        );
      },
    );
  }

  Widget _imageSourceTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Container(
        padding: 14.all,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade500),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22.sp),
            12.width,
            Text(title, style: textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _labelText({required String label, required TextTheme textTheme}) {
    return Padding(
      padding: 10.horizontal,
      child: Text(
        label,
        style: textTheme.titleSmall?.copyWith(fontWeight: .w600),
        textAlign: .left,
      ),
    );
  }

  Widget _nameField(TextTheme textTheme) {
    return Consumer<UserProfileUpdateProvider>(
      builder: (BuildContext context, updateProvider, child) {
        return TextFormField(
          controller: editProfileController.nameController,
          onChanged: updateProvider.validateUserName,

          style: textTheme.bodyMedium,
          inputFormatters: [FirstLetterCapitalFormatter()],
          decoration: InputDecoration(
            errorText: updateProvider.userNameError,
            // labelText: "Full Name",
            prefixIcon: Icon(Icons.person_outline),
          ),
          validator: (v) => v == null || v.isEmpty ? "Name is required" : null,
        );
      },
    );
  }

  Widget _emailField(TextTheme textTheme) {
    return Consumer<UserProfileUpdateProvider>(
      builder: (BuildContext context, updateProvider, child) {
        return TextFormField(
          controller: editProfileController.emailController,

          onChanged: updateProvider.validateEmail,

          keyboardType: TextInputType.emailAddress,
          style: textTheme.bodyMedium,
          decoration: InputDecoration(
            errorText: updateProvider.emailError,
            // labelText: "Email",
            prefixIcon: Icon(Icons.email_outlined),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return "Email is required";
            if (!v.contains("@")) return "Enter valid email";
            return null;
          },
        );
      },
    );
  }

  Widget _genderSection(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: 12.horizontal,
          child: Text("Gender", style: textTheme.titleMedium),
        ),
        8.height,
        Wrap(
          spacing: 25.w,
          children: ["Male", "Female", "Other"].map((value) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: value,
                  groupValue: gender,
                  onChanged: (val) => setState(() => gender = val!),
                ),
                Text(value, style: textTheme.bodySmall),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _dobField(TextTheme textTheme) {
    return TextFormField(
      controller: editProfileController.dobController,
      readOnly: true,
      onTap: _selectDob,
      style: textTheme.bodyMedium,
      decoration: const InputDecoration(
        // labelText: "Date of Birth",
        prefixIcon: Icon(Icons.calendar_today_outlined),
      ),
      validator: (v) => v == null || v.isEmpty ? "Select date of birth" : null,
    );
  }

  Future<void> _selectDob() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.black),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      editProfileController.dobController.text = DateFormat(
        'dd MMM yyyy',
      ).format(picked);
    }
  }

  Widget _saveButton(TextTheme textTheme) {
    return Consumer<UserProfileUpdateProvider>(
      builder: (BuildContext context, updateProvider, child) {
        return BottomAppBar(
          child: SizedBox(
            width: double.infinity,
            height: 56.h,
            child: ElevatedButton(
              onPressed: () async {
                await updateProvider.userProfileUpdate(
                  userId: widget.userId,
                  dob: editProfileController.dobController.text,
                  gender: gender,
                  profileImage: profileImage,
                  name: editProfileController.nameController.text,
                  email: editProfileController.emailController.text,
                );

                if (updateProvider.messageError != null) {
                  return appSnackbar.showSingleSnackbar(
                    context,
                    updateProvider.messageError ?? "",
                  );
                }
                appSnackbar.showSingleSnackbar(
                  context,
                  updateProvider.response?.message ?? "",
                );
                if (!mounted) return;

                appNavigator.pop();
                editProfileController.clear();
              },
              child: updateProvider.isLoading
                  ? const CircularProgressIndicator()
                  : Text("Save Changes"),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:runaar/core/constants/app_color.dart';
import 'package:runaar/core/responsive/responsive_extension.dart';
import 'package:runaar/core/utils/helpers/Snackbar/app_snackbar.dart';

class LanguageChangeScreen extends StatefulWidget {
  const LanguageChangeScreen({super.key});

  @override
  State<LanguageChangeScreen> createState() => _LanguageChangeScreenState();
}

class _LanguageChangeScreenState extends State<LanguageChangeScreen> {
  /// default language (current app language)
  final String currentLanguage = 'en';

  /// selected language from UI
  String selectedLanguage = 'en';
  

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Change Language")),

      bottomNavigationBar: _changeLanguageButton(),

      body: Padding(
        padding: 12.all,
        child: Column(
          children: [
            _languageTile(
              title: "English",
              subtitle: "English",
              value: 'en',
              textTheme: textTheme,
            ),

            12.height,

            _languageTile(
              title: "हिंदी",
              subtitle: "Hindi",
              value: 'hi',
              textTheme: textTheme,
            ),
          ],
        ),
      ),
    );
  }

  // -------------------- LANGUAGE TILE --------------------
  Widget _languageTile({
    required String title,
    required String subtitle,
    required String value,
    required TextTheme textTheme,
  }) {
    final isSelected = selectedLanguage == value;

    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: () => setState(() => selectedLanguage = value),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade500,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 24.r,
            backgroundColor: appColor.mainColor.withOpacity(.2),
            child: Text(
              subtitle.substring(0, 2).toUpperCase(),
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(title, style: textTheme.titleSmall),
          subtitle: Text(subtitle, style: textTheme.bodySmall),
          trailing: Icon(
            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isSelected ? Colors.blue : Colors.grey,
            size: 22.sp,
          ),
        ),
      ),
    );
  }

  Widget _changeLanguageButton() {
    final isEnabled = selectedLanguage != currentLanguage;

    return BottomAppBar(
      child: SizedBox(
        width: double.infinity,
        height: 56.h,
        child: ElevatedButton(
          onPressed: isEnabled ? _applyLanguageChange : null,
          child: const Text("Change Language"),
        ),
      ),
    );
  }

  // -------------------- APPLY LANGUAGE --------------------
  void _applyLanguageChange() {
    // context.read<LocaleProvider>().changeLocale(Locale(selectedLanguage));

    appSnackbar.showSingleSnackbar(
      context,
      selectedLanguage == 'hi'
          ? "भाषा बदल दी गई है"
          : "Language changed successfully",
    );

    setState(() {});
  }
}

import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

void showDelighfulToast(BuildContext context, String message, Color? cardColor, IconData icon, Color iconColor, Color textColor) {
  DelightToastBar(
          builder: (context) => ToastCard(
                color: cardColor,
                leading: Icon(
                 icon,
                  size: 16,
                  color: iconColor,
                ),
                title: Text(
                  textAlign: TextAlign.justify,
                  message,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
              ),
          position: DelightSnackbarPosition.top,
          autoDismiss: true,
          snackbarDuration: const Duration(seconds: 2))
      .show(context);
}

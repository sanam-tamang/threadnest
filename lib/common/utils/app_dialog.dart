import 'package:quickalert/quickalert.dart';

class AppDialog {
  static Future<void> error(context, String message) async {
    await QuickAlert.show(
        context: context,
        title: "Error",
        text: message,
        type: QuickAlertType.error,
        cancelBtnText: "X",
        disableBackBtn: true,
        barrierDismissible: false,
        showCancelBtn: true,
        showConfirmBtn: false);
  }

  static Future<void> success(context, String message,
      {int? autoCloseAfterMiliSeconds}) async {
    await QuickAlert.show(
      context: context,
      title: "Success",
      text: message,
      type: QuickAlertType.success,
      showConfirmBtn: false,
      autoCloseDuration: autoCloseAfterMiliSeconds != null
          ? Duration(milliseconds: autoCloseAfterMiliSeconds)
          : null,
    );
  }
}

import 'package:permission_handler/permission_handler.dart';

Future<bool> requestCameraPermission() async {
  await Permission.camera.request();
  var status = await Permission.camera.status;
  if (status.isGranted) {
    return true; // Permission is already granted
  } else {
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      status = await Permission.camera.request();
      if (status.isGranted) {
        return true;
      }
    } else if (await Permission.camera.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enables it in the system settings.
      openAppSettings();
    }
    // Permission is denied (this is the final state after the user definitively denied the permission request)
    return false;
  }
}

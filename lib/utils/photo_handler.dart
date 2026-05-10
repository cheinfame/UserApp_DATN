import 'package:permission_handler/permission_handler.dart';

Future<bool> requestPhotosPermission() async {
  await Permission.photos.request();
  var status = await Permission.photos.status;
  if (status.isGranted) {
    return true; // Permission is already granted
  } else {
    // Check if the permission was denied
    if (status.isDenied) {
      // Request the permission
      status = await Permission.photos.request();
      if (status.isGranted) {
        return true; // Permission granted
      }
    }
    // If permanently denied, we cannot request permission again
    else if (status.isPermanentlyDenied) {
      openAppSettings(); // Opens app settings where the user can manually allow permission
    } else if (await Permission.photos.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enables it in the system settings.
      openAppSettings();
    }
    return false; // Permission is denied
  }
}

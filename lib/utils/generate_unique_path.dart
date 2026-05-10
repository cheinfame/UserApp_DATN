import 'package:uuid/uuid.dart';

String generateUniquePath() {
  // Generate a unique identifier (UUID)
  String uniqueId = const Uuid().v4();

  // Get the current timestamp in milliseconds
  int timestamp = DateTime.now().millisecondsSinceEpoch;

  // Combine the unique ID and timestamp to create a unique path
  String path = 'package/$timestamp-$uniqueId';

  return path;
}

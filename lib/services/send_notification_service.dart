import 'package:lifesync_capstone_project/services/get_services_key.dart';

class SendNotificationService {
  static Future<void> sendNotificationUsingApi() async {
    String serverKey = await GetServerKey().getServerKeyToken();
    String url =
        'https://fcm.googleapis.com/v1/projects/lifesync-capstone/messages:send';

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    };
  }
}

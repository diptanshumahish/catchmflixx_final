import 'package:restart_app/restart_app.dart';

void closeApp() {
  Restart.restartApp(
    notificationTitle: 'Restarting App due to logout',
    notificationBody: 'Please tap here to open the app again, and login',
  );
}

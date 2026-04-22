import 'core/config/app_config.dart';
import 'bootstrap.dart';

void main() async {
  AppConfig.init(AppConfig.dev());
  await bootstrap();
}

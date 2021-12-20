import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart' as ft;

void main() {
  ft.group('Splash Screen Test', () {
    FlutterDriver driver;
    ft.setUpAll(() async {
      driver = await FlutterDriver.connect();
    });
    ft.tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });
    ft.test('verify the text on fuel stations screen', () async {
      SerializableFinder message = find.text("My sample text should be present");
      await driver.waitFor(message);
      ft.expect(await driver.getText(message), "My sample text should be present");
    });
  });
}
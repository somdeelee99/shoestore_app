// Compile-time guard: importing main.dart pulls in every module, controller,
// binding, repository and widget of the app, so this test fails fast if any
// part of the app graph stops compiling.
import 'package:flutter_test/flutter_test.dart';
import 'package:shoestore_app/app/core/routes/app_pages.dart';
import 'package:shoestore_app/main.dart' as app;

void main() {
  test('app graph compiles and every design-board screen has a route', () {
    expect(app.ShoeStoreApp, isNotNull);
    expect(AppPages.routes.length, greaterThanOrEqualTo(27));
  });
}

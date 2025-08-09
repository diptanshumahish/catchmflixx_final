import 'package:catchmflixx/utils/datetime/format_date.dart';
import 'package:catchmflixx/utils/datetime/format_watched_date.dart';
import 'package:catchmflixx/utils/responsive/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrapWithMediaQuery({
  required Size size,
  required Widget child,
}) {
  return MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(
        size: size,
        devicePixelRatio: 1.0,
        textScaler: const TextScaler.linear(1.0),
        platformBrightness: Brightness.dark,
      ),
      child: child,
    ),
  );
}

class _ProbeWidget extends StatelessWidget {
  final void Function(BuildContext) onBuild;
  const _ProbeWidget({required this.onBuild});
  @override
  Widget build(BuildContext context) {
    onBuild(context);
    return const SizedBox.shrink();
  }
}

void main() {
  group('formatDate', () {
    test('formats with correct day suffix and time', () {
      expect(
        formatDate('01-01-2024 14:05:00'),
        '1st January, 2024 at 2:05 PM',
      );
      expect(
        formatDate('02-02-2024 00:00:00'),
        '2nd February, 2024 at 12:00 AM',
      );
      expect(
        formatDate('03-03-2024 23:15:00'),
        '3rd March, 2024 at 11:15 PM',
      );
      expect(
        formatDate('11-04-2024 09:00:00'),
        '11th April, 2024 at 9:00 AM',
      );
    });
  });

  group('formatWatchedDate', () {
    test('returns hh:mm a when within 24 hours', () {
      final recent = DateTime.now().subtract(const Duration(hours: 1));
      final formatted = formatWatchedDate(recent);
      final timeRegex = RegExp(r'^(0[1-9]|1[0-2]):[0-5][0-9] [AP]M$');
      expect(timeRegex.hasMatch(formatted), isTrue,
          reason: 'Expected time like 01:23 PM, got "$formatted"');
    });

    test('returns day with suffix and short month when >= 1 day old', () {
      final date = DateTime(2024, 1, 1, 14, 0);
      final formatted = formatWatchedDate(date);
      expect(formatted, '1st Jan, 2024');
    });

    test('getDaySuffix handles edge cases', () {
      expect(getDaySuffix(1), 'st');
      expect(getDaySuffix(2), 'nd');
      expect(getDaySuffix(3), 'rd');
      expect(getDaySuffix(4), 'th');
      expect(getDaySuffix(11), 'th');
      expect(getDaySuffix(12), 'th');
      expect(getDaySuffix(13), 'th');
      expect(getDaySuffix(21), 'st');
      expect(getDaySuffix(22), 'nd');
      expect(getDaySuffix(23), 'rd');
      expect(getDaySuffix(31), 'st');
    });
  });

  group('ResponsiveUtils', () {
    testWidgets('screen size classification', (tester) async {
      Size small = const Size(320, 640);
      Size medium = const Size(400, 800);
      Size large = const Size(700, 1000);

      // Small
      bool? isSmall;
      await tester.pumpWidget(
        _wrapWithMediaQuery(
          size: small,
          child: _ProbeWidget(onBuild: (ctx) {
            isSmall = ResponsiveUtils.isSmallScreen(ctx);
          }),
        ),
      );
      expect(isSmall, isTrue);

      // Medium
      bool? isMedium;
      await tester.pumpWidget(
        _wrapWithMediaQuery(
          size: medium,
          child: _ProbeWidget(onBuild: (ctx) {
            isMedium = ResponsiveUtils.isMediumScreen(ctx);
          }),
        ),
      );
      expect(isMedium, isTrue);

      // Large
      bool? isLarge;
      await tester.pumpWidget(
        _wrapWithMediaQuery(
          size: large,
          child: _ProbeWidget(onBuild: (ctx) {
            isLarge = ResponsiveUtils.isLargeScreen(ctx);
          }),
        ),
      );
      expect(isLarge, isTrue);
    });

    testWidgets('getResponsiveFontSize scales with width', (tester) async {
      double? smallSize;
      await tester.pumpWidget(
        _wrapWithMediaQuery(
          size: const Size(320, 640),
          child: _ProbeWidget(onBuild: (ctx) {
            smallSize = ResponsiveUtils.getResponsiveFontSize(
              ctx,
              baseSize: 20,
            );
          }),
        ),
      );
      expect(smallSize, closeTo(17.0, 0.001)); // 20 * 0.85

      double? baseSize;
      await tester.pumpWidget(
        _wrapWithMediaQuery(
          size: const Size(400, 800),
          child: _ProbeWidget(onBuild: (ctx) {
            baseSize = ResponsiveUtils.getResponsiveFontSize(
              ctx,
              baseSize: 20,
            );
          }),
        ),
      );
      expect(baseSize, 20);

      double? largeSize;
      await tester.pumpWidget(
        _wrapWithMediaQuery(
          size: const Size(700, 1000),
          child: _ProbeWidget(onBuild: (ctx) {
            largeSize = ResponsiveUtils.getResponsiveFontSize(
              ctx,
              baseSize: 20,
            );
          }),
        ),
      );
      expect(largeSize, closeTo(22.0, 0.001)); // 20 * 1.1
    });
  });
}

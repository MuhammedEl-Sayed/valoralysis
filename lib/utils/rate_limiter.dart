import 'dart:async';
import 'package:async/async.dart';
import 'package:pool/pool.dart';

class RateLimiter {
  final int maxRequestsPerSecond;
  final int maxRequestsPerTwoMinutes;
  final Pool pool;
  int requestsThisSecond = 0;
  int requestsLastTwoMinutes = 0;
  DateTime? lastRequestTime;

  RateLimiter(this.maxRequestsPerSecond, this.maxRequestsPerTwoMinutes)
      : pool = Pool(maxRequestsPerSecond);

  Future<T> run<T>(Future<T> Function() operation) async {
    await _waitForRateLimit();
    return pool.withResource(operation);
  }

  Future<void> _waitForRateLimit() async {
    final now = DateTime.now();
    if (lastRequestTime != null) {
      final secondsSinceLastRequest =
          now.difference(lastRequestTime!).inSeconds;
      final twoMinutesSinceLastRequest =
          now.difference(lastRequestTime!).inMinutes;

      if (secondsSinceLastRequest < 1 &&
          requestsThisSecond >= maxRequestsPerSecond) {
        print('Rate limit for requests per second reached. Waiting...');
        await Future.delayed(Duration(seconds: 1 - secondsSinceLastRequest));
        requestsThisSecond = 0; // Reset the counter after waiting
        print('Wait over. Resuming requests...');
      } else if (secondsSinceLastRequest >= 1) {
        requestsThisSecond = 0; // Reset the counter if a second has passed
      }

      if (twoMinutesSinceLastRequest < 2 &&
          requestsLastTwoMinutes >= maxRequestsPerTwoMinutes) {
        print('Rate limit for requests per two minutes reached. Waiting...');
        await Future.delayed(Duration(minutes: 2 - twoMinutesSinceLastRequest));
        requestsLastTwoMinutes = 0; // Reset the counter after waiting
        print('Wait over. Resuming requests...');
      } else if (twoMinutesSinceLastRequest >= 2) {
        requestsLastTwoMinutes =
            0; // Reset the counter if two minutes have passed
      }
    }

    lastRequestTime = now;
    requestsThisSecond++;
    requestsLastTwoMinutes++;

    print('Requests this second: $requestsThisSecond');
    print('Requests last two minutes: $requestsLastTwoMinutes');
  }
}

import 'dart:async';

import 'package:pool/pool.dart';

class RateLimitService {
  int requestsThisSecond = 0;
  int requestsLastTwoMinutes = 0;
  DateTime? lastRequestTime;

  static final RateLimitService _singleton = RateLimitService._internal();

  factory RateLimitService() {
    return _singleton;
  }

  RateLimitService._internal();
}

class RateLimiter {
  final int maxRequestsPerSecond;
  final int maxRequestsPerTwoMinutes;
  final Pool pool;
  final RateLimitService rateLimitService = RateLimitService();

  RateLimiter(this.maxRequestsPerSecond, this.maxRequestsPerTwoMinutes)
      : pool = Pool(maxRequestsPerSecond);

  Future<T> run<T>(Future<T> Function() operation) async {
    await _waitForRateLimit();
    return pool.withResource(operation);
  }

  Future<void> _waitForRateLimit() async {
    final now = DateTime.now();
    if (rateLimitService.lastRequestTime != null) {
      final secondsSinceLastRequest =
          now.difference(rateLimitService.lastRequestTime!).inSeconds;
      final twoMinutesSinceLastRequest =
          now.difference(rateLimitService.lastRequestTime!).inMinutes;

      if (secondsSinceLastRequest < 1 &&
          rateLimitService.requestsThisSecond >= maxRequestsPerSecond) {
        print('Rate limit for requests per second reached. Waiting...');
        await Future.delayed(Duration(seconds: 1 - secondsSinceLastRequest));
        rateLimitService.requestsThisSecond =
            0; // Reset the counter after waiting
        print('Wait over. Resuming requests...');
      } else if (secondsSinceLastRequest >= 1) {
        rateLimitService.requestsThisSecond =
            0; // Reset the counter if a second has passed
      }

      if (twoMinutesSinceLastRequest < 2 &&
          rateLimitService.requestsLastTwoMinutes >= maxRequestsPerTwoMinutes) {
        print('Rate limit for requests per two minutes reached. Waiting...');
        await Future.delayed(Duration(minutes: 2 - twoMinutesSinceLastRequest));
        rateLimitService.requestsLastTwoMinutes =
            0; // Reset the counter after waiting
        print('Wait over. Resuming requests...');
      } else if (twoMinutesSinceLastRequest >= 2) {
        rateLimitService.requestsLastTwoMinutes =
            0; // Reset the counter if two minutes have passed
      }
    }

    rateLimitService.lastRequestTime = now;
    rateLimitService.requestsThisSecond++;
    rateLimitService.requestsLastTwoMinutes++;

    print('Requests this second: ${rateLimitService.requestsThisSecond}');
    print(
        'Requests last two minutes: ${rateLimitService.requestsLastTwoMinutes}');
  }
}

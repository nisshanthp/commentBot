import 'dart:math';
import 'dart:isolate';

void sieve(int start, int end, SendPort sendPort) {
  int sieveSize = end - start + 1;
  List<bool> sieve = List.filled(sieveSize, true);

  int sqrtEnd = sqrt(end).ceil() + 1;
  for (int i = 2; i < sqrtEnd; i++) {
    if (sieve[i]) {
      for (int j = max(i * i, start + ((i - start % i) % i)); j <= end; j += i) {
        sieve[j - start] = false;
      }
    }
  }

  List<int> primes = [];
  for (int i = max(2, start); i <= end; i++) {
    if (sieve[i - start]) {
      primes.add(i);
    }
  }

  sendPort.send(primes);
}

Future<List<int>> generatePrimes(int startNum, int endNum, int numThreads) async {
  List<int> primes = [];
  List<Isolate> isolates = [];
  ReceivePort receivePort = ReceivePort();

  int interval = (endNum - startNum + 1) ~/ numThreads;
  for (int i = 0; i < numThreads; i++) {
    int start = startNum + (i * interval);
    int end = (i < numThreads - 1) ? start + interval - 1 : endNum;

    Isolate isolate = await Isolate.spawn(sieve, [start, end, receivePort.sendPort]);
    isolates.add(isolate);
  }

  await for (var message in receivePort) {
    primes.addAll(message);
    if (primes.length == endNum - startNum + 1) {
      break;
    }
  }

  receivePort.close();
  isolates.forEach((isolate) => isolate.kill());

  return primes;
}

void main() async {
  int startNum = 1;
  int endNum = 1000;
  int numThreads = 4;

  List<int> result = await generatePrimes(startNum, endNum, numThreads);
  print(result);
}


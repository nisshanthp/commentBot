// This is the code for a Dart program that imports the math library.
import 'dart:math';
// This code imports the 'dart:isolate' library, which provides APIs for working with isolates (independent, concurrent threads of execution).
import 'dart:isolate';

// This function uses the Sieve of Eratosthenes algorithm to find all prime numbers in a given range.
void sieve(int start, int end, SendPort sendPort) {
// This code creates a sieve of size sieveSize, which is the difference between the end and start values, plus one.
int sieveSize = end - start + 1;
// This code creates a list of booleans called "sieve" with sieveSize elements, all set to true.
List<bool> sieve = List.filled(sieveSize, true);

// This code finds the square root of a number and rounds it up to the nearest integer.
int sqrtEnd = sqrt(end).ceil() + 1;
// This for loop iterates from 2 to the square root of the end value, checking if each value is a prime number.
for (int i = 2; i < sqrtEnd; i++) {
// This code checks if a number is prime by checking if it is divisible by any numbers less than it.
if (sieve[i]) {
// This loop is for finding the next prime number.
for (int j = max(i * i, start + ((i - start % i) % i)); j <= end; j += i) {
// This line of code sets the value of sieve[j - start] to false.
sieve[j - start] = false;

// This code snippet defines a list of integers called "primes" and initializes it to an empty list.
}
}
}
List<int> primes = [];
// This for loop starts at the maximum of 2 or start, and iterates until it reaches the end value.
for (int i = max(2, start); i <= end; i++) {
// This code checks if a number is prime by checking if it is divisible by any of the primes less than it.
if (sieve[i - start]) {
// This code adds the value of i to the primes list.
primes.add(i);

// This code snippet creates a send port and sends a list of primes through it.
}
}
sendPort.send(primes);

// This function generates a list of prime numbers between the start and end numbers, using the specified number of threads.
}
Future<List<int>> generatePrimes(int startNum, int endNum, int numThreads) async {
// This is a list of prime numbers.
List<int> primes = [];
// This code creates an empty list of isolates.
List<Isolate> isolates = [];
// This code creates a ReceivePort, which is an object that allows you to receive data from another source.
ReceivePort receivePort = ReceivePort();

// This code calculates the interval between each thread.
int interval = (endNum - startNum + 1) ~/ numThreads;
// This loop creates numThreads number of threads.
for (int i = 0; i < numThreads; i++) {
// This code calculates the start number for each interval in a loop.
int start = startNum + (i * interval);
// This code is checking if the current thread is the last one. If it is, it will set the end value to the endNum. Otherwise, it will set the end value to the start value plus the interval minus 1.
int end = (i < numThreads - 1) ? start + interval - 1 : endNum;

// This code spawns an isolate and runs the sieve function on it. The sieve function is passed the start, end, and sendPort parameters.
Isolate isolate = await Isolate.spawn(sieve, [start, end, receivePort.sendPort]);
// This line of code adds an isolate to the list of isolates.
isolates.add(isolate);

// This code awaits for a message from the receive port, and then prints it out.
}
await for (var message in receivePort) {
// This code adds all of the prime numbers to the message.
primes.addAll(message);
// This if statement checks to see if the length of the primes array is equal to the difference between the endNum and startNum variables, plus 1.
if (primes.length == endNum - startNum + 1) {
// This code will break out of the current loop.
break;

// This code closes a receive port.
}
}
receivePort.close();
// This code kills all the isolates.
isolates.forEach((isolate) => isolate.kill());

// This function returns an array of prime numbers.
return primes;

// This is the main function of the program. It is responsible for initializing the program and running the main loop.
}
void main() async {
// This is the start number.
int startNum = 1;
// This code sets the variable endNum to the value 1000.
int endNum = 1000;
// This code sets the number of threads to 4.
int numThreads = 4;

// This code calls the generatePrimes function to generate a list of prime numbers within a given range, using the specified number of threads.
List<int> result = await generatePrimes(startNum, endNum, numThreads);
// This code prints the result of the code.
print(result);


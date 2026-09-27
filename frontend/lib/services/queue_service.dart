import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/queue.dart';

class QueueService {

final String baseUrl = 'https://smart-queue-management-jhv7.onrender.com';
    int averageServiceTime = 5;
int calculateWaitingTime(int position) {
  if (position <= 1) {
    return 0;
  }

  final waitingSeconds =
      (position - 1) * averageServiceTime;

  return (waitingSeconds / 60).ceil();
}

  // ============================================================
  // TAKE TOKEN
  // ============================================================

  Future<Map<String, dynamic>> takeToken(int customerId) async {

    final response = await http.post(
      Uri.parse('$baseUrl/queue/take-token/$customerId'),
    );

    if (response.statusCode == 201) {

      return jsonDecode(response.body);

    } else {

      throw Exception('Failed to take token');

    }
  }

  // ============================================================
  // GET QUEUE
  // ============================================================

 Future<List<QueueModel>> getQueue() async {
  averageServiceTime = await getAverageServiceTime();
  final response = await http.get(
    Uri.parse('$baseUrl/queue'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);

   return data.asMap().entries.map((entry) {
  final index = entry.key;
  final json = entry.value;

  final position = index + 1;

  return QueueModel.fromJson(
    json,
    position: position,
    waitingTime: calculateWaitingTime(position),
  );
}).toList();
  } else {
    throw Exception('Failed to load queue');
  }
}
  // ============================================================
  // CALL NEXT CUSTOMER
  // ============================================================

  Future<QueueModel> callNextCustomer() async {

    final response = await http.post(
      Uri.parse('$baseUrl/queue/next'),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      return QueueModel.fromJson(data);

    } else {

      throw Exception('No customers waiting in the queue');

    }
  }

  // ============================================================
  // COMPLETE CUSTOMER
  // ============================================================

  Future<QueueModel> completeCustomer(int queueId) async {

    final response = await http.put(
      Uri.parse('$baseUrl/queue/$queueId/complete'),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      return QueueModel.fromJson(data);

    } else {

      throw Exception('Failed to complete customer');

    }
  }

  // ============================================================
  // CANCEL TOKEN
  // ============================================================

  Future<void> cancelToken(int queueId) async {

    final response = await http.delete(
      Uri.parse('$baseUrl/queue/$queueId/cancel'),
    );

    if (response.statusCode != 204) {

      throw Exception('Failed to cancel token');

    }
  }

  Future<int> getAverageServiceTime() async {
  final response = await http.get(
    Uri.parse('$baseUrl/queue/average-service-time'),
  );

  if (response.statusCode == 200) {
    return int.parse(response.body);
  } else {
    throw Exception('Failed to get average service time');
  }
}
Future<double> predictServiceTime(int queueId) async {
  final response = await http.get(
    Uri.parse('$baseUrl/queue/$queueId/ai-service-time'),
  );

  if (response.statusCode == 200) {
    return double.parse(response.body);
  } else {
    throw Exception('Failed to get AI service prediction');
  }
}
Future<void> testAIPrediction() async {
  final prediction = await predictServiceTime(19);

  print('AI PREDICTION: $prediction seconds');
}
Future<List<Map<String, dynamic>>> getAIPredictions() async {

  final response = await http.get(
    Uri.parse('$baseUrl/queue/ai-predictions'),
  );

  if (response.statusCode == 200) {

    final List<dynamic> data = jsonDecode(response.body);

    return data
    .map((item) => {
          'queueId': item['queueId'],
          'predictedServiceTime':
              item['predictedServiceTime'],
          'predictedWaitingTime':
              item['predictedWaitingTime'],
        })
    .toList();

  } else {

    throw Exception('Failed to get AI predictions');

  }
}
Future<int> getQueuePosition(int queueId) async {

  final response = await http.get(
    Uri.parse('$baseUrl/queue/$queueId/position'),
  );

  if (response.statusCode == 200) {
    return int.parse(response.body);
  } else {
    throw Exception('Failed to get queue position');
  }
}
Future<double> getAIPredictedWaitingTime(int queueId) async {

  final response = await http.get(
    Uri.parse('$baseUrl/queue/$queueId/ai-waiting-time'),
  );

  if (response.statusCode == 200) {
    return double.parse(response.body);
  } else {
    throw Exception('Failed to get AI waiting time');
  }
}
}
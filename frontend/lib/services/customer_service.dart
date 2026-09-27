
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/customer.dart';

class CustomerService {

final String baseUrl = 'https://smart-queue-management-jhv7.onrender.com';

  Future<List<Customer>> getCustomers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/customers'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      return data
          .map((json) => Customer.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load customers');
    }
  }

  Future<Customer> createCustomer(String name, String phone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/customers'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'phone': phone,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);

      return Customer.fromJson(data);
    } else {
      throw Exception('Failed to create customer');
    }
  }

  Future<void> deleteCustomer(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/customers/$id'),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete customer');
    }
  }

  Future<Customer> updateCustomer(
      int id,
      String name,
      String phone,
      ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/customers/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'phone': phone,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return Customer.fromJson(data);
    } else {
      throw Exception('Failed to update customer');
    }
  }
}

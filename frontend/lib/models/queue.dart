class QueueModel {
  final int id;
  final String tokenNumber;
  final String status;
  final int customerId;
  final String customerName;
  final String customerPhone;
  final int position;
  final int waitingTime;

  QueueModel({
    required this.id,
    required this.tokenNumber,
    required this.status,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.position,
    required this.waitingTime
  });

factory QueueModel.fromJson(
  Map<String, dynamic> json, {
  int position = 0,
  int waitingTime = 0,
}) {
      final customer = json['customer'];

    return QueueModel(
      id: json['id'],
      tokenNumber: json['tokenNumber'],
      status: json['status'],
      customerId: customer['id'],
      customerName: customer['name'],
      customerPhone: customer['phone'],
      position: position,
      waitingTime: waitingTime,
    );
  }
}
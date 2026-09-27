import 'package:flutter/material.dart';
import '../services/customer_service.dart';
import '../services/queue_service.dart';
class JoinQueueScreen extends StatefulWidget {
  const JoinQueueScreen({super.key});

  @override
  State<JoinQueueScreen> createState() => _JoinQueueScreenState();
}

class _JoinQueueScreenState extends State<JoinQueueScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
final CustomerService customerService = CustomerService();
final QueueService queueService = QueueService();
  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0F6),
      body: Stack(
        children: [
          // Soft gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFFFE3EF),
                  Color(0xFFFFF5FA),
                  Color(0xFFFDE7F3),
                ],
              ),
            ),
          ),

          // Decorative floating blobs
          Positioned(
            top: -60,
            right: -40,
            child: _blob(const Color(0xFFFFC1D9), 180),
          ),
          Positioned(
            top: 120,
            left: -70,
            child: _blob(const Color(0xFFFFD9E8), 140),
          ),
          Positioned(
            bottom: -80,
            right: -50,
            child: _blob(const Color(0xFFFFB6D0), 200),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom back + title row
                  Row(
                    children: [
                      _iconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Smart Trial Room",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9C4A6E),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Hero header
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF8FB8), Color(0xFFFFC1D9)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF69A4).withOpacity(0.35),
                                blurRadius: 24,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Text("💕", style: TextStyle(fontSize: 32)),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Join the Queue",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF7A2E4F),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "We'll let you know when it's your turn ✨",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF9C4A6E).withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 45),

                  // Card holding the form
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.9),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF69A4).withOpacity(0.12),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _fieldLabel("Your Name"),
                        const SizedBox(height: 10),
                        _textField(
                          controller: nameController,
                          hint: "e.g. Ananya",
                          icon: Icons.favorite_rounded,
                        ),
                        const SizedBox(height: 22),
                        _fieldLabel("Phone Number"),
                        const SizedBox(height: 10),
                        _textField(
                          controller: phoneController,
                          hint: "10-digit number",
                          icon: Icons.phone_rounded,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton(
                   onPressed: () async {
print("JOIN BUTTON PRESSED");
  final name = nameController.text.trim();
  final phone = phoneController.text.trim();

  try {

    // 1. Create customer
    final customer =
        await customerService.createCustomer(name, phone);

    print("Customer created!");
    print("Customer ID: ${customer.id}");

    // 2. Take queue token
    final queue =
        await queueService.takeToken(customer.id!);

    print("Queue token created!");
    print(queue);
    final position =
    await queueService.getQueuePosition(queue['id']);

print("Queue position: $position");
final aiWaitingTime =
    await queueService.getAIPredictedWaitingTime(queue['id']);

print("AI estimated waiting time: $aiWaitingTime seconds");
    showDialog(
  context: context,
  builder: (context) {
    return AlertDialog(
      title: const Text("💕 You're in the Queue!"),
     content: Text(
  "Your Token: ${queue['tokenNumber']}\n\n"
  "Your Position: $position\n\n"
  "🤖 Estimated Wait: "
  "${(aiWaitingTime / 60).toStringAsFixed(1)} minutes",
  style: const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("OK"),
        ),
      ],
    );
  },
);

} catch (e) {
  print("Error: $e");

  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Error: $e"),
    ),
  );
}
},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF69A4),
                                    Color(0xFFFF8FB8),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF69A4)
                                        .withOpacity(0.45),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                child: const Text(
                                  "Join Queue  💕",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Footer hint
                  Center(
                    child: Text(
                      "You'll receive a notification when it's your turn",
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF9C4A6E).withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Helper widgets ----------

  Widget _blob(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.55),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _iconButton({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.white.withOpacity(0.7),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, size: 18, color: const Color(0xFF9C4A6E)),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF7A2E4F),
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 15,
        color: Color(0xFF5A2340),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: const Color(0xFF9C4A6E).withOpacity(0.4),
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(icon, color: const Color(0xFFFF8FB8), size: 20),
        filled: true,
        fillColor: const Color(0xFFFFF5FA),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFFFD9E8), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFFF69A4), width: 1.6),
        ),
      ),
    );
  }
}
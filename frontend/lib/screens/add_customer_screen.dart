import 'package:flutter/material.dart';
import '../services/customer_service.dart';
import '../models/customer.dart';

class AddCustomerScreen extends StatefulWidget {
  final Customer? customer;

  const AddCustomerScreen({
    super.key,
    this.customer,
  });

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  final CustomerService customerService = CustomerService();

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    if (widget.customer != null) {
      nameController.text = widget.customer!.name;
      phoneController.text = widget.customer!.phone;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> saveCustomer() async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all the details 💕"),
          backgroundColor: Color(0xffe98aaa),
        ),
      );

      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      if (widget.customer == null) {
        await customerService.createCustomer(
          name,
          phone,
        );
      } else {
        await customerService.updateCustomer(
          widget.customer!.id!,
          name,
          phone,
        );
      }

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Something went wrong. Please try again 💗",
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.customer != null;

    return Scaffold(
      backgroundColor: const Color(0xfffff7fb),

      // ---------------- APP BAR ----------------

      appBar: AppBar(
        elevation: 0,

        backgroundColor: const Color(0xfffff7fb),

        foregroundColor: const Color(0xff4a3040),

        title: Row(
          children: [

            Text(
              isEditing
                  ? "Edit Customer"
                  : "New Customer",
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xff4a3040),
              ),
            ),

            const SizedBox(width: 8),

            const Text(
              "♡",
              style: TextStyle(
                fontSize: 27,
                color: Color(0xffe98aaa),
              ),
            ),
          ],
        ),
      ),

      // ---------------- BODY ----------------

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const SizedBox(height: 10),

            // ---------------- HEADER ----------------

            Center(
              child: Container(
                width: 90,
                height: 90,

                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xffffb6cd),
                      Color(0xffd9b4ff),
                    ],
                  ),

                  shape: BoxShape.circle,

                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xffe98aaa)
                          .withOpacity(0.25),

                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: const Icon(
                  Icons.person_add_alt_1_rounded,
                  size: 42,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                isEditing
                    ? "Update your customer 💕"
                    : "Add someone to the queue 💕",

                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff4a3040),
                ),
              ),
            ),

            const SizedBox(height: 7),

            Center(
              child: Text(
                isEditing
                    ? "Make sure their details are correct"
                    : "Enter the customer's details below",

                style: const TextStyle(
                  color: Color(0xffa67c8c),
                  fontSize: 13,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ---------------- FORM CARD ----------------

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(28),

                border: Border.all(
                  color: const Color(0xffffe4ed),
                ),

                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  // NAME LABEL

                  const Text(
                    "Customer Name",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff4a3040),
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 9),

                  TextField(
                    controller: nameController,

                    textCapitalization:
                        TextCapitalization.words,

                    decoration: InputDecoration(
                      hintText: "Enter customer name",

                      prefixIcon: const Icon(
                        Icons.person_outline_rounded,
                        color: Color(0xffe98aaa),
                      ),

                      filled: true,

                      fillColor:
                          const Color(0xfffff7fb),

                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(18),

                        borderSide: BorderSide.none,
                      ),

                      focusedBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(18),

                        borderSide:
                            const BorderSide(
                          color: Color(0xffe98aaa),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // PHONE LABEL

                  const Text(
                    "Phone Number",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff4a3040),
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 9),

                  TextField(
                    controller: phoneController,

                    keyboardType:
                        TextInputType.phone,

                    decoration: InputDecoration(
                      hintText: "Enter phone number",

                      prefixIcon: const Icon(
                        Icons.phone_outlined,
                        color: Color(0xffd9a0ed),
                      ),

                      filled: true,

                      fillColor:
                          const Color(0xfffff7fb),

                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(18),

                        borderSide: BorderSide.none,
                      ),

                      focusedBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(18),

                        borderSide:
                            const BorderSide(
                          color: Color(0xffd9a0ed),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ---------------- SAVE BUTTON ----------------

            SizedBox(
              width: double.infinity,
              height: 58,

              child: ElevatedButton(
                onPressed:
                    isSaving ? null : saveCustomer,

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xffe98aaa),

                  disabledBackgroundColor:
                      const Color(0xffffc9d9),

                  foregroundColor: Colors.white,

                  elevation: 5,

                  shadowColor:
                      const Color(0xffe98aaa)
                          .withOpacity(0.3),

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                ),

                child: isSaving

                    ? const SizedBox(
                        width: 24,
                        height: 24,

                        child:
                            CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )

                    : Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,

                        children: [

                          Icon(
                            isEditing
                                ? Icons.check_rounded
                                : Icons.favorite_rounded,
                            size: 21,
                          ),

                          const SizedBox(width: 8),

                          Text(
                            isEditing
                                ? "Update Customer"
                                : "Add to Queue",

                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 15),

            // ---------------- CANCEL ----------------

            SizedBox(
              width: double.infinity,
              height: 50,

              child: TextButton(
                onPressed: isSaving
                    ? null
                    : () {
                        Navigator.pop(context);
                      },

                style: TextButton.styleFrom(
                  foregroundColor:
                      const Color(0xffa67c8c),

                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                ),

                child: const Text(
                  "Maybe later",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ---------------- FOOTER ----------------

            const Center(
              child: Text(
                "Made with ♡ for a smoother queue",
                style: TextStyle(
                  color: Color(0xffc28a9e),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
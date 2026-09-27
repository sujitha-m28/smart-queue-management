import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../services/customer_service.dart';
import '../services/queue_service.dart';
import 'add_customer_screen.dart';
import 'queue_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final CustomerService customerService = CustomerService();
  final QueueService queueService = QueueService();

  List<Customer> customers = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  // ============================================================
  // LOAD CUSTOMERS
  // ============================================================

  Future<void> loadCustomers() async {

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {

      final data = await customerService.getCustomers();

      setState(() {
        customers = data;
        isLoading = false;
      });

    } catch (e) {

      setState(() {
        errorMessage = "Unable to load customers";
        isLoading = false;
      });
    }
  }

  // ============================================================
  // ADD CUSTOMER
  // ============================================================

  Future<void> openAddCustomer() async {

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddCustomerScreen(),
      ),
    );

    loadCustomers();
  }

  // ============================================================
  // EDIT CUSTOMER
  // ============================================================

  Future<void> openEditCustomer(Customer customer) async {

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCustomerScreen(
          customer: customer,
        ),
      ),
    );

    loadCustomers();
  }

  // ============================================================
  // TAKE TOKEN
  // ============================================================

  Future<void> takeToken(Customer customer) async {

    try {

      final result =
          await queueService.takeToken(customer.id!);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Token ${result['tokenNumber']} created for ${customer.name} 💕",
          ),
          backgroundColor: const Color(0xffe98aaa),
        ),
      );

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Failed to take token 💗",
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xfffff7fb),

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        elevation: 0,

        backgroundColor: const Color(0xfffff7fb),

        foregroundColor: const Color(0xff4a3040),

        title: const Row(
          children: [

            Text(
              "SmartQueue ",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xff4a3040),
              ),
            ),

            Text(
              "♡",
              style: TextStyle(
                fontSize: 26,
                color: Color(0xffe98aaa),
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QueueScreen(),
      ),
    );
  },
  icon: const Icon(Icons.queue_rounded),
  tooltip: "Queue",
),
          Container(
            margin: const EdgeInsets.only(right: 8),

            decoration: BoxDecoration(
              color: Colors.white,

              shape: BoxShape.circle,

              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withOpacity(0.08),
                  blurRadius: 10,
                ),
              ],
            ),

            child: IconButton(
              onPressed: loadCustomers,

              icon: const Icon(
                Icons.refresh_rounded,
                color: Color(0xffd76b91),
              ),
            ),
          ),

          const SizedBox(width: 8),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: RefreshIndicator(
        color: const Color(0xffe98aaa),

        onRefresh: loadCustomers,

        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(
            20,
            10,
            20,
            100,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              // ==================================================
              // GREETING
              // ==================================================

              const Text(
                "Hello, lovely! 🌷",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xffa67c8c),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Manage your queue",
                style: TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff4a3040),
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Everything is looking beautiful today ✨",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xffa67c8c),
                ),
              ),

              const SizedBox(height: 25),

              // ==================================================
              // MAIN QUEUE CARD
              // ==================================================

              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,

                    colors: [
                      Color(0xffffa8c5),
                      Color(0xffd9a7ff),
                    ],
                  ),

                  borderRadius: BorderRadius.circular(30),

                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xffe98aaa)
                          .withOpacity(0.25),

                      blurRadius: 25,

                      offset: const Offset(0, 12),
                    ),
                  ],
                ),

                child: Stack(
                  children: [

                    // Decorative circle

                    Positioned(
                      right: -20,
                      top: -30,

                      child: Container(
                        width: 100,
                        height: 100,

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    Positioned(
                      right: 35,
                      bottom: -40,

                      child: Container(
                        width: 80,
                        height: 80,

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.10),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    Row(
                      children: [

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              Container(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),

                                decoration: BoxDecoration(
                                  color:
                                      Colors.white.withOpacity(0.22),

                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),

                                child: const Text(
                                  "♡ LIVE QUEUE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 15),

                              Text(
                                "${customers.length}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const Text(
                                "customers waiting",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),

                              const SizedBox(height: 12),

                              const Text(
                                "Your queue is under control 💕",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.all(20),

                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.20),
                            shape: BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.favorite_rounded,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ==================================================
              // STATS
              // ==================================================

              Row(
                children: [

                  Expanded(
                    child: _StatCard(
                      icon: Icons.people_alt_rounded,
                      title: "Customers",
                      value: "${customers.length}",
                      iconColor: const Color(0xffe98aaa),
                      iconBackground:
                          const Color(0xffffe4ed),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _StatCard(
                      icon: Icons.favorite_rounded,
                      title: "Queue",
                      value: customers.isEmpty
                          ? "Empty"
                          : "Active",
                      iconColor: const Color(0xffa77be8),
                      iconBackground:
                          const Color(0xfff0e7ff),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ==================================================
              // CUSTOMER HEADER
              // ==================================================

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  const Row(
                    children: [

                      Text(
                        "Your Customers ",
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff4a3040),
                        ),
                      ),

                      Text(
                        "♡",
                        style: TextStyle(
                          fontSize: 22,
                          color: Color(0xffe98aaa),
                        ),
                      ),
                    ],
                  ),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: const Color(0xffffe4ed),
                      borderRadius:
                          BorderRadius.circular(20),
                    ),

                    child: Text(
                      "${customers.length} total",
                      style: const TextStyle(
                        color: Color(0xffd76b91),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // ==================================================
              // LOADING
              // ==================================================

              if (isLoading)

                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),

                    child: CircularProgressIndicator(
                      color: Color(0xffe98aaa),
                    ),
                  ),
                )

              // ==================================================
              // ERROR
              // ==================================================

              else if (errorMessage != null)

                Center(
                  child: Container(
                    margin:
                        const EdgeInsets.only(top: 20),

                    padding:
                        const EdgeInsets.all(25),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(25),
                    ),

                    child: Column(
                      children: [

                        const Icon(
                          Icons.cloud_off_rounded,
                          size: 50,
                          color: Color(0xffe98aaa),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          errorMessage!,
                          style: const TextStyle(
                            color: Color(0xff4a3040),
                          ),
                        ),

                        const SizedBox(height: 12),

                        ElevatedButton(
                          onPressed: loadCustomers,

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xffe98aaa),

                            foregroundColor:
                                Colors.white,

                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20),
                            ),
                          ),

                          child:
                              const Text("Try Again"),
                        ),
                      ],
                    ),
                  ),
                )

              // ==================================================
              // EMPTY
              // ==================================================

              else if (customers.isEmpty)

                Center(
                  child: Container(
                    width: double.infinity,

                    padding:
                        const EdgeInsets.all(35),

                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius:
                          BorderRadius.circular(25),
                    ),

                    child: Column(
                      children: [

                        Container(
                          padding:
                              const EdgeInsets.all(20),

                          decoration:
                              const BoxDecoration(
                            color: Color(0xffffeaf1),
                            shape: BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.favorite_border_rounded,
                            size: 45,
                            color: Color(0xffe98aaa),
                          ),
                        ),

                        const SizedBox(height: 18),

                        const Text(
                          "Your queue is empty 💕",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff4a3040),
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "Add your first customer\n"
                          "and start managing your queue.",
                          textAlign: TextAlign.center,

                          style: TextStyle(
                            color: Color(0xffa67c8c),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                )

              // ==================================================
              // CUSTOMER LIST
              // ==================================================

              else

                ListView.builder(
                  shrinkWrap: true,

                  physics:
                      const NeverScrollableScrollPhysics(),

                  itemCount: customers.length,

                  itemBuilder: (context, index) {

                    final customer =
                        customers[index];

                    return _CustomerCard(
                      customer: customer,

                      queuePosition: index + 1,

                      onEdit: () {
                        openEditCustomer(customer);
                      },

                      onTakeToken: () {
                        takeToken(customer);
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),

      // ========================================================
      // ADD CUSTOMER BUTTON
      // ========================================================

      floatingActionButton:
          FloatingActionButton.extended(

        onPressed: openAddCustomer,

        elevation: 8,

        backgroundColor:
            const Color(0xffe98aaa),

        icon: const Icon(
          Icons.add_rounded,
          color: Colors.white,
        ),

        label: const Text(
          "Add Customer",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


// ============================================================
// STAT CARD
// ============================================================

class _StatCard extends StatelessWidget {

  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;
  final Color iconBackground;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.iconColor,
    required this.iconBackground,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(17),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(22),

        boxShadow: [
          BoxShadow(
            color:
                Colors.pink.withOpacity(0.06),

            blurRadius: 15,

            offset:
                const Offset(0, 6),
          ),
        ],
      ),

      child: Row(
        children: [

          Container(
            padding:
                const EdgeInsets.all(11),

            decoration: BoxDecoration(
              color: iconBackground,

              borderRadius:
                  BorderRadius.circular(15),
            ),

            child: Icon(
              icon,

              color: iconColor,

              size: 22,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  title,

                  style: const TextStyle(
                    color: Color(0xffa67c8c),
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,

                  style: const TextStyle(
                    color: Color(0xff4a3040),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// ============================================================
// CUSTOMER CARD
// ============================================================

class _CustomerCard extends StatelessWidget {

  final Customer customer;
  final int queuePosition;

  final VoidCallback onEdit;
  final VoidCallback onTakeToken;

  const _CustomerCard({
    required this.customer,
    required this.queuePosition,
    required this.onEdit,
    required this.onTakeToken,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      margin:
          const EdgeInsets.only(bottom: 13),

      padding:
          const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(22),

        border: Border.all(
          color: const Color(0xffffe4ed),
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.pink.withOpacity(0.05),

            blurRadius: 12,

            offset:
                const Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        children: [

          // ====================================================
          // QUEUE NUMBER
          // ====================================================

          Container(
            width: 48,
            height: 48,

            decoration:
                const BoxDecoration(
              gradient:
                  LinearGradient(
                colors: [
                  Color(0xffffb6cd),
                  Color(0xffd9b4ff),
                ],
              ),

              shape: BoxShape.circle,
            ),

            child: Center(
              child: Text(
                "$queuePosition",

                style:
                    const TextStyle(
                  color: Colors.white,
                  fontWeight:
                      FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
          ),

          const SizedBox(width: 13),

          // ====================================================
          // CUSTOMER INFORMATION
          // ====================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  customer.name,

                  style:
                      const TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Color(0xff4a3040),
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  children: [

                    const Icon(
                      Icons.phone_rounded,
                      size: 14,
                      color:
                          Color(0xffc28a9e),
                    ),

                    const SizedBox(width: 5),

                    Text(
                      customer.phone,

                      style:
                          const TextStyle(
                        color:
                            Color(0xffa67c8c),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  "Customer #${customer.id}",

                  style:
                      const TextStyle(
                    color:
                        Color(0xffc28a9e),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          // ====================================================
          // TAKE TOKEN + EDIT BUTTONS
          // ====================================================

          Row(
            children: [

              Container(
                decoration: BoxDecoration(
                  color:
                      const Color(0xffffedf3),

                  borderRadius:
                      BorderRadius.circular(14),
                ),

                child: IconButton(
                  onPressed: onTakeToken,

                  icon: const Icon(
                    Icons.confirmation_number_rounded,

                    size: 19,

                    color:
                        Color(0xffd76b91),
                  ),

                  tooltip: "Take Token",
                ),
              ),

              const SizedBox(width: 8),

              Container(
                decoration: BoxDecoration(
                  color:
                      const Color(0xffffedf3),

                  borderRadius:
                      BorderRadius.circular(14),
                ),

                child: IconButton(
                  onPressed: onEdit,

                  icon: const Icon(
                    Icons.edit_rounded,

                    size: 19,

                    color:
                        Color(0xffd76b91),
                  ),

                  tooltip: "Edit Customer",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
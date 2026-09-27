import 'package:flutter/material.dart';
import '../models/queue.dart';
import '../services/queue_service.dart';

class QueueScreen extends StatefulWidget {
  const QueueScreen({super.key});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  final QueueService queueService = QueueService();

  List<QueueModel> queueList = [];

  bool isLoading = true;
  bool isCallingNext = false;
Map<int, double> aiPredictions = {};
Map<int, double> aiWaitingPredictions = {};
  @override
  void initState() {
    super.initState();
    loadQueue();
  }

  Future<void> loadQueue() async {
    try {
      final data = await queueService.getQueue();

      if (!mounted) return;

      setState(() {
  queueList = data;
  aiPredictions.clear();
aiWaitingPredictions.clear();
  isLoading = false;
});
   final predictions = await queueService.getAIPredictions();

if (!mounted) return;

setState(() {
  for (final prediction in predictions) {
    final queueId = prediction['queueId'];

    final predictedTime =
        (prediction['predictedServiceTime'] as num).toDouble();

    final predictedWaitingTime =
        (prediction['predictedWaitingTime'] as num).toDouble();

    aiPredictions[queueId] = predictedTime;
    aiWaitingPredictions[queueId] = predictedWaitingTime;
  }
});
    } catch (e) {
      print(e);

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> callNextCustomer() async {
    if (isCallingNext) return;

    setState(() {
      isCallingNext = true;
    });

    try {
      await queueService.callNextCustomer();

      await loadQueue();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Next customer has been called 💕",
          ),
          backgroundColor: Color(0xffe98aaa),
        ),
      );
    } catch (e) {
      print(e);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Could not call the next customer",
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      isCallingNext = false;
    });
  }
  Future<void> loadAIPrediction(int queueId) async {
  try {
    final prediction =
        await queueService.predictServiceTime(queueId);

    if (!mounted) return;

    setState(() {
      aiPredictions[queueId] = prediction;
    });
  } catch (e) {
    print("AI prediction error: $e");
  }
}

  Future<void> completeCustomer(int queueId) async {
    try {
      await queueService.completeCustomer(queueId);

      await loadQueue();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Customer completed successfully 💕",
          ),
          backgroundColor: Color(0xffe98aaa),
        ),
      );
    } catch (e) {
      print(e);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Could not complete customer",
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
  Future<void> cancelToken(int queueId) async {
  try {
    await queueService.cancelToken(queueId);

    await loadQueue();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Token cancelled successfully 💕",
        ),
        backgroundColor: Color(0xffe98aaa),
      ),
    );
  } catch (e) {
    print(e);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Could not cancel token",
        ),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffff7fb),

      // ---------------- APP BAR ----------------

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xfffff7fb),
        foregroundColor: const Color(0xff4a3040),

        title: const Row(
          children: [
            Text(
              "My Queue",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xff4a3040),
              ),
            ),

            SizedBox(width: 8),

            Text(
              "♡",
              style: TextStyle(
                fontSize: 27,
                color: Color(0xffe98aaa),
              ),
            ),
          ],
        ),

        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),

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
              onPressed: loadQueue,

              icon: const Icon(
                Icons.refresh_rounded,
                color: Color(0xffd76b91),
              ),
            ),
          ),
        ],
      ),

      // ---------------- BODY ----------------

      body: RefreshIndicator(
        color: const Color(0xffe98aaa),

        onRefresh: loadQueue,

        child: Column(
          children: [

            // ---------------- QUEUE HEADER ----------------

            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                18,
              ),

              child: Container(
                width: double.infinity,

                padding: const EdgeInsets.all(22),

                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,

                    colors: [
                      Color(0xffffabc7),
                      Color(0xffd9b5ff),
                    ],
                  ),

                  borderRadius: BorderRadius.circular(28),

                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xffe98aaa)
                          .withOpacity(0.22),

                      blurRadius: 20,

                      offset: const Offset(0, 10),
                    ),
                  ],
                ),

                child: Row(
                  children: [

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          const Text(
                            "CURRENT QUEUE",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),

                          const SizedBox(height: 7),

                          Text(
                            "${queueList.length}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 3),

                          const Text(
                            "people in line 💕",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(18),

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.20),
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ---------------- SECTION TITLE ----------------

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),

              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  const Row(
                    children: [

                      Text(
                        "Waiting List",
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff4a3040),
                        ),
                      ),

                      SizedBox(width: 6),

                      Text(
                        "🌷",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: const Color(0xffffe4ed),

                      borderRadius:
                          BorderRadius.circular(20),
                    ),

                    child: Text(
                      "${queueList.length} waiting",

                      style: const TextStyle(
                        color: Color(0xffd76b91),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ---------------- QUEUE LIST ----------------

            Expanded(
              child: isLoading

                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xffe98aaa),
                      ),
                    )

                  : queueList.isEmpty

                      ? Center(
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment.center,

                            children: [

                              Container(
                                padding:
                                    const EdgeInsets.all(22),

                                decoration:
                                    const BoxDecoration(
                                  color: Color(0xffffeaf1),
                                  shape: BoxShape.circle,
                                ),

                                child: const Icon(
                                  Icons.favorite_border_rounded,
                                  size: 50,
                                  color:
                                      Color(0xffe98aaa),
                                ),
                              ),

                              const SizedBox(height: 18),

                              const Text(
                                "Queue is empty 💕",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight:
                                      FontWeight.bold,
                                  color:
                                      Color(0xff4a3040),
                                ),
                              ),

                              const SizedBox(height: 7),

                              const Text(
                                "Everyone has been served!",
                                style: TextStyle(
                                  color:
                                      Color(0xffa67c8c),
                                ),
                              ),
                            ],
                          ),
                        )

                      : ListView.builder(
                          physics:
                              const AlwaysScrollableScrollPhysics(),

                          padding:
                              const EdgeInsets.fromLTRB(
                            20,
                            4,
                            20,
                            20,
                          ),

                          itemCount: queueList.length,

                          itemBuilder: (context, index) {
                            final queue = queueList[index];

return _QueueCard(
  queue: queue,
  position: index + 1,
  aiPrediction: aiPredictions[queue.id],
  aiWaitingPrediction: aiWaitingPredictions[queue.id],
  onComplete: () {
    completeCustomer(queue.id);
  },
  onCancel: () {
    cancelToken(queue.id);
  },
);
                          },
                        ),
            ),

            // ---------------- CALL NEXT BUTTON ----------------

            Container(
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                20,
              ),

              decoration: BoxDecoration(
                color: const Color(0xfffff7fb),

                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.withOpacity(0.06),
                    blurRadius: 15,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),

              child: SizedBox(
                width: double.infinity,
                height: 56,

                child: ElevatedButton(
                  onPressed: queueList.isEmpty ||
                          isCallingNext
                      ? null
                      : callNextCustomer,

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xffe98aaa),

                    disabledBackgroundColor:
                        const Color(0xffffccd9),

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

                  child: isCallingNext

                      ? const SizedBox(
                          width: 24,
                          height: 24,

                          child:
                              CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )

                      : const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,

                          children: [

                            Icon(
                              Icons.campaign_rounded,
                              size: 22,
                            ),

                            SizedBox(width: 9),

                            Text(
                              "Call Next Customer",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            SizedBox(width: 6),

                            Text(
                              "♡",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ============================================================
// QUEUE CARD
// ============================================================

class _QueueCard extends StatelessWidget {
  final QueueModel queue;
  final int position;
  final VoidCallback onComplete;
  final VoidCallback onCancel;
  final double? aiPrediction;
  final double? aiWaitingPrediction;
const _QueueCard({
  required this.queue,
  required this.position,
  this.aiPrediction,
  this.aiWaitingPrediction,
  required this.onComplete,
  required this.onCancel,
});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(22),

        border: Border.all(
          color: const Color(0xffffe4ed),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Row(
        children: [

          // ---------------- POSITION ----------------

          Container(
            width: 52,
            height: 52,

            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xffffb6cd),
                  Color(0xffd9b4ff),
                ],
              ),

              shape: BoxShape.circle,
            ),

            child: Center(
              child: Text(
                "$position",

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          // ---------------- CUSTOMER DETAILS ----------------

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  queue.customerName,

                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff4a3040),
                  ),
                ),

                const SizedBox(height: 6),

                Row(
                  children: [

                    const Icon(
                      Icons.phone_outlined,
                      size: 14,
                      color: Color(0xffc28a9e),
                    ),

                    const SizedBox(width: 5),

                    Text(
                      queue.customerPhone,

                      style: const TextStyle(
                        color: Color(0xffa67c8c),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),

Row(
  children: [
    const Icon(
      Icons.access_time_rounded,
      size: 14,
      color: Color(0xffc28a9e),
    ),

    const SizedBox(width: 5),

    Text(
      "Estimated wait: ${queue.waitingTime} min",
      style: const TextStyle(
        color: Color(0xffa67c8c),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    ),
    if (aiPrediction != null) ...[
  const SizedBox(height: 5),

  Row(
    children: [
      const Icon(
        Icons.auto_awesome_rounded,
        size: 14,
        color: Color(0xff9871c9),
      ),

      const SizedBox(width: 5),

      Text(
        "AI service prediction: ${(aiPrediction! / 60).ceil()} min",
        style: const TextStyle(
          color: Color(0xff9871c9),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  ),
],
if (aiWaitingPrediction != null) ...[
  const SizedBox(height: 5),
  Row(
    children: [
      const Icon(
        Icons.schedule_rounded,
        size: 14,
        color: Color(0xff9871c9),
      ),
      const SizedBox(width: 5),
      Text(
        "AI estimated waiting: ${(aiWaitingPrediction! / 60).ceil()} min",
        style: const TextStyle(
          color: Color(0xff9871c9),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  ),
],
  ],
),
                  ],
                ),

                const SizedBox(height: 6),

                Row(
                  children: [

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),

                      decoration: BoxDecoration(
                        color:
                            const Color(0xffffedf3),

                        borderRadius:
                            BorderRadius.circular(10),
                      ),

                      child: Text(
                        "Token ${queue.tokenNumber}",

                        style: const TextStyle(
                          color: Color(0xffd76b91),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                    ),

                    const SizedBox(width: 7),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),

                      decoration: BoxDecoration(
                        color:
                            const Color(0xfff0e7ff),

                        borderRadius:
                            BorderRadius.circular(10),
                      ),

                      child: Text(
                        queue.status,

                        style: const TextStyle(
                          color: Color(0xff9871c9),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ---------------- COMPLETE BUTTON ----------------

          IconButton(
            onPressed: onComplete,

            icon: const Icon(
              Icons.check_circle_rounded,
              color: Color(0xffe98aaa),
              size: 28,
            ),

            tooltip: "Complete Customer",
          ),
          IconButton(
  onPressed: onCancel,
  icon: const Icon(
    Icons.cancel_rounded,
    color: Colors.redAccent,
    size: 28,
  ),
  tooltip: "Cancel Token",
),
        ],
      ),
    );
  }
}
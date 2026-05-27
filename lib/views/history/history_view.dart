import 'package:flutter/material.dart';
import '../../controllers/history_controller.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = HistoryController();
    final listHistory = controller.getTransactions();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Transaction History', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: listHistory.length,
        itemBuilder: (context, index) {
          final history = listHistory[index];
          final isCancelled = history.status == 'CANCELLED';

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCancelled ? const Color(0xFFFFF1F2) : const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        history.status,
                        style: TextStyle(color: isCancelled ? Colors.red : Colors.blue, fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                    ),
                    Text('\$${history.totalPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(history.destinationName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${history.durationDays} Days Trip • ${history.date}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 12),
                
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: history.tags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                    child: Text(tag, style: const TextStyle(fontSize: 11, color: Color(0xFF475569))),
                  )).toList(),
                ),
                const SizedBox(height: 16),
                
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(isCancelled ? 'Re-book Trip' : 'View Receipt', style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w600)),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
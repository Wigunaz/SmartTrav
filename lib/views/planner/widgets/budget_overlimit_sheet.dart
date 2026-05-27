import 'package:flutter/material.dart';

class BudgetOverlimitSheet extends StatelessWidget {
  final double estimatedCost;
  final double currentBudget;
  final double overlimitAmount;

  const BudgetOverlimitSheet({
    Key? key,
    required this.estimatedCost,
    required this.currentBudget,
    required this.overlimitAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2.5)),
          ),
          const SizedBox(height: 24),
          const CircleAvatar(
            radius: 32,
            backgroundColor: Color(0xFFFFF1F2),
            child: Icon(Icons.warning_amber_rounded, color: Color(0xFFF43F5E), size: 32),
          ),
          const SizedBox(height: 16),
          const Text('Budget Overlimit!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 10),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 14, height: 1.4),
              children: [
                const TextSpan(text: 'Your estimated costs '),
                TextSpan(text: '(\$${estimatedCost.toInt()})', style: const TextStyle(fontWeight: FontWeight.bold)),
                const TextSpan(text: ' exceed your current budget '),
                TextSpan(text: '(\$${currentBudget.toInt()})', style: const TextStyle(fontWeight: FontWeight.bold)),
                const TextSpan(text: ' by '),
                TextSpan(text: '\$${overlimitAmount.toInt()}.', style: const TextStyle(color: Color(0xFFF43F5E), fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF43F5E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Fix Ticket', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }
}
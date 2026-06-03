import 'package:flutter/material.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  // SIMULASI DATA TRANSAKSI (Nanti dialirkan via HistoryController dari Supabase)
  final List<Map<String, dynamic>> _transactionHistory = [
    {
      'nama_paket': 'Paket Kuta-Ubud 3D2N',
      'agency': 'Global Tours',
      'tanggal': '01 Juni 2026',
      'nominal': 1200000.00,
      'status': 'escrow', // Status: Duit masih aman ditahan di rekber platform
    },
    {
      'nama_paket': 'Jogja Heritage Trip',
      'agency': 'Nippon Express',
      'tanggal': '24 Mei 2026',
      'nominal': 1850000.00,
      'status': 'released', // Status: Tur selesai, duit dicairkan ke agen
    },
    {
      'nama_paket': 'Nusa Penida Backpacker Skena',
      'agency': 'Bali Local Guide',
      'tanggal': '12 Mei 2026',
      'nominal': 750000.00,
      'status': 'refunded', // Status: Batal, dana dikembalikan ke konsumen
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Transaction History',
          style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
      ),
      body: _transactionHistory.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_rounded, size: 64, color: const Color(0xFF94A3B8).withOpacity(0.5)),
                  const SizedBox(height: 16),
                  const Text('No transactions yet', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              itemCount: _transactionHistory.length,
              itemBuilder: (context, index) {
                final tx = _transactionHistory[index];
                return _buildHistoryCard(
                  packageName: tx['nama_paket'],
                  agencyName: tx['agency'],
                  date: tx['tanggal'],
                  amount: tx['nominal'],
                  status: tx['status'],
                );
              },
            ),
    );
  }

  // WIDGET BUILDER: Card History Dinamis Pengaman Rekber
  Widget _buildHistoryCard({
    required String packageName,
    required String agencyName,
    required String date,
    required double amount,
    required String status,
  }) {
    Color statusColor;
    String statusText;

    // Menentukan style tag berdasarkan status keamanan dana di database
    switch (status) {
      case 'escrow':
        statusColor = const Color(0xFFF59E0B); // Amber / Kuning
        statusText = 'Secured in Escrow';
        break;
      case 'released':
        statusColor = const Color(0xFF10B981); // Hijau
        statusText = 'Completed & Released';
        break;
      default:
        statusColor = const Color(0xFFEF4444); // Merah
        statusText = 'Refunded';
    }

    // Format nominal ke mata uang Rupiah (Ribuan dipisah koma/titik)
    final formattedAmount = amount.toInt().toString().replaceAllMapped(
          RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"),
          (Match m) => "${m[1]}.",
        );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tag Status Rekber
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              // Nominal Rupiah Paket
              Text(
                'Rp $formattedAmount',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Info Detail Paket & Agen
          Text(
            packageName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 4),
          Text(
            'Guide: $agencyName  •  $date',
            style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFF1F5F9), thickness: 1),
          const SizedBox(height: 8),
          
          // Tombol Aksi Interaktif berdasarkan Alur Proteksi
          SizedBox(
            width: double.infinity,
            height: 40,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFE2E8F0)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              onPressed: () {
                // Handler detail invoice pariwisata atau tracking live checklist
              },
              child: Text(
                status == 'escrow' ? 'Track Live Checklist' : 'View Receipt',
                style: TextStyle(
                  color: status == 'escrow' ? const Color(0xFF3B82F6) : const Color(0xFF0F172A),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
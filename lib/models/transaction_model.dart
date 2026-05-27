class TransactionHistory {
  final String id;
  final String destinationName;
  final String country;
  final int durationDays;
  final String date;
  final double totalPrice;
  final String agencyName;
  final String status; // 'COMPLETED' atau 'CANCELLED'
  final List<String> tags;

  TransactionHistory({
    required this.id,
    required this.destinationName,
    required this.country,
    required this.durationDays,
    required this.date,
    required this.totalPrice,
    required this.agencyName,
    required this.status,
    required this.tags,
  });
}
import '../models/transaction_model.dart';

class HistoryController {
  List<TransactionHistory> getTransactions() {
    return [
      TransactionHistory(
        id: '1',
        destinationName: 'Tokyo, Japan',
        country: 'Japan',
        durationDays: 5,
        date: 'May 12, 2024',
        totalPrice: 1200.00,
        agencyName: 'Nippon Express',
        status: 'COMPLETED',
        tags: ['Shibuya Crossing', 'Mount Fuji', 'Ramen', 'Sushi'],
      ),
      TransactionHistory(
        id: '2',
        destinationName: 'Paris, France',
        country: 'France',
        durationDays: 3,
        date: 'Apr 05, 2024',
        totalPrice: 2450.00,
        agencyName: 'Global Tours',
        status: 'COMPLETED',
        tags: ['Eiffel Tower', 'Louvre Museum', 'Croissant', '+2 more'],
      ),
      TransactionHistory(
        id: '3',
        destinationName: 'Bali, Indonesia',
        country: 'Indonesia',
        durationDays: 7,
        date: 'Mar 15, 2024',
        totalPrice: 0.00,
        agencyName: 'Bali Express',
        status: 'CANCELLED',
        tags: ['Uluwatu Temple', 'Nasi Goreng'],
      ),
    ];
  }
}
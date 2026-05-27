import '../models/destination_model.dart';

class HomeController {
  List<Destination> getTrendingDestinations() {
    return [
      Destination(
        id: '1',
        name: 'Tokyo',
        country: 'Japan',
        imageUrl: 'https://images.unsplash.com/photo-1503899036084-c55cdd92da26',
        rating: 4.9,
      ),
      Destination(
        id: '2',
        name: 'Paris',
        country: 'France',
        imageUrl: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34',
        rating: 4.8,
      ),
    ];
  }
}
class TripPlanner {
  double totalBudget;
  String destination;
  int durationDays;
  String selectedHotel;
  List<String> selectedAttractions;
  List<String> selectedFoods;
  String selectedAgency;
  double agencyCostPerDay;

  TripPlanner({
    required this.totalBudget,
    required this.destination,
    required this.durationDays,
    required this.selectedHotel,
    required this.selectedAttractions,
    required this.selectedFoods,
    required this.selectedAgency,
    required this.agencyCostPerDay,
  });

  // 1. Dibuat dinamis: Jika destinasi belum dipilih/kosong, biaya penerbangan adalah $0
  double get flightCost {
    if (destination.isEmpty) return 0.0;
    
    // Penyesuaian harga tiket pesawat berdasarkan destinasi pilihan
    switch (destination) {
      case 'Tokyo, Japan':
        return 850.00;
      case 'Paris, France':
        return 1200.00;
      case 'Bali, Indonesia':
        return 450.00;
      default:
        return 0.0;
    }
  }

  // 2. Dibuat dinamis: Jika tidak ada atraksi atau kuliner yang dipilih, biayanya $0
  double get activitiesAndFoodCost {
    if (selectedAttractions.isEmpty && selectedFoods.isEmpty) return 0.0;

    // Biaya dasar allowance jika user sudah mulai merencanakan aktivitas
    double baseAllowance = 150.00; 
    
    // Tambahan biaya berdasarkan item yang dicentang/pilih
    double attractionsCost = selectedAttractions.length * 100.00; // Misal $100 per destinasi wisata
    double foodsCost = selectedFoods.length * 50.00;              // Misal $50 per menu makanan
    
    return baseAllowance + attractionsCost + foodsCost;
  }

  // Perhitungan biaya akomodasi harian
  double get hotelAndAgencyCost => agencyCostPerDay * durationDays;
  
  // Total akumulasi seluruh kalkulasi di atas
  double get totalEstimatedCost => flightCost + hotelAndAgencyCost + activitiesAndFoodCost;
  
  // Deteksi overlimit budget
  double get overlimitAmount => totalEstimatedCost - totalBudget;
  bool get isOverlimit => totalEstimatedCost > totalBudget;
}
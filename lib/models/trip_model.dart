class TripPlannerData {
  double totalBudget;
  String destination;
  int durationDays;
  String selectedHotel;
  List<String> selectedAttractions;
  List<String> selectedFoods;
  String selectedAgency;
  double agencyCostPerDay;

  // Nilai cost default berdasarkan data di desain
  double flightCost = 850.00;
  double activitiesAndFoodCost = 450.00;

  TripPlannerData({
    required this.totalBudget,
    required this.destination,
    required this.durationDays,
    required this.selectedHotel,
    required this.selectedAttractions,
    required this.selectedFoods,
    required this.selectedAgency,
    required this.agencyCostPerDay,
  });

  double get hotelAndAgencyCost => agencyCostPerDay * durationDays;
  double get totalEstimatedCost => flightCost + hotelAndAgencyCost + activitiesAndFoodCost;
  double get overlimitAmount => totalEstimatedCost - totalBudget;
  bool get isOverlimit => totalEstimatedCost > totalBudget;
}
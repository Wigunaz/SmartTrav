import 'package:flutter/material.dart';
import '../models/trip_model.dart';
import '../views/planner/widgets/budget_overlimit_sheet.dart';

class TripPlannerController {
  late TripPlannerData model;

  void initData() {
    // Inisialisasi data berdasarkan nilai awal pada screenshot desain
    model = TripPlannerData(
      totalBudget: 1500.00,
      destination: 'Tokyo, Japan',
      durationDays: 5,
      selectedHotel: 'Shinagawa Prince Hotel',
      selectedAttractions: ['Shibuya Crossing', 'Mount Fuji'],
      selectedFoods: ['Ramen'],
      selectedAgency: 'Nippon Express',
      agencyCostPerDay: 420.00, // $420/day
    );
  }

  void checkBudgetConstraint(BuildContext context) {
    if (model.isOverlimit) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => BudgetOverlimitSheet(
          estimatedCost: model.totalEstimatedCost,
          currentBudget: model.totalBudget,
          overlimitAmount: model.overlimitAmount,
        ),
      );
    }
  }
}
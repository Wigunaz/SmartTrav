import 'package:flutter/material.dart';
import '../models/trip_planner_model.dart';
import '../views/planner/widgets/budget_overlimit_sheet.dart';

class PlannerController {
  late TripPlanner model;

  void initData() {
    // Mengubah nilai default menjadi kosong/0 agar tampilan awal bersih
    model = TripPlanner(
      totalBudget: 0.0,
      destination: '',
      durationDays: 0,
      selectedHotel: '',
      selectedAttractions: [],
      selectedFoods: [],
      selectedAgency: '',
      agencyCostPerDay: 0.0,
    );
  }

  void updateBudget(double value) {
    model.totalBudget = value;
  }

  void updateDuration(int days) {
    model.durationDays = days;
  }

  void selectAgency(String agency, double cost) {
    model.selectedAgency = agency;
    model.agencyCostPerDay = cost;
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
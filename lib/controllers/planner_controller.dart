import 'package:flutter/material.dart';
import '../models/trip_planner_model.dart';
import '../views/planner/widgets/budget_overlimit_sheet.dart';

class PlannerController {
  late TripPlanner model;

  void initData() {
    model = TripPlanner(
      totalBudget: 1500.00,
      destination: 'Tokyo, Japan',
      durationDays: 5,
      selectedHotel: 'Shinagawa Prince Hotel',
      selectedAttractions: ['Shibuya Crossing', 'Mount Fuji'],
      selectedFoods: ['Ramen'],
      selectedAgency: 'Nippon Express',
      agencyCostPerDay: 420.00,
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
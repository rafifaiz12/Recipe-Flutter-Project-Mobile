import 'dart:async';

import 'package:flutter/material.dart';
import 'package:siresep/models/meal_plan_template_model.dart';
import 'package:siresep/services/meal_plan_template_service.dart';

class MealPlanTemplateProvider extends ChangeNotifier {
  final MealPlanTemplateService _service = MealPlanTemplateService();

  StreamSubscription<List<MealPlanTemplateModel>>? _subscription;

  List<MealPlanTemplateModel> _templates = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<MealPlanTemplateModel> get templates => _templates;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void listenTemplates() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    _subscription?.cancel();
    _subscription = _service.watchPublishedTemplates().listen(
      (templates) {
        _templates = templates;
        _isLoading = false;
        _errorMessage = null;
        notifyListeners();
      },
      onError: (error) {
        _errorMessage = error.toString();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:siresep/models/meal_plan_template_model.dart';

class MealPlanTemplateService {
  final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection('meal_plan_templates');

  Stream<List<MealPlanTemplateModel>> watchPublishedTemplates() {
    return _collection.where('status', isEqualTo: 'published').snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map((doc) => MealPlanTemplateModel.fromFirestore(doc))
          .toList();
    });
  }
}

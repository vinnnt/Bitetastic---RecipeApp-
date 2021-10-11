import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
    
    // collection reference 
    final CollectionReference recipeCollection = Firestore.instance.collection('recipes');
    
    Future updateUserData (String name, String duration, String difficulty, String ) async {

    }

}
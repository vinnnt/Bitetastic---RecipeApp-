import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  String id;
  String type;
  String name;
  List ingredients = [];
  List preparation = [];
  String difficulty;
  int duration;
  String image;
  int calories;
  Timestamp createdAt;
  Timestamp updatedAt;
  
  Recipe();
  // Recipe({
  //   this.id,
  //   this.type,
  //   this.name,
  //   this.ingredients,
  //   this.preparation,
  //   this.difficulty,
  //   this.duration,
  //   this.imageURL,
  //   this.calories,
  // });

  Recipe.fromMap(Map<String, dynamic> data){
    id = data['id'];
    type = data['type'];
    name = data['name'];
    ingredients = data['ingredients'];
    preparation = data['preparation'];
    difficulty = data['difficulty'];
    duration = data['duration'];
    image = data['image'];
    calories = data['calories'];
    createdAt = data['createdAt'];
    updatedAt = data['updatedAt'];
  }
  
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'type': type,
      'name': name,
      'ingredients': ingredients,
      'preparation': preparation,
      'difficulty' : difficulty,
      'duration' : duration,
      'image' : image,
      'calories' : calories,
      'createdAt' : createdAt,
      'updatedAt' : updatedAt
    };
  }
}


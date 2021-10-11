import 'package:bitetastic/models/recipe.dart';
import 'package:bitetastic/screens/home/recipe-form.dart';
import 'package:bitetastic/services/auth.dart';
import 'package:bitetastic/services/recipe_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RecipeNotifier recipeNotifier = Provider.of<RecipeNotifier>(context);
    final AuthService _auth = AuthService();

    _onRecipedeleted(Recipe recipe) {
      Navigator.pop(context);
      recipeNotifier.deleteRecipe(recipe);
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(recipeNotifier.currentRecipe.name),
        backgroundColor: Colors.green[900],
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                Image.network(
                  recipeNotifier.currentRecipe.image != null ? recipeNotifier.currentRecipe.image : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                width: MediaQuery.of(context).size.width,
                height: 250,
                fit: BoxFit.fitWidth,
                ),

                SizedBox(
                  height: 24,
                ),

                Text(recipeNotifier.currentRecipe.name,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                Text(recipeNotifier.currentRecipe.type.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                SizedBox(
                  height: 24,
                ),


                Text(recipeNotifier.currentRecipe.calories.toString() + ' Calories',
                  style: TextStyle(
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                
                SizedBox(
                  height: 12,
                ),

                Text('Difficulty: ' + recipeNotifier.currentRecipe.difficulty.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                SizedBox(
                  height: 12,
                ),

                Text('Duration: ' + recipeNotifier.currentRecipe.duration.toString() + ' Minutes',
                  style: TextStyle(
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                SizedBox(
                  height: 32,
                ),

                Text(
                  "Ingredients",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, decoration: TextDecoration.underline),
                ),

                ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(18),
                  children: recipeNotifier.currentRecipe.ingredients
                  .map(
                    (ingredient) => Card(
                      // color: Colors.black54,
                      shadowColor: Colors.transparent,
                      child: Container(
                        child: Text(ingredient,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        )),
                      ),
                    )
                  ).toList(),
                ),

                SizedBox(
                  height: 32,
                ),

                Text(
                  "Preparation",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, decoration: TextDecoration.underline),
                ),

                ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(18),
                  children: recipeNotifier.currentRecipe.preparation
                  .map(
                    (preparation) => Card(
                      // color: Colors.black54,
                      shadowColor: Colors.transparent,
                      child: Container(
                        child: Text(preparation,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        )),
                      ),
                    )
                  ).toList(),
                ),

                SizedBox(
                  height: 32,
                ),

              ],
            ),
          ),
        ),
      ),
      

      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
          heroTag: 'editBtn',
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context){
                  return RecipeForm(isUpdating: true,);
                })
              );
          },
          child: Icon(Icons.edit),
          backgroundColor: Colors.green[900],
          foregroundColor: Colors.white,
        ),
        SizedBox(height: 20),
         FloatingActionButton(
          heroTag: 'deleteBtn',
          onPressed: () => _auth.deleteRecipe(recipeNotifier.currentRecipe, _onRecipedeleted),
          child: Icon(Icons.delete),
          backgroundColor: Colors.red[900],
          foregroundColor: Colors.white,
        ),
        ],
  
      ) 
    ); 
    
  }
}
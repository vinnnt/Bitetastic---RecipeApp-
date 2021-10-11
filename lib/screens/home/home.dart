import 'package:bitetastic/models/recipe.dart';
import 'package:bitetastic/screens/home/recipe-detail.dart';
import 'package:bitetastic/screens/home/recipe-form.dart';
import 'package:bitetastic/services/auth.dart';
import 'package:bitetastic/services/recipe_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override 
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  double _iconSize = 20.0;

  @override
  void initState() {
    RecipeNotifier recipeNotifier = Provider.of<RecipeNotifier>(context, listen: false);
    _auth.getRecipes(recipeNotifier);
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    RecipeNotifier recipeNotifier = Provider.of<RecipeNotifier>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize( // New code
        // We set Size equal to passed height (50.0) and infinite width:
        preferredSize: Size.fromHeight(60.0), // New code
          child: AppBar(
          backgroundColor: Colors.white,
          elevation: 2.0,
            bottom: TabBar(
              labelColor: Theme.of(context).indicatorColor,
              indicatorColor: Colors.green[900],
              indicatorWeight: 4.0,
              tabs: [
                Tab(icon: Icon(Icons.restaurant, size: _iconSize, color: Colors.green[900])),
                Tab(icon: Icon(Icons.settings, size: _iconSize, color: Colors.green[900])),
              ], 
            ),
          ),
        ),

        body: Padding(
          padding: EdgeInsets.all(5.0),
          child: TabBarView(
            // Placeholders for content of the tabs:
            children: [
              // food page
              ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Image.network(
                      recipeNotifier.recipeList[index].image != null ? recipeNotifier.recipeList[index].image : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg', 
                    width: 120,
                    fit: BoxFit.fitWidth,
                    ),
                    title: Text(recipeNotifier.recipeList[index].name, style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text(recipeNotifier.recipeList[index].createdAt.toDate().toString()),
                    isThreeLine: true,
                    trailing: Text("Difficulty: " + recipeNotifier.recipeList[index].difficulty + "\n" + "Calories: " + recipeNotifier.recipeList[index].calories.toString()),
                    
                    contentPadding: EdgeInsets.all(8),
                    onTap: () {
                        recipeNotifier.currentRecipe = recipeNotifier.recipeList[index];
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context){
                            return RecipeDetail();
                          })
                        );
                    },
                  );
                },
                itemCount: recipeNotifier.recipeList.length, 
                separatorBuilder: (BuildContext context, int index) { 
                  return Divider(
                    color: Colors.black,
                  );
                },
              ),

              Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 250.0, horizontal: 10.0),
                  child: Column(
                    children: <Widget>[
                      Text("Are you sure you want to log out?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),),
                      SizedBox(width: 20,),
                      // ignore: deprecated_member_use
                      FlatButton.icon(
                      label: Text('Logout'),
                      icon: Icon(Icons.person),
                        onPressed: () async {
                          await _auth.signOut();
                         },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            recipeNotifier.currentRecipe = null;
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context){
                return RecipeForm(isUpdating: false,);
              })
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.green[900],
          foregroundColor: Colors.white,
        ),

      ),
    );
  }
}

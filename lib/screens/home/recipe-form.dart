import 'dart:io';
import 'package:bitetastic/services/auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bitetastic/models/recipe.dart';
import 'package:bitetastic/services/recipe_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeForm extends StatefulWidget {
  // const RecipeForm({ Key key }) : super(key: key);

  final bool isUpdating;
  
  RecipeForm({@required  this.isUpdating});
    
  @override
  _RecipeFormState createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  
  final AuthService _auth = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List _ingredients = [];
  List _preparation = [];
  Recipe _currentRecipe; 
  String _imageUrl;
  File _imageFile;
  TextEditingController ingredientController = new TextEditingController();
  TextEditingController preparationController = new TextEditingController();
  
  @override
  void initState() {
    super.initState();
    RecipeNotifier recipeNotifier = Provider.of<RecipeNotifier>(context, listen: false);
  
    if(recipeNotifier.currentRecipe != null) {
      _currentRecipe = recipeNotifier.currentRecipe;
    }
    else {
      _currentRecipe = Recipe();
    }

    _ingredients.addAll(_currentRecipe.ingredients);
    _preparation.addAll(_currentRecipe.preparation);
    _imageUrl = _currentRecipe.image;
  }  
  
  Widget _showImage() {
    if(_imageFile == null && _imageUrl == null) {
      return Text("Image");
    }
    else if(_imageFile != null) {
      print("Image from file");

      return Stack (
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Image.file(
              _imageFile,
              fit: BoxFit.cover,
              height: 250,),
              // ignore: deprecated_member_use
              FlatButton(
                padding: EdgeInsets.all(16),
                color: Colors.black54,
                child: Text('Change Image', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),),
                onPressed: () => _getImage(),
              )
          ],
      );
    }
    else if(_imageUrl != null) {
        print('image from url');

        return Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Image.network(
              _imageUrl,
              fit: BoxFit.cover,
              height: 250,),
              // ignore: deprecated_member_use
              FlatButton(
                padding: EdgeInsets.all(16),
                color: Colors.black54,
                child: Text('Change Image', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),),
                onPressed: () => _getImage(),
              )
          ],
        );
    }
  }
  
  _getImage() async {
    // ignore: deprecated_member_use
    File imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality : 50,  
      maxWidth: 400
    );
    
    if(imageFile != null) {
      setState(() {
              _imageFile = imageFile;
      });
    }
  }

  Widget _buildNameField(){
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      initialValue: _currentRecipe.name,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value){
        if(value.isEmpty){
          return 'Name is required';
        }

        if(value.length < 3 || value.length > 20){
          return 'Name length must be between 3 and 20';
        }
        
        return null;
      },
      onSaved: (String value){
        _currentRecipe.name = value;
      },
    );
  }

  Widget _buildCategoryField() {
     return TextFormField(
      decoration: InputDecoration(labelText: 'Category'),
      initialValue: _currentRecipe.type,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value){
        if(value.isEmpty){
          return 'Category is required';
        }

        if(value.length < 3 || value.length > 20){
          return 'Category length must be between 3 and 20';
        }
        
        return null;
      },
      onSaved: (String value){
        _currentRecipe.type = value;
      },
    );
  }

  Widget _buildCaloriesField() {
     return TextFormField(
      decoration: InputDecoration(labelText: 'Calories'),
      initialValue: _currentRecipe.calories == null ? "" : _currentRecipe.calories.toString(),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 20),
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      validator: (String value){
        if(value.isEmpty){
          return "Calories can't be 0 or less than 0";
        }
        return null;
      },
      onSaved: (String value){
        _currentRecipe.calories = int.parse(value);
      },
    );
  }

  Widget _buildDifficultyField() {
     return TextFormField(
      decoration: InputDecoration(labelText: 'Difficulty'),
      initialValue: _currentRecipe.difficulty,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value){
        if(value.isEmpty){
          return 'Difficulty is required';
        }

        if(value != "Easy" && value != "Medium" && value != "Hard"){
          return 'Difficulty must be "Easy", "Medium", or "Hard"';
        }
        
        return null;
      },
      onSaved: (String value){
        _currentRecipe.difficulty = value;
      },
    );
  }

  Widget _buildDurationField() {
     return TextFormField(
      decoration: InputDecoration(labelText: 'Duration'),
      initialValue: _currentRecipe.duration == null ? "" : _currentRecipe.duration.toString(),
      keyboardType: TextInputType.number,
      style: TextStyle(fontSize: 20),
      inputFormatters: <TextInputFormatter>[
        
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
      ],
      validator: (value){
        if(value.isEmpty){
          return "Duration can't be 0 or less than 0";
        }
        return null;
      },
      onSaved: (String value){
        _currentRecipe.duration = int.parse(value);
      },
    );
  }

  _buildIngredientField() {
    return SizedBox(width: 200,
    child: TextField(
        decoration: InputDecoration(labelText: 'Ingredients'),
        style: TextStyle(fontSize: 20),
        controller: ingredientController,
        keyboardType: TextInputType.text,
    ),);
  }

  _addIngredient(String text) {
    if(text.isNotEmpty){
      setState(() {
              _ingredients.add(text);
      });  
      ingredientController.clear();
    }
  }

  _buildPreparationField() {
    return SizedBox(width: 200,
    child: TextField(
        decoration: InputDecoration(labelText: 'Preparation'),
        style: TextStyle(fontSize: 20),
        controller: preparationController,
        keyboardType: TextInputType.text,
    ),);
  }

  _addPreparation(String text) {
    if(text.isNotEmpty){
      setState(() {
              _preparation.add(text);
      });  
      preparationController.clear();
    }
  }

  _saveRecipe() {
    if(!_formKey.currentState.validate()){
      return; 
    }

    _formKey.currentState.save();


    _currentRecipe.ingredients = _ingredients;
    _currentRecipe.preparation = _preparation;

    _auth.uploadFoodAndImage(_currentRecipe, widget.isUpdating, _imageFile, _onRecipeUploaded);

    print("name ${_currentRecipe.name}");
    print("category ${_currentRecipe.type}");
    print("calories ${_currentRecipe.calories}");
    print("difficulty ${_currentRecipe.difficulty}");
    print("duration ${_currentRecipe.duration}");
    print("ingredients ${_currentRecipe.ingredients.toString()}");
    print("preparation ${_currentRecipe.preparation.toString()}");
    print("_imageUrl ${_imageUrl}");
    print("_imageFile ${_imageFile.toString()}");
    
  }

  _onRecipeUploaded(Recipe recipe) {
    RecipeNotifier recipeNotifier = Provider.of<RecipeNotifier>(context, listen: false);
    recipeNotifier.addRecipe(recipe);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Form'),
        backgroundColor: Colors.green[900],
        ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key:_formKey,
          // ignore: deprecated_member_use
          autovalidate: true,
          child: Column(children: <Widget>[
            _showImage(),
            SizedBox(height: 16),
            Text(
              widget.isUpdating  ?  "Edit Food" : "Create Food",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
              ),
            SizedBox(height: 16),

            _imageFile == null && _imageUrl == null ?
              ButtonTheme(
              // ignore: deprecated_member_use
              child: RaisedButton(
                  color: Colors.green[900],
                  onPressed: () => _getImage(),
                  child: Text('Add Image', style: TextStyle(color: Colors.white),
                  ),
                ),
              ) : SizedBox(height: 0),

              _buildNameField(),
              _buildCategoryField(),
              _buildCaloriesField(),
              _buildDifficultyField(),
              _buildDurationField(),

              // ingredient
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                _buildIngredientField(),
                // ignore: deprecated_member_use
                ButtonTheme(child: RaisedButton(
                  color: Colors.green[900],
                  child: Text('Add', style: TextStyle(color: Colors.white)),
                  onPressed: () => _addIngredient(ingredientController.text),
                  ),
                )
              ],),
              SizedBox(height: 16),
               GridView.count(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(8),
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  children: _ingredients
                  .map(
                    (ingredient) => Card(
                      color: Colors.black54,
                      child: Center(
                        child: Text(ingredient,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        )),
                      ),
                    )
                  ).toList(),
                ),
              

              // preparation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                _buildPreparationField(),
                // ignore: deprecated_member_use
                ButtonTheme(child: RaisedButton(
                  color: Colors.green[900],
                  child: Text('Add', style: TextStyle(color: Colors.white)),
                  onPressed: () => _addPreparation(preparationController.text),
                  ),
                )
              ],),
              SizedBox(height: 16),
               GridView.count(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.all(16),
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  children: _preparation
                  .map(
                    (preparation) => Card(
                      color: Colors.black54,
                      child: Center(
                        child: Text(preparation,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        )),
                      ),
                    )
                  ).toList(),
                ),
            ]
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _saveRecipe(),
        child: Icon(Icons.save),
        backgroundColor: Colors.green[900],
        foregroundColor: Colors.white,
      ),

    );
  }
}

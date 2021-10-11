import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:bitetastic/models/recipe.dart';
import 'package:bitetastic/models/user.dart';
import 'package:bitetastic/services/recipe_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }

  // sign in with email password

  Future signIn(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (error) {
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          return "Please input a valid email";
          break;
        case "ERROR_WRONG_PASSWORD":
          return "Please input a valid password";
          break;
        case "ERROR_USER_NOT_FOUND":
          return "User not found";
          break;
        case "ERROR_USER_DISABLED":
          return "User has been disabled";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          return "Too many requests. Try again later";
          break;
        default:
          return "Unknown error";
      }
    }
  }

  // register email and password

  Future register(String email, String password, String username) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      
      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = username;

      FirebaseUser user = result.user;

      await user.updateProfile(updateInfo);
      await user.reload();

      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // get username

  getUsername() async {
    final FirebaseUser firebaseUser = await _auth.currentUser();
    final String username = firebaseUser.displayName;
    print(username);
    return username;
  }

  // get recipe

  getRecipes(RecipeNotifier recipeNotifier) async {
    QuerySnapshot snapshot = await Firestore.instance
    .collection('recipes')
    .orderBy("createdAt", descending: true)
    .getDocuments();
    
    List <Recipe> _recipeList = [];

    snapshot.documents.forEach((element) {
      Recipe recipe = Recipe.fromMap(element.data);
      _recipeList.add(recipe);
    });

    recipeNotifier.recipeList = _recipeList;
  }

  // update recipe
  uploadFoodAndImage(Recipe recipe, bool isUpdating, File localFile, Function recipeUploaded) async{
    if(localFile != null) {
      print("uploading image");

      var fileExtension = path.extension(localFile.path);
      print(fileExtension);

      var uuid = Uuid().v4();
      
      final StorageReference firebaseStorageRef = 
        FirebaseStorage.instance.ref().child('recipe/images/$uuid$fileExtension');
        
        await firebaseStorageRef.putFile(localFile).onComplete.catchError(
          (onError) {
            print(onError);
            return false;
          }
        );
        
      String url = await firebaseStorageRef.getDownloadURL();
      print("download url: $url");
      _uploadRecipe(recipe, isUpdating, recipeUploaded, imageUrl: url);
      //upload recipe
    }
    else {
      print ('... skipping image upload');
      _uploadRecipe(recipe, isUpdating, recipeUploaded);
    }
  } 

  _uploadRecipe(Recipe recipe, bool isUpdating, Function recipeUploaded, {String imageUrl}) async {
    CollectionReference recipeRef = await Firestore.instance.collection('recipes');
    
    if (imageUrl != null) {
        recipe.image = imageUrl;
    }
    if(isUpdating){
      recipe.updatedAt = Timestamp.now();  

      await recipeRef.document(recipe.id).updateData(recipe.toMap());  
      
      recipeUploaded(recipe);
      
      print('updated food with id: ${recipe.id}');
    }
    else{
      recipe.createdAt = Timestamp.now();
      
      DocumentReference documentRef = await recipeRef.add(recipe.toMap());

      recipe.id = documentRef.documentID;

      print('uploaded recipe successfully: ${recipe.toString()}');
    
      await documentRef.setData(recipe.toMap(), merge: true);

      recipeUploaded(recipe);
    } 
  }

  // delete recipe
  deleteRecipe(Recipe recipe, Function recipeDeleted) async {
   if(recipe.image != null) {
      StorageReference storageReference = 
        await FirebaseStorage.instance.getReferenceFromUrl(recipe.image);

        print(storageReference.path);

        await storageReference.delete();
        
        print('Image successfully deleted');
    }

    await Firestore.instance.collection('recipes').document(recipe.id).delete();
    recipeDeleted(recipe);
  }

}



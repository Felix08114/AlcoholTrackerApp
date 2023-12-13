import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myalcoholtrackerapp/utility/userInfo.dart';

//genders
double maleConstant = 0.68;
double femaleConstant = 0.55;

//alcohol bacs
double beerBAC = 0.05;
double redwineBAC = 0.135;
double whitewineBAC = 0.12;
double cocktailBAC = 0.22;

Future<String> getBloodAlcoholLevel() async {
  final _firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  late User loggedInUser;
  double sum = 0;
  double genderConstant = user_Info_gender == "Male" ? maleConstant : femaleConstant;

  try{
    final user = await auth.currentUser;
    if (user != null){
      loggedInUser = user;
    }
    var docRef = _firestore.collection('drinks').doc(loggedInUser.email);
    DocumentSnapshot doc = await docRef.get();
    final data = await doc.data() as Map<String, dynamic>;
    String today = DateTime.now().toString().split(" ")[0];
    Map<String, dynamic> drinksforToday = data [today];
    drinksforToday.forEach((k, v) {
      Map<String, dynamic> timeAndOunces = v;
      if (k == "Beer") {
        timeAndOunces.forEach((k, v){
          sum += ((v* 29.5735 * beerBAC * 0.789) / (genderConstant * user_Info_Weight * 454) * 100) -
              (0.015 * DateTime.now().difference(DateTime.parse(k)).inMinutes / 60);
          print(sum);
        });
      }
      if (k == "White Wine" || k== "Rose Wine") {
        timeAndOunces.forEach((k, v){
          sum += ((v* 29.5735 * whitewineBAC * 0.789) / (genderConstant * user_Info_Weight * 454) * 100) -
              (0.015 * DateTime.now().difference(DateTime.parse(k)).inMinutes / 60);
          print(sum);
        });
      }
      if (k == "Red Wine") {
        timeAndOunces.forEach((k, v){
          sum += ((v* 29.5735 * redwineBAC * 0.789) / (genderConstant * user_Info_Weight * 454) * 100) -
              (0.015 * DateTime.now().difference(DateTime.parse(k)).inMinutes / 60);
          print(sum);
        });
      }
      if (k == "Cocktail") {
        timeAndOunces.forEach((k, v){
          sum += ((v* 29.5735 * cocktailBAC * 0.789) / (genderConstant * user_Info_Weight * 454) * 100) -
              (0.015 * DateTime.now().difference(DateTime.parse(k)).inMinutes / 60);
          print(sum);
        });
      }
    });
  }

  catch(e){
    print(e);
  }
  return sum.toStringAsFixed(2);
}
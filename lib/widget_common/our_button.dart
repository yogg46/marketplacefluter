import 'package:marketplace/consts/consts.dart';


Widget ourButton({onPress, color, textcolor, String? title }){
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      primary: color,
      padding: EdgeInsets.all(12)
    ),  
    
    
  onPressed: onPress,
  
  child: title!.text.color(textcolor).fontFamily(bold).make()); 
}
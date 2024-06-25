//Extensions allow you to add new functionality to existing classes.

extension ExtString on String{
 String? get isValidEmail {
  if (!RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+$').hasMatch(this)) {
    return 'Please enter a valid email address';
  }
  // If the condition is met, return null
  return null;
}


  String? get isValidPassword {
  //password regular expression...
  if (!RegExp(r'^(?=.*?[A-Z])').hasMatch(this)) {
    return 'The password should have at least one uppercase letter';
  }
  
  if (!RegExp(r'^(?=.*?[a-z])').hasMatch(this)) {
    return 'The password should have at least one lowercase letter';
  }
  
  if (!RegExp(r'^(?=.*?[0-9])').hasMatch(this)) {
    return 'The password should have at least one number';
  }
  
  if (!RegExp(r'^(?=.*?[#?!@$%^&*-])').hasMatch(this)) {
    return 'The password should have at least one special character';
  }
  
  if (!RegExp(r'^.{8,}$').hasMatch(this)) {
    return 'The password should be at least 8 characters long';
  }
  //if all conditions are met..
  return null;
}


  String? get isValidPhone {
  
  if (!RegExp(r'^[67]').hasMatch(this)) {
    return 'The phone number must start with 6 or 7';
  }
  
  if (!RegExp(r'^[0-9]{9}$').hasMatch(this)) {
    return 'Phone number must have 9 digits';
  }
  // If both conditions are met, return null
  return null;
}

}
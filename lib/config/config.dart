import 'package:global_configuration/global_configuration.dart';
import 'package:sugoapp/config/user.dart';

String getUserConfig(String key) {
  return GlobalConfiguration().getString(key);
}

void updateUserConfig(String key, String value) {
  GlobalConfiguration().updateValue(key, value);
}

void clearGlobalConfig() {
  GlobalConfiguration().updateValue('usertype', '');
  GlobalConfiguration().updateValue('usertype', '');
  GlobalConfiguration().updateValue('firstname', '');
  GlobalConfiguration().updateValue('middlename', '');
  GlobalConfiguration().updateValue('lastname', '');
  GlobalConfiguration().updateValue('gender', '');
  GlobalConfiguration().updateValue('birthday', '');
  GlobalConfiguration().updateValue('contact', '');
  GlobalConfiguration().updateValue('email', '');
  GlobalConfiguration().updateValue('idtype', '');
  GlobalConfiguration().updateValue('imagepath', '');
}

void getUserMapLength() {
  print(userProfile.length);
}

void printUserProfile() {
  print('Usertype > ${getUserConfig('usertype')}');
  print('firstname > ${getUserConfig('firstname')}');
  print('middlename > ${getUserConfig('middlename')}');
  print('lastname > ${getUserConfig('lastname')}');
  print('gender > ${getUserConfig('gender')}');
  print('birthday > ${getUserConfig('birthday')}');
  print('contact > ${getUserConfig('contact')}');
  print('code > ${getUserConfig('code')}');
  print('email > ${getUserConfig('email')}');
  print('password > ${getUserConfig('password')}');
  print('idtype > ${getUserConfig('idtype')}');
  print('imagepath > ${getUserConfig('imagepath')}');
}

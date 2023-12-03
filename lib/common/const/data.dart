import 'dart:io';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

String emulatorIp = '10.0.2.2:3000';
String simulatorIp = '127.0.0.1:3000';
String ip = Platform.isAndroid ? emulatorIp : simulatorIp;

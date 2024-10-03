# FRONTEND
 
The frontend of the app is built in flutter. 

## Building the APK file

After cloning the files into a local system, the APK file can be built using the following steps-
1. Install Flutter by using th eofficial instructions (https://docs.flutter.dev/get-started/install)
2. Install Android Studio and Android SDK
3. Add Flutter and Dart extensions to VS Code
4. Open VS Code and navigate to the project directory
5. Ensure that you are in the Flutter project root directory
6. In the terminal, run the following command- flutter pub get
   This will install all the necessary dependencies.
7. Run the following command to build the APK- flutter build apk

The APK file can be found in the following location - build/app/outputs/flutter-apk/

## Changing the IP address

Whenever the IP address needs to be changed, changes have to be made in the following files -
1. home.dart on line 51
2. loading_page.dart on line 41
3. prediction.dart on lines 29, 95, 194 and 242
4. conv.dart on line 57

The ports and the routes will remain the same.

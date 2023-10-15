import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_phone_auth/homepage.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      );
  runApp(MaterialApp(
    home: LoginPage(),
  ));
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final phone_controller = TextEditingController();
  final otp_controller = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  String verificationId = "";
  bool otpVisibility = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Phone Authentication"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: IntlPhoneField(
                  controller: phone_controller,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                  ),
                  initialCountryCode: 'IN',
                  // onChanged: (phone) {
                  //   print(phone.completeNumber);
                  // },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: otp_controller,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "OTP Verification"),
                ),
              ),
              MaterialButton(
                color: Colors.grey,
                onPressed: () {
                  if (otpVisibility) {
                    verifyOtp();
                  } else {
                    LOginwithPhone();
                  }
                },
                child: Text(otpVisibility ? 'Verify' : 'Login'),
              )
            ],
          ),
        ));
  }

  void verifyOtp() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
       smsCode: otp_controller.text);
       await auth.signInWithCredential(credential).then((value) {
        setState(() {
          user = FirebaseAuth.instance.currentUser;
        });
       }
       ).whenComplete(() {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (contex)=>HomePage()));
       });
  }

  void LOginwithPhone() {
    auth.verifyPhoneNumber(
        phoneNumber: phone_controller.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then((value) {
            print("Logged Successfully");
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          otpVisibility = true;
          verificationId = verificationId;
          setState(() {});
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }
}

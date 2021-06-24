
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'authentication_error.dart';
import '../home.dart';

class Login extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<Login> {

  String login_Email = "";  // 入力されたメールアドレス
  String login_Password = "";  // 入力されたパスワード
  String infoText = "";  // ログインに関する情報を表示

  // Firebase Authenticationを利用するためのインスタンス
  final FirebaseAuth auth = FirebaseAuth.instance;
  AuthResult result;
  FirebaseUser user;

  // エラーメッセージを日本語化するためのクラス
  final auth_error = Authentication_error();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            // メールアドレスの入力フォーム
            Padding(
                padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 0),
                child:TextFormField(
                  decoration: InputDecoration(
                      labelText: "メールアドレス"
                  ),
                  onChanged: (String value) {
                    login_Email = value;
                  },
                )
            ),

            // パスワードの入力フォーム
            Padding(
              padding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 10.0),
              child:TextFormField(
                decoration: InputDecoration(
                    labelText: "パスワード（8～20文字）"
                ),
                obscureText: true,  // パスワードが見えないようRにする
                maxLength: 20,  // 入力可能な文字数
                maxLengthEnforced: false,  // 入力可能な文字数の制限を超える場合の挙動の制御
                onChanged: (String value) {
                  login_Password= value;
                },
              ),
            ),

            // ログイン失敗時のエラーメッセージ
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 5.0),
              child:Text(infoText,
                style: TextStyle(color: Colors.red),),
            ),

            ButtonTheme(
              minWidth: 350.0,
              // height: 100.0,
              child: RaisedButton(
                  child: Text('ログイン',
                    style: TextStyle(fontWeight: FontWeight.bold),),
                  textColor: Colors.white,
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),

                  onPressed: () async {
                    try {
                      print(login_Email);
                      print(login_Password);
                      // メール/パスワードでユーザー登録
                      result = await auth.signInWithEmailAndPassword(
                        email: login_Email,
                        password: login_Password,
                      );

                      // ログイン成功
                      // ログインユーザーのIDを取得
                      user = result.user;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(user_id: user.uid),
                          )
                      );

                    } catch (e) {
                      // ログインに失敗した場合
                      setState(() {
                        infoText = auth_error.login_error_msg(e.code);
                      });
                    }
                  }
              ),
            ),
          ],
        ),
      ),

    );
  }
}
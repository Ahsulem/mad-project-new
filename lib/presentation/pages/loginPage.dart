import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/common/widgets/button/my_button.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:spotify/data/models/auth/signin_user_req.dart';
import 'package:spotify/domain/usecases/auth/signin.dart';
import 'package:spotify/presentation/pages/home/pages/home.dart';
import 'package:spotify/presentation/pages/registerpage.dart';
import 'package:spotify/service_locater.dart';

class Loginpage extends StatelessWidget {
  Loginpage({super.key});
  final TextEditingController _emailtxtcontroller = TextEditingController();
  final TextEditingController _passwordtxtcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 40,
          width: 40,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _loginText(),
                  const SizedBox(
                    height: 25,
                  ),
                  _email(context),
                  const SizedBox(
                    height: 25,
                  ),
                  _password(context),
                  const SizedBox(
                    height: 25,
                  ),
                  MyButton(
                      onpressed: () async {
                        var result = await sl<SigninUseCase>().call(
                          params: SigninUserReq(
                            email: _emailtxtcontroller.text.toString(),
                            password: _passwordtxtcontroller.text.toString(),
                          ),
                        );
                        result.fold((l) {
                          var snackbar = SnackBar(
                            content: Text(l.toString()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        }, (r) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RootPage()),
                              (route) => false);
                        });
                      },
                      txt_title: 'L O G I N'),
                ],
              ),
              _registerText(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginText() {
    return const Text(
      'LOGIN',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget _email(BuildContext context) {
    return TextField(
      controller: _emailtxtcontroller,
      decoration: const InputDecoration(hintText: 'Enter Email')
          .applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _password(BuildContext context) {
    return TextField(
      controller: _passwordtxtcontroller,
      decoration: const InputDecoration(hintText: 'Enter Password')
          .applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }

  Widget _registerText(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Registerpage()));
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Text('Do Not Have an Account?'),
           SizedBox(
            width: 5,
          ),
           Text(
            'Register',
            style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 15),
          )
        ],
      ),
    );
  }
}

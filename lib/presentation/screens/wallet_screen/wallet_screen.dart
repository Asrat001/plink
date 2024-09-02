import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plinko/config/routing.dart';
import 'package:plinko/data/models/wallet_model.dart';
import 'package:plinko/gen/assets.gen.dart';
import 'package:plinko/presentation/widgets/button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});
  @override
  State<WalletScreen> createState() => _WalletScreenState();
}
class _WalletScreenState extends State<WalletScreen> {
  var selected;
  @override
  void initState() {
    super.initState();
    checkSelectedvalue();
  }
  checkSelectedvalue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    selected = await prefs.getString('selectedCurrency');
    if(selected == null){
      selected = "Ethereum";
    }
    print("====== ????$selected");
    // Ethereum
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 160),
            Text(
              'Your Wallet',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 27,
              ),
            ),
            const SizedBox(height: 7),
            _buildWalletOption(
              title: 'Solana',
              amount: 273.270,
              iconPath: Assets.images.solanaLogo.path,
            ),
            _buildWalletOption(
              title: 'Ethereum',
              amount: 3.038,
              iconPath: Assets.images.ethereumLogo.path,
            ),
            _buildWalletOption(
              title: 'Bitcoin',
              amount: 1.027,
              iconPath: Assets.images.bitcoinLogo.path,
            ),
            _buildWalletOption(
              title: 'USDT',
              amount: 373.033,
              iconPath: Assets.images.tetherLogo.path,
            ),
          ],
        ),
      ),
    );
  }
  _buildWalletOption({
    required String title,
    required double amount,
    required String iconPath,
  }) {
    return ButtonWidget(
      onPressed: () async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('selectedCurrency', title);
        selected = title;
        print(selected);
        context.pushNamed(RouteName.walletDetail,
            extra: WalletModel(
              walletName: title,
              amount: amount,
              iconPath: iconPath,
            )).then((value) {
          setState(() {});
        },);
      },
      child: Row(
        children: [
          Image.asset(
            iconPath,
            width: 24,
            height: 24,
            color: const Color(0xFFCBB2CB),
          ),
          const SizedBox(width: 15),
          RichText(
            text: TextSpan(
                text: title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontSize: 17, color: Colors.white, shadows: [
                  Shadow(
                      offset: const Offset(0, 4),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.25))
                ]),
                children: [
                  TextSpan(
                      text: '  $amount',
                      style: const TextStyle(
                        color: Color(0xFFCCB3CC),
                      ))
                ]),
          ),
          Spacer(),
          selected == title ?Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 10,),
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFFA7DE),
                      Color(0xFFFF77CC),
                    ]),
                borderRadius: BorderRadius.circular(20)
            ),
            height: 26,
            child: const Text("Selected",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15),),
          ):const SizedBox()
        ],
      ),
    );
  }
}
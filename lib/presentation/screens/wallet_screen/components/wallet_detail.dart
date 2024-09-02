import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plinko/config/routing.dart';
import 'package:plinko/data/models/wallet_model.dart';
import 'package:plinko/presentation/screens/login_screen/login_screen.dart';
import 'package:plinko/presentation/widgets/button_widget.dart';
import 'package:plinko/presentation/widgets/container_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/responsive_util.dart';
import '../../home_screen/components/bet_button.dart';
import '../../home_screen/components/deposit_bonusScreen.dart';

class WalletDetail extends StatefulWidget {
  final WalletModel walletModel;
  const WalletDetail({super.key, required this.walletModel});

  @override
  State<WalletDetail> createState() => _WalletDetailState();
}

class _WalletDetailState extends State<WalletDetail> {
  final amountController = TextEditingController();
  final addressController = TextEditingController();
  Alignment amountAlignment = Alignment.centerLeft;
  double titleScale = 0.7;


  startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      amountAlignment = Alignment.centerRight;
      titleScale = 1;
    });
  }

  @override
  void initState() {
    amountController.text = '0';
    addressController.text = '0x';
    startAnimation();
    selected();
    super.initState();
  }

  selected() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(widget.walletModel.walletName == "Solana"){
      await prefs.setInt('selected', 1);
    } else if(widget.walletModel.walletName == "Ethereum"){
      await prefs.setInt('selected', 2);
    } else if(widget.walletModel.walletName == "Bitcoin"){
      await prefs.setInt('selected', 3);
    } else if(widget.walletModel.walletName == "USDT"){
      await prefs.setInt('selected', 4);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 100.sh,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 50),
            ButtonWidget(
              height: 64,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Back",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 23,
                        ),
                  ),
                ],
              ),
              onPressed: () {
                context.pop();
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                AnimatedScale(
                  duration: const Duration(milliseconds: 400),
                  scale: titleScale,
                  child: Text(
                    widget.walletModel.walletName,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: 27,
                        ),
                  ),
                ),
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    alignment: amountAlignment,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          widget.walletModel.iconPath,
                          width: 24,
                          height: 24,
                          color: const Color(0xFFCBB2CB),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          '${widget.walletModel.amount}',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontSize: 19,
                                    color: const Color(0xFFCCB3CC),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ButtonWidget(
              height: 56,
              onPressed: null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.download,
                          color: Colors.white,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Deposit',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                          ),
                          Text(
                            '0xED3f...67e7',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: const Color(0xFFCCB3CC),
                                  fontSize: 11,
                                ),
                          )
                        ],
                      )
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      //
                    },
                    icon: Row(
                      children: [
                        const Icon(
                          Icons.copy,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Copy',
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontSize: 17,
                                  ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 5,),
            BetButton(
              onTab: () {
                // Navigator.push(context,MaterialPageRoute(builder: (context) => const DepositBounus()));
                context.pushNamed(RouteName.bonusScreen);
              },
              textColor: Colors.black87,
              title: 'Select for the next game',
                gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFFA7DE),
                      Color(0xFFFF77CC),
                    ])
            ),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Cashout',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                      fontSize: 19,
                    ),
              ),
            ),
            const SizedBox(height: 10),
            ContainerWidget(
              height: 53,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: TextField(
                          controller: amountController,
                          style: const TextStyle(
                            color: Colors.white24,
                          ),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 15),
                            border: InputBorder.none,
                          ),
                        )),
                        Text(
                          'Amount to withdraw',
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontSize: 11,
                                    color: const Color(0xFFCCB3CC),
                                  ),
                        ),
                        const SizedBox(height: 7),
                      ],
                    )),
                    InkWell(
                      onTap: () {
                        //
                      },
                      child: Container(
                        width: 48,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'MAX',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontSize: 13,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            ContainerWidget(
              height: 53,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: TextField(
                          controller: addressController,
                          style: const TextStyle(
                            color: Colors.white24,
                          ),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 15),
                            border: InputBorder.none,
                          ),
                        )),
                        Text(
                          '${widget.walletModel.walletName} Address',
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontSize: 11,
                                    color: const Color(0xFFCCB3CC),
                                  ),
                        ),
                        const SizedBox(height: 7),
                      ],
                    )),
                    InkWell(
                      onTap: () {
                        //
                      },
                      child: Container(
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            'PASTE',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontSize: 13,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            ButtonWidget(
              height: 48,
              padding: EdgeInsets.zero,
              gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF5E4D5E),
                    Color(0xFF3A2F3A),
                  ]),
              child: Center(
                child: Text(
                  'Fill the fields to Withdraw',
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Colors.white30,
                        fontSize: 19,
                      ),
                ),
              ),
              onPressed: () {
                //
              },
            ),
          ],
        ),
      ),
    );
  }
}

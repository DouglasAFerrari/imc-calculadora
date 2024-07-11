import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:imc/components/icon_content.dart';
import 'package:imc/components/reusable_card.dart';
import 'package:imc/constants.dart';
import 'package:imc/screens/results_page.dart';
import 'package:imc/components/bottom_button.dart';
import 'package:imc/components/round_icon_button.dart';
import 'package:imc/calculator_brain.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher.dart';

enum Gender {
  male,
  female,
}

const int maxAttempts = 3;

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  Gender selectedGender;
  int height = 170;
  double weight = 70.000;
  int age = 30;

  BannerAd staticAd;
  bool staticAdLoaded = false;

  RewardedAd rewardedAd;
  int rewardedAdAttempts = 0;

  InterstitialAd interstitialAd;
  int numInterstitialLoadAttempts = 0;

  static const AdRequest request = AdRequest(
    // keywords: ['', ''],
    // contentUrl: '',
    // nonPersonalizedAds: false
  );

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-2222616495258461/9749906781',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            interstitialAd = ad;
            numInterstitialLoadAttempts = 0;
            interstitialAd.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            numInterstitialLoadAttempts += 1;
            interstitialAd = null;
            if (numInterstitialLoadAttempts < maxAttempts) {
              createInterstitialAd();
            }
          },
        ));
  }

  void showInterstitialAd() {
    if (interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd();
      },
    );
    interstitialAd.show();
    interstitialAd = null;
  }

  void createRewardedAd() {
    RewardedAd.load(
        adUnitId: "ca-app-pub-2222616495258461/5068322171",
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (ad){
              rewardedAd = ad;
              rewardedAdAttempts = 0;
            },
            onAdFailedToLoad: (error){
              rewardedAdAttempts++;
              rewardedAd = null;
              print('failed to load ${error.message}');

              if(rewardedAdAttempts <= maxAttempts){
                createRewardedAd();
              }
            })
    );
  }

  void showRewardedAd() {
    if(rewardedAd == null){
      print('trying to show before loading');
      return;
    }

    rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) => print('ad showed $ad'),
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          createRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error){
          ad.dispose();
          print('failed to show the ad $ad');

          createRewardedAd();
        }
    );

    rewardedAd.show(onUserEarnedReward: (ad, reward){
      print('reward video ${reward.amount} ${reward.type}');
    });
    rewardedAd = null;
  }


  void loadStaticBannerAd() {
    staticAd = BannerAd(
        adUnitId: "ca-app-pub-2222616495258461/6381403842",
        size: AdSize.banner,
        request: request,
        listener: BannerAdListener(
            onAdLoaded: (ad) {
              setState(() {
                staticAdLoaded = true;
              });
            },
            onAdFailedToLoad: (ad, error){
              ad.dispose();

              print('ad failed to load ${error.message}');
            }
        )
    );

    staticAd.load();
  }

  @override
  void initState() {
    super.initState();
    loadStaticBannerAd();
    createInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text('IMC CALCULADORA',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      drawer: Drawer(
        elevation: 10,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('IMC Calculadora',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text('Sua ferramenta para verificar \no índice de massa corporal.',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              currentAccountPicture: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                        Radius.circular(5)
                    ),
                    border: Border.all(width: 2, color: Colors.black)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Image.asset(
                    "imagens/icone.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: ()  {
                Navigator.pop(context);
              },
              child: ListTile(
                leading: Icon(Icons.calculate),
                title: RichText(
                  text: TextSpan(
                    text: "Calcular IMC",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                var url = "https://play.google.com/store/apps/details?id=desenvolvedor.flutter.com.notas";
                if (await canLaunch(url)){
                  await launch(url);
                }else{
                  throw "site fora do ar";
                }
              },
              child: ListTile(
                leading: Icon(Icons.note_add),
                title: RichText(
                  text: TextSpan(
                    text: "Bloco de notas",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                var url = "https://play.google.com/store/apps/details?id=douglasferrari.com.loto_facil.free";
                if (await canLaunch(url)){
                  await launch(url);
                }else{
                  throw "site fora do ar";
                }
              },
              child: ListTile(
                leading: Icon(Icons.monetization_on),
                title: RichText(
                  text: TextSpan(
                    text: "Baixar Aplicativo LotoFácil",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                var url = "https://play.google.com/store/apps/details?id=desenvolvedor.flutter.imc.imc_calculadora";
                if (await canLaunch(url)){
                  await launch(url);
                }else{
                  throw "site fora do ar";
                }
              },
              child: ListTile(
                leading: Icon(Icons.star_rate),
                title: RichText(
                  text: TextSpan(
                    text: "Avalie-nos",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(10),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(

                  child: Row(

                    children: <Widget>[
                      Expanded(
                        child: ReusableCard(

                          onPress: () {
                            setState(() {
                              selectedGender = Gender.male;
                            });
                          },
                          colour: selectedGender == Gender.male
                              ? kActiveCardColour
                              : kInactiveCardColour,
                          cardChild: IconContent(
                            icon: FontAwesomeIcons.male,
                            label: 'MASCULINO',
                          ),
                        ),
                      ),
                      Expanded(
                        child: ReusableCard(
                          onPress: () {
                            setState(() {
                              selectedGender = Gender.female;
                            });
                          },
                          colour: selectedGender == Gender.female
                              ? kActiveCardColour
                              : kInactiveCardColour,
                          cardChild: IconContent(
                            icon: FontAwesomeIcons.female,
                            label: 'FEMININO',
                          ),
                        ),
                      ),
                    ],
                  )),
              Expanded(
                child: ReusableCard(
                  colour: kActiveCardColour,
                  cardChild: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'ALTURA',
                        style: kLabelTextStyle,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Text(
                            height.toString(),
                            style: kNumberTextStyle,
                          ),
                          Text(
                            'cm',
                            style: kLabelTextStyle,
                          )
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          inactiveTrackColor: Color(0xFF4C4F5E),
                          activeTrackColor: Colors.white,
                          thumbColor: Colors.black,
                          overlayColor: Color(0x29EB1555),
                          thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 10.0),
                          overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 20.0),
                        ),
                        child: Slider(
                          value: height.toDouble(),
                          min: 80.0,
                          max: 220.0,
                          onChanged: (double newValue) {
                            setState(() {
                              height = newValue.round();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ReusableCard(
                  colour: kActiveCardColour,
                  cardChild: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'PESO',
                        style: kLabelTextStyle,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Text(
                            weight.toStringAsFixed(3),
                            style: kNumberTextStyle,
                          ),
                          Text(
                            'kg',
                            style: kLabelTextStyle,
                          )
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          inactiveTrackColor: Color(0xFF4C4F5E),
                          activeTrackColor: Colors.white,
                          thumbColor: Colors.black,
                          overlayColor: Color(0x29EB1555),
                          thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 10.0),
                          overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 20.0),
                        ),
                        child: Slider(
                          //divisions: 1000,
                          value: weight,
                          min: 5.00,
                          max: 140.00,
                          onChanged: (value) {
                            setState(() {
                              weight = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ReusableCard(
                  colour: kActiveCardColour,
                  cardChild: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'IDADE',
                        style: kLabelTextStyle,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Text(
                            age.toString(),
                            style: kNumberTextStyle,
                          ),
                          Text(
                            'anos',
                            style: kLabelTextStyle,
                          )
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          inactiveTrackColor: Color(0xFF4C4F5E),
                          activeTrackColor: Colors.white,
                          thumbColor: Colors.black,
                          overlayColor: Color(0x29EB1555),
                          thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 10.0),
                          overlayShape:
                          RoundSliderOverlayShape(overlayRadius: 20.0),
                        ),
                        child: Slider(
                          value: age.toDouble(),
                          min: 5.0,
                          max: 110.0,
                          onChanged: (double newValue) {
                            setState(() {
                              age = newValue.round();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: AdWidget(ad: staticAd,),
                width: staticAd.size.width.toDouble(),
                height: staticAd.size.height.toDouble(),
                alignment: Alignment.bottomCenter,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.all(5),
                child: ElevatedButton(
                  onPressed: () {
                    CalculatorBrain calc =
                    CalculatorBrain(height: height, weight: weight, selectedGender: selectedGender);
                    showInterstitialAd();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultsPage(
                          bmiResult: calc.calculateBMI(),
                          resultText: calc.getResult(),
                          interpretation: calc.getInterpretation(),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "CALCULAR",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.deepOrange,
                    padding: EdgeInsets.all(12),
                    elevation: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
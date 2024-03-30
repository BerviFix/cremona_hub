import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:cremona_hub/components/ad_helper.dart';

class AddAd extends StatefulWidget {
  @override
  AddAdState createState() => AddAdState();
}

class AddAdState extends State<AddAd> {
  //ad setup
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    // Create banner ad only if it hasn't been initialized yet
    if (_bannerAd == null) {
      _bannerAd = BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        request: AdRequest(),
        size: AdSize.largeBanner,
        listener: BannerAdListener(
          onAdLoaded: (_) {
            //if this is the first banner load set adsready true
            log('Ad loaded.');
            if (!_isBannerAdReady) {
              setState(() {
                _isBannerAdReady = true;
              });
            }
          },
          onAdFailedToLoad: (ad, err) {
            print('Failed to load a banner ad: ${err.message}');
            _isBannerAdReady = false;
            ad.dispose();
          },
        ),
      );
      _bannerAd?.load();
      super.initState();
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  //the card takes will either take editable form or view form
  Widget build(BuildContext context) {
    return _isBannerAdReady
        ? Container(
            height: 100,
            margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
            width: MediaQuery.of(context).size.width,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                // width: _bannerAd?.size.width.toDouble(),
                height: 100,
                child: AdWidget(ad: _bannerAd!),
              ),
            ),
          )
        : Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
            child: Image.asset(
              'assets/no-ads-1.jpg',
              fit: BoxFit.cover,
            ),
          );
  }
}

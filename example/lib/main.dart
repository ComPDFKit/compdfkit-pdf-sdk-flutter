// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter_example/examples.dart';
import 'package:compdfkit_flutter_example/theme/themes.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:compdfkit_flutter_example/widgets/cpdf_app_bar.dart';

import 'package:flutter/material.dart';


var androidLicenseKey = "RmQtBKZp3ZBOLrTE9iT6rx5mX25R63bWZYNFYVtXmxLJ52gsquPRZR3SC+Y/9ebuuNHte5ewi6b+RJhsLH1CC8fZ1fa9WgcgzAyUk6tkTKVQ0IlNzpIl6avn6VZZ8z739mEtExZHF/jIOeF4wi6oUcnD57UHEHLlorviCr7ezeBJG3nJuR7CbOsDGTxFPz1mAQPXPno82TsYIQOVd0YZH+FL3PsyKYaOnSpzl2vErP1ykUhKSLGqX0UjF3/aamA3hxrsXLCnH6N2G1L5jwyr4Bw+ZigoHMQglgWkyr2pxMDvpAC5ODUdCU43GHzKUy2ZmqGm4k3cQ1dexFQVg1krMGu0lH1oY17eVN2TRW5amzrVRSqpTOyx2LGvW1Ilra90nzlp2dEBHH+rU3Jo93jy94eWecFWMwgKBD5sABvhJFteiZTpP6NufkmmJm5UhS1bbWwQ3416ecpKs8D9TAlLLO+rbIocuxdoPE2dxWFYLq6zF8kJV3z7dKYtAwQKdoQiS08ryGXVZybCx2GjZp97I7zNemiorRWKQUrxpNk0vCLwL1yz7NzjlB6YQ8UxvmTkX/GU7T7Ubg9LoyZuVo4tLHLplMSlHIcA4guqZL7JbQ6/jomhcJGFpGo+X7tbrCvMTnbvjZoxJRlcNN1+9x100WEfF4A2XbJZEjcpxV9tk1rTt+jS8dkX803ij16yHI1THSycP2aKkWjgDAsAUt98KL+h4U+jgXH+NDKksS1nHNj/D5gUzVZb9YIL3msCOLra5s0djhCW/JhHu8oi6evWdC/l9/zka20p2J+S0gYBJZVV5PqpP/oz1yrxd3HL4q+XfQLspe7UnwbzsomDK6UNMOB6wL5IX/83nH3cl+UQPxeYRErTdWFnoeZzM8/GIywzMMgjtLWq6R7TnuUISCr546/OVWed0jdIirfoinBa7gxOOBksvggxxsojoM7/ibLYeGd1bpQRolFEjmon/x/uepb+Qu0eSnK+vc/PksIFmR8e9r3XfNPfa0vGVFG5iuYc+IQqltAs8+zcFcFcwRT5oyPnefdyXsoErUnnJ8WMqohz514PVUGRuOb1aq9iOWg5xUk1cnFIp61BJlh7lypQEtbVCheDOJRIFsKY4SMlzMXEGNHXasYHCtgjkF6rkxDNel8IuIrT6GXxYBIAVYmRbMlxqetnGiE7rcK2kvckRgC5qXRifiQqN5qZswrqFN0pB0MN8h8RRa4B7vone+Bm3lvO2jicERnlS08z2v/+ICk=";

var iosLicenseKey = "LGH/ygRZOohz2FAUacyeob+f7ECSRgYWU/uBlAZbmKiXyX5sIFPyE0PDvSDF0LANhZYwoPaxLm5UUKenWhPSxZ/FZDEgse0MY0FzYXihnQqPzQ8ymyCrZ2lUrQdzWWQlndPkebb0vfzLjtbk4hgkeZ1pKDSf+EY0LuOTl7joQHG+5SeQcxxog/vE3T6mA7VDT89DgnkWFz6IjQ6Vs1HG03mKms99X/wDWuXZvecLkmXp8clCp7NiUdVpRTxxb8YgzlZl8+uEHisxwtIcxUqNDFsnfTQWBouCDumTWd3IpbGVj/OHG4maHvytVdT4HzwiE8Hk1vOQTXQXDjRLHWUhlWu0lH1oY17eVN2TRW5amzrVRSqpTOyx2LGvW1Ilra90nzlp2dEBHH+rU3Jo93jy94eWecFWMwgKBD5sABvhJFteiZTpP6NufkmmJm5UhS1bbWwQ3416ecpKs8D9TAlLLO+rbIocuxdoPE2dxWFYLq6zF8kJV3z7dKYtAwQKdoQiS08ryGXVZybCx2GjZp97I7zNemiorRWKQUrxpNk0vCLwL1yz7NzjlB6YQ8UxvmTkX/GU7T7Ubg9LoyZuVo4tLHLplMSlHIcA4guqZL7JbQ6/jomhcJGFpGo+X7tbrCvMTnbvjZoxJRlcNN1+9x100WEfF4A2XbJZEjcpxV9tk1rTt+jS8dkX803ij16yHI1THSycP2aKkWjgDAsAUt98KJfMhDVdBtIWgg2xXbvUdZcI64/olAhMlJtgtzX6jWQPFJR0JOwAOG6qfCy/DtzIW3nDTvhR8ars8BMmuBeTaRq+AcpgTkjA/IdfbVsUdwpcAtNxUHMeXgadhOwL0Tk7ccq2klvygZT5+YYzzFafTOl2zhyA5SZe4rlhbamLnoweqy5yOwfo76Jhm61XyVfjihpFJdStNJxmGSTuQ06bz3SVxawQXMykJth+G0a7m9jGd8uEfMCz378qP/3oPBmSGbZCgU0nIVuB+PF1h/ZUwtC6Cc74Lj0MTrXKRLQKweHh19YpV8MjznmetDMlWvfKnRRyRbIOX2e4Vc18UHFDK2cPEDY4UoSuet/Q3cpfiqTDlQNhh5Q2SNvVvr4NBBaH0LMU/d/dbTKfUUH3ENpV7DBRNaj3hqFWtS0sj3Poue5aKzhuZBUk/NeTBm05uTlhUEcn9u37606wkgErzP4SBLUIHPNm/6aOY5UJHb8eAXN0FBniqS8FUuZdFVI5LCWbjseSGtOeUZ2j4o9zeSZzXes=";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ComPDFKit SDK for Flutter',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    final fontDir = await extractAssetFolder(context, 'extraFonts/');
    await ComPDFKit.setImportFontDir(fontDir, addSysFont: true);

    // online license auth
    // Please replace it with your ComPDFKit license
    // ComPDFKit.initialize(androidOnlineLicense: 'android license key',iosOnlineLicense: 'ios license key');

    // offline license auth
    ComPDFKit.init(Platform.isAndroid ? androidLicenseKey : iosLicenseKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CAppBar(),
        body: ExampleListView(widgets: examples(context)));
  }
}

class ExampleListView extends StatelessWidget {
  final List<Widget> widgets;

  const ExampleListView({super.key, required this.widgets});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListView.builder(
            itemCount: widgets.length,
            itemBuilder: (context, index) {
              return widgets[index];
            }));
  }
}

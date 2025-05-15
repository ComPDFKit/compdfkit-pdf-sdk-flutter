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


var androidLicenseKey = "vWG81pDfg5Ojm9ycyAHoBf6Qb/yT4YuLPM521RVvGf8yhKFjx+KH12mgD+E64Snkacdj2aqW8P3Uk9kEjk9OfgvHtozTmo+zqbVIygogMpz9RvhZO/IdEE3jhQWkISSI+N2D2XyGtu1M8o2mLpceugjCrTphVTMW1tBNIFAlynGyIVXu5+2konU4Hh9V9nJtQzpGD2Ew1VWvcklNST1e2UgTaTa+C5fkHpc3vC9PlPj3wTMxORp6BGqdj45SV3G4N0PuCG5V4B1laeQbsAAIY1SKzY1fCE7G7iJCGJ8dJoZ5n6PzHVn1BkXR6UdsI9x1fw+ckJsStMpgWHAeLX9GTmu0lH1oY17eVN2TRW5amzrVRSqpTOyx2LGvW1Ilra90nzlp2dEBHH+rU3Jo93jy94eWecFWMwgKBD5sABvhJFteiZTpP6NufkmmJm5UhS1bbWwQ3416ecpKs8D9TAlLLO+rbIocuxdoPE2dxWFYLq6zF8kJV3z7dKYtAwQKdoQiS08ryGXVZybCx2GjZp97I7zNemiorRWKQUrxpNk0vCLwL1yz7NzjlB6YQ8UxvmTkX/GU7T7Ubg9LoyZuVo4tLHLplMSlHIcA4guqZL7JbQ6/jomhcJGFpGo+X7tbrCvMTnbvjZoxJRlcNN1+9x100WEfF4A2XbJZEjcpxV9tk1rTt+jS8dkX803ij16yHI1THSycP2aKkWjgDAsAUt98KCUHLaZi4F73ifo4l7JQoj0MxqN2wuiDb2PRCz4539YtkdVIZEXZTwWHfrGGmBtk3eTjulgN6KX4N8Zl8HTm1QDd0eY4XLXdZrWhe9nc1DGvLY1gsBg7f03Pf+Ch9WtB1I5hPMBVEyy26KZtF484aCb9XagMRnF+iot0GttPzd+uPWA4icpbsc75X0fCRahxJTWAXtYCUc/pCTm54v24bIoq3Zxj1lx7tKDtad8Ou3diwfFGTMtsMs+ga7i5gUny3WSd1idswHBlZEZh4+h7L6QgFnxa20xs3LwkoQTfhr6nZgjh0SZri4haYRMpOBtGEdSntVKJv2Vka7yk0uAGQ9GincrC/EqOa0HVmqcVvf3E3S6Mb4qT4xeOVeKWTCeJpKWznHb57bcaXEe18jn7YpE2l1oio78O3ElTVCvjufcILgQ8c4Bt5yXCNSZoIQsS3ge+rhLMiBMMhVVVZQm05qf1ku8hc0JT8C2n1OAx6ouQRTvhnA9CqXO+obtoFKSODA==";

var iosLicenseKey = "6Z+bqN9RVWKMekb+VATJoknfdaJFIJil/sGapkJiTBLy6krla9+e2/hcOm2FZgaFXNOr8B+z8D4xOpr3ya3tlv1LpLZ8fwZlNJ5S1rXvyJAzJ3vr8IqMsFc15llOSWVDW7KulaM6dChhiICg+oLXSQUG4AC3U/tVxuwgcYLDfuXwM2uYUmSNSPpkXQdLNxSC9S+/UdCnYOdkJqq3BfwMeh4D/isBIe0oy1XGXMclcl+cSAHrXGevk4RU8zMfrisCnw4NdpumXfE3HgOEtyShkJ2mtX1LgmHCxr3zzQ7gSIWRuRrQRwJOekhZSAG9t2SBIi7vth9si8h8vn4wlMmx3Gu0lH1oY17eVN2TRW5amzrVRSqpTOyx2LGvW1Ilra90nzlp2dEBHH+rU3Jo93jy94eWecFWMwgKBD5sABvhJFteiZTpP6NufkmmJm5UhS1bbWwQ3416ecpKs8D9TAlLLO+rbIocuxdoPE2dxWFYLq6zF8kJV3z7dKYtAwQKdoQiS08ryGXVZybCx2GjZp97I7zNemiorRWKQUrxpNk0vCLwL1yz7NzjlB6YQ8UxvmTkX/GU7T7Ubg9LoyZuVo4tLHLplMSlHIcA4guqZL7JbQ6/jomhcJGFpGo+X7tbrCvMTnbvjZoxJRlcNN1+9x100WEfF4A2XbJZEjcpxV9tk1rTt+jS8dkX803ij16yHI1THSycP2aKkWjgDAsAUt98KCUHLaZi4F73ifo4l7JQoj2iW5vEiAxKL+Hs+L5PEV11ApZ1vdeZH2OjP2tm5Ddn1vUmrLCNlLs0O2/IIy+lJgWBx0neeYkWPlBX+cpZqBFqttUw34GKCdD7Ed5hoEK8BEdlZO66GHu+Cfr8i48R7iCpdNebl1Y7vyblOeeaHHodyIfzI2P6fYnkslsauXi2UqzcCeiRYaOnUw5xt9GzcvAfka8jMwHf9mpSHCRl1zjON4QIyuPQwC15J0slX1znUiPWN791kjTcd3M6eXNLGpxOsn1ByOPf5QfMdgOIFS9L9sd5cWpEutbA4EXL3ij99ZnAuGjOq2PAG7zfpr8bwl9X1wS07eUU9V4eJlfv33bE5rh/6wxjUk1eS3DWU8y/0zXHoYH21F/G8NWar9g6J6J3E8GryCQaQbuznJWzNZcwPF4VW9PEI6i9ZQQjHSQQQhiDdcco7ZU83kyn+9FUk7Tpn6mczkbeB5HMVSYBz9gej5bELGvHg0jiXnjI6mVpIQ==";

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

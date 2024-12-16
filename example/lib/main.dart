// Copyright © 2014-2024 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter_example/examples.dart';
import 'package:compdfkit_flutter_example/theme/themes.dart';
import 'package:compdfkit_flutter_example/widgets/cpdf_app_bar.dart';

import 'package:flutter/material.dart';


var androidLicenseKey = "c4r34cNxld6pdUSsM2EgGQ9purMEZN7JuumHbNx9w+OJ6lYqF7WRYAFV0jvA5CEEX7J1+wGrF68mo8YP3qL5b6lmS60TMw2/wJ+TPtmeKkJMRMaiQ2nF2pwSevBj2HIHbnTLfr2btYHL/TRKFbfG0SUp/tZVjUwOC91rcrlaLkThWpc13/3SOi/34uHyjQszJ6PmDeg8X+qxfNheOBX/JZofPOjKpWpAAXXKT9kgtbZKKc6VAmMPAdRth7FnJjPieXkHkvW3fX2kNcgX6cb8IBnu/7Q3C4776P6IVIQKlDItMGNJIV7IPMADRnsLMqdC9FZcF3mV0laocg8qlFuKdmu0lH1oY17eVN2TRW5amzrVRSqpTOyx2LGvW1Ilra90nzlp2dEBHH+rU3Jo93jy94eWecFWMwgKBD5sABvhJFteiZTpP6NufkmmJm5UhS1bbWwQ3416ecpKs8D9TAlLLO+rbIocuxdoPE2dxWFYLq6zF8kJV3z7dKYtAwQKdoQiS08ryGXVZybCx2GjZp97I7zNemiorRWKQUrxpNk0vCLwL1yz7NzjlB6YQ8UxvmTkX/GU7T7Ubg9LoyZuVo4tLHLplMSlHIcA4guqZL7JbQ6/jomhcJGFpGo+X7tbrCvMTnbvjZoxJRlcNN1+9x100WEfF4A2XbJZEjcpxV9tk1rTt+jS8dkX803ij16yHI1THSycP2aKkWjgDAsAUt98KL+h4U+jgXH+NDKksS1nHNjVoJYvPaW7TLcBzT0GegIgNKELjvoahi+wfYUt79velJ1uEBhEcnvnIjlShtHdqKbE/lMbb2sG0lJnFUhViYIpkjXvy5b9ucuZfz1pm7f173QY75AXVUGgMkMI0XuV2tjDFnThFHtTgDnaOzHyyOwRiOuiM74ieBmwFqkOo4SQtUrUWPDK459l8FoqAa8XlJoWZXcbU1OotvnT9I1MMGTsC2l+b6sDxoJ4wc1wj9IhAmx7tmXnQyD/0q8NOKUk9E1AtfrYSdkTjCzdEI1HZ08LcyYnRNJNARTHNh8okrNDwA4seKyLl/XIfxmIx7IaLGx0VavXDAus9AAd+knf5we5iXWY7SJO2ZrxRJgotLWE/jY7Pg8FofBwr9sBt/VEJDcb1pbHKvag2rGKlyAigV4KkFoi+kJdO9xKXMBDKAZnsA==";

var iosLicenseKey = "pK3jYP2WpjMMxnh3h6rfCYYfGmC+UBVo0gUMVTUPFJAOnn7n2KlSDYYFoROfARAO5cco1M72URpb87XQVVvV+sI/mzReM6Sbl78n89xVI/wacDVcn9lVGZH6rKg5q/f+17rHUH1JQCEilQFUxvoer4kuymdeME6Ux+CsXiD9U3GqMAwDAuvCazhwWWYdZSeQEo/KzTL1/ZbF6AdfEFP9K7Gk2q7RcuwX0WaH22At997+WnwH2EpwfXQGtUSVYO7LGMn7kCs+m+CU6hMmG0S9YRz9oTm7jAk99+y3RaJXkIETmZj5OWTIPVGjNuDKhNASTddpPc68mSFrBmizUniO1Wu0lH1oY17eVN2TRW5amzrVRSqpTOyx2LGvW1Ilra90nzlp2dEBHH+rU3Jo93jy94eWecFWMwgKBD5sABvhJFteiZTpP6NufkmmJm5UhS1bbWwQ3416ecpKs8D9TAlLLO+rbIocuxdoPE2dxWFYLq6zF8kJV3z7dKYtAwQKdoQiS08ryGXVZybCx2GjZp97I7zNemiorRWKQUrxpNk0vCLwL1yz7NzjlB6YQ8UxvmTkX/GU7T7Ubg9LoyZuVo4tLHLplMSlHIcA4guqZL7JbQ6/jomhcJGFpGo+X7tbrCvMTnbvjZoxJRlcNN1+9x100WEfF4A2XbJZEjcpxV9tk1rTt+jS8dkX803ij16yHI1THSycP2aKkWjgDAsAUt98KJfMhDVdBtIWgg2xXbvUdZdPA+MDYbxOt/kTCqmTNMCBL4i4/N1Dqxvl8Me6vei5LeecqlBZbInEmA+87xsmNJ+d5MxP+EIac9+yqaQ0YIYE4wnAzUkp/0SfANyT5mw/EcTvSxlFmdNPXMpAygK4Q1n/S3QjnpAZJCMhg6hUDQi1TPHJO1WCWdGg50xVd4e9cvnNaN633IvvL9TFBGBu4xx7FHUdlWeiIkfzaiP8Y+58lPpC7x05cs28uc/hwXiZGx2KvdF+199pSLVUIrj85m/7+SqS01Dz6t4RwV7CZ/nQ4KOAyptnYBkUNyyOx7Q7j3CUXnxUN5HL5Yhqq2FFaD/HTTVwcjun3kBQWAiUV1AWYY/lHA5ERHysKmgUkhba8MlQCnsGD2o4KGBScfS0N2kQ3Eg6AtwSRVmQZHRUOuFrRzDh6w9DqXG/2btsFdOOfQ==";

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
    // online license auth
    // Please replace it with your ComPDFKit license
    // ComPDFKit.initialize(androidOnlineLicense: 'IVTAsbJCW0X45qIy5cTEuzxZzKpYIpJe6WPY7uCPIiI=',iosOnlineLicense: 'lkw3Gr0HuD5pV1/+DVRSxp7qBlvK+Izo3mOKyAEHXz4=');

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
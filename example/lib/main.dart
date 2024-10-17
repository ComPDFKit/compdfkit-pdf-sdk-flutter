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
    if(Platform.isAndroid){
      ComPDFKit.init('m1bIAk/3mPQu+j6vJAMeauodNbxWBKE5DsdcvD+/dixxtZP2sLsLi4V9Cqj7mLP1hPTTYkfKrKTjpMqf06+f1ySt18aLuYh9IbHZpbhldGb4Vi8NG8rB/N/B6Dl4kqL80a7wlswqzKj/5OuTcbnVgOgC892udbsjcuh1/RVdujWYZn+eEgOyiWCyyOB1I7h0KkvqU+Uhjs1hI4UUOl5Zf43EZKcj7WkbI91UCGL4FpBs5QX1Gxt+9agdNGWTedmShLYyLw/50nOkO7VdvFScVoArkE7w02WT1dtzbrAePMNEzKFco58L5kCTkJKXdlLft12zv5kUhw2TZkrDuIiJWmu0lH1oY17eVN2TRW5amzrVRSqpTOyx2LGvW1Ilra90nzlp2dEBHH+rU3Jo93jy94eWecFWMwgKBD5sABvhJFteiZTpP6NufkmmJm5UhS1bbWwQ3416ecpKs8D9TAlLLO+rbIocuxdoPE2dxWFYLq6zF8kJV3z7dKYtAwQKdoQiS08ryGXVZybCx2GjZp97I7zNemiorRWKQUrxpNk0vCLwL1yz7NzjlB6YQ8UxvmTkX/GU7T7Ubg9LoyZuVo4tLHLplMSlHIcA4guqZL7JbQ6/jomhcJGFpGo+X7tbrCvMTnbvjZoxJRlcNN1+9x100WEfF4A2XbJZEjcpxV9tk1rTt+jS8dkX803ij16yHI1THSycP2aKkWjgDAsAUt98KCUHLaZi4F73ifo4l7JQoj0MxqN2wuiDb2PRCz4539YtkdVIZEXZTwWHfrGGmBtk3dx1799HZhql3JBz0M8qWu0orf8D8MSMhoXp8+4gqXbcjQenhtwoj/Djoo004nn6imYxyhOvWz1Gr+RnmewvsMekW5tRLYGyh4Wzm8iz7FfbeUBBSnACmDjQJakv7XZbEC+8aL7krtxm/FHFSIEQ16OXVquY+uWr1r5qGwfIX5PeVDJnm/N/Wr1SQL0aw1U39cth85eJcdDrrSE+Qsa+ZM5dJ3Wz5uqSZb/edA4VQTm9v11EslX6/qIaDIY9MV63ZN5xLwpFEG1t+aAFBUxaz4xBYu66dXNz1mZ12KGm03c/VbZB9RRCWzag8ple8Qp54b33fhHNpH59zJUfLY80vUJhiyZlMVDKJ5nvFgOcnq+c+5t6xDPfO1JnRjw3rWXr5Q==');
    }else{
      ComPDFKit.init('k8cRjNZmpwl8nRNmhDkGHZkScqL/8K0p3GkgsPccyRg68tYV8XQUQHqadfwPIcApm+E0+bvXcixswLpTBVXRiiV1iG7Gd3EqtnUxPiwr1osBfryaV/d7bzjfHsCKReEZ80efAnQIBjiSJkdB56EAUkotSP9Mj4283F8T6gVumAVqIvlykMKh8kotRF19DgSTRt3s9E4/ezDf8yg/BKj0/DS6gQSDvBZyCSACKoY083ejiTJ6YhumZgb7gESwCNOGbfRqv4VVX8ln/gseGdbm6xDbvgpj6w3Tm29juBz3FJn7iORQaDf+PA4afkt2W1U3yaCTI28UnHVg/CmDF+FP92u0lH1oY17eVN2TRW5amzrVRSqpTOyx2LGvW1Ilra90nzlp2dEBHH+rU3Jo93jy94eWecFWMwgKBD5sABvhJFteiZTpP6NufkmmJm5UhS1bbWwQ3416ecpKs8D9TAlLLO+rbIocuxdoPE2dxWFYLq6zF8kJV3z7dKYtAwQKdoQiS08ryGXVZybCx2GjZp97I7zNemiorRWKQUrxpNk0vCLwL1yz7NzjlB6YQ8UxvmTkX/GU7T7Ubg9LoyZuVo4tLHLplMSlHIcA4guqZL7JbQ6/jomhcJGFpGo+X7tbrCvMTnbvjZoxJRlcNN1+9x100WEfF4A2XbJZEjcpxV9tk1rTt+jS8dkX803ij16yHI1THSycP2aKkWjgDAsAUt98KCUHLaZi4F73ifo4l7JQoj2iW5vEiAxKL+Hs+L5PEV11WKVc3vOYWIu1AAWEabsmhM84JYFRJ5OEafgXqld/e33OF6y/AKkLAexGrdMfOgtVOqFZe7OZV30hvPm4E6Lj5CFzQ1nW5cOwbM0BhzyHAZcaBBJHgnC9UDxaNtMU0CAju0bJYR1DwGOYvM+JXZoZUTh+A49/TL9Ap760hiQNzceOlL4vWLTvXQ9fSDWVZnRxl3wq0mV7E+lek14llLmD1mQypPqwJiH3RTfITGPxxXIdI8xu/5FEGy6+IZn5YrWaJ1yXfMqkdgp6OZpWDHiImeGHFc9l2ZsRcUpj8kY2r6/TAZboh+ksP4pzCLqDpfkZAPJEs0FRGAnnH/mn+1/VqzzgJrdFUZwZzDkDVvwdMntbR//egB4v2zc1/BtVZjx4TFwbN27pSDkcOPuAk1nSCQ==');
    }
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
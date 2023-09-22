import 'package:flutter/material.dart';

class UbahDataScreen extends StatefulWidget {
  const UbahDataScreen({super.key});

  @override
  State<UbahDataScreen> createState() => _UbahDataScreenState();
}

class _UbahDataScreenState extends State<UbahDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ubah Data"),
      ),
      body: SingleChildScrollView(),
    );
  }
}

import 'package:flutter/material.dart';

class ForeCastBox extends StatelessWidget {
  const ForeCastBox(
      {super.key, required this.txt1, required this.txt2, required this.icon});
  final String txt1;
  final String txt2;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        width: 100,
        child: Column(
          children: [
            Text(
              txt1,
              maxLines: 1,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              icon,
              size: 20,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              txt2,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class AdditionalInfoBox extends StatelessWidget {
  const AdditionalInfoBox(
      {super.key, required this.icon, required this.txt1, required this.txt2});

  final IconData icon;
  final String txt1;
  final String txt2;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Icon(
          icon,
          size: 30,
        ),
        const SizedBox(
          height: 6,
        ),
        Text(
          txt1,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 6,
        ),
        Text(
          txt2,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ]),
    );
  }
}

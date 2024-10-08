import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartScreen extends StatelessWidget {
  final Map<String, int> results;

  ChartScreen({required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Results Chart")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40, // Reserve space for left titles
                  getTitlesWidget: (value, meta) {
                    return Text(value.toInt().toString()); // Display vote count
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40, // Reserve space for bottom titles
                  getTitlesWidget: (value, meta) {
                    // Get the candidate name from the results
                    String candidateName = results.keys.elementAt(value.toInt());
                    // Return the first five letters of the candidate's name
                    return Text(candidateName.substring(0, 5));
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: true),
            barGroups: results.entries.map((entry) {
              return BarChartGroupData(
                x: results.keys.toList().indexOf(entry.key),
                barRods: [
                  BarChartRodData(
                    toY: entry.value.toDouble(),
                    color: Colors.blue,
                    width: 20, // Adjust the width as needed
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

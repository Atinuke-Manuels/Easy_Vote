import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_text_styles.dart';
import '../../../themes/theme_provider.dart';

class WebChartScreen extends StatelessWidget {
  final Map<String, int> results;

  WebChartScreen({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(title: Text("Results Chart",style: AppTextStyles.headingStyle(context),), centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
        elevation: 0,
        leading: TextButton(onPressed: (){Navigator.pop(context);}, child: Text("Back", style: AppTextStyles.bodyTextStyle(context),)),
        leadingWidth: 80,
      ),
      body: Container(
        padding: EdgeInsets.only(top:40, right: MediaQuery.of(context).size.width* 0.2, left: MediaQuery.of(context).size.width* 0.2),
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: Provider.of<ThemeProvider>(context).backgroundGradient,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BarChart(
              BarChartData(
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40, // Reserve space for left titles
                      getTitlesWidget: (value, meta) {
                        // Display all integer values for the y-axis
                        return Text(value.toInt().toString(), style: AppTextStyles.bodyTextStyle(context));
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
                        return Text(
                          candidateName.length > 5 ? candidateName.substring(0, 5) : candidateName,
                          style: AppTextStyles.bodyTextStyle(context),
                        );
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
                        color: Colors.yellow.shade800,
                        width: 20, // Adjust the width as needed
                      ),
                    ],
                  );
                }).toList(),
                gridData: FlGridData(show: true),
              ),
            ),
          ),
        ),

      ),
    );
  }
}

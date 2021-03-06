import 'package:expense_planner/models/transactions.dart';
import 'package:expense_planner/widgets/chart_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transactions> recentTransactioms;

  Chart(this.recentTransactioms);

  List<Map<String, Object>> get groupedTransactionsValues {
    return List
        .generate(
      7,
          (index) {
        final weekDay = DateTime.now().subtract(
          Duration(days: index),
        );
        var totalSum = 0.0;
        for (var i = 0; i < recentTransactioms.length; ++i) {
          if (recentTransactioms[i].date.day == weekDay.day &&
              recentTransactioms[i].date.month == weekDay.month &&
              recentTransactioms[i].date.year == weekDay.year) {
            totalSum += recentTransactioms[i].amount;
          }
        }

        return {
          'day': DateFormat.E().format(weekDay).substring(0, 1),
          'amount': totalSum,
        };
      },
    )
        .reversed
        .toList();
  }

  double get totalSpending {
    return groupedTransactionsValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionsValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                data['day'],
                data['amount'],
                totalSpending == 0.0 ? 0.0 : (data['amount'] as double) /
                    totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

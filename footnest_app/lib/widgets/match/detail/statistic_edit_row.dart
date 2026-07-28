import 'package:flutter/material.dart';

class StatisticEditRow extends StatelessWidget {

  final String label;

  final dynamic homeValue;
  final dynamic awayValue;

  final bool editing;

  final TextEditingController homeController;
  final TextEditingController awayController;

  const StatisticEditRow({
    super.key,
    required this.label,
    required this.homeValue,
    required this.awayValue,
    required this.editing,
    required this.homeController,
    required this.awayController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [

          Expanded(
            child: editing
                ? _field(homeController)
                : _value(homeValue),
          ),

          SizedBox(
            width:120,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),

          Expanded(
            child: editing
                ? _field(awayController)
                : _value(awayValue),
          ),

        ],
      ),
    );

  }

  Widget _field(TextEditingController controller) {
    return SizedBox(
      width:50,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(
          decimal:true,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _value(dynamic value) {
    return Text(
      value == null
          ? "-"
          : value.toString(),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }

}
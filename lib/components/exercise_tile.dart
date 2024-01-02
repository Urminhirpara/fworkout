import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;
  void Function(bool?)? onCheckBoxChanged;

  ExerciseTile(
      {super.key,
      required this.exerciseName,
      required this.weight,
      required this.reps,
      required this.sets,
      required this.isCompleted,
      required this.onCheckBoxChanged}) {
    // TODO: implement ExerciseTile
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: ListTile(
        title: Text(
          exerciseName,
        ),
        subtitle: Row(
          children: [
            Chip(
              label: Text(
                "${weight} KG",
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Chip(
              label: Text(
                "${reps} Reps",
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Chip(
              label: Text(
                "${sets} Sets",
              ),
            ),
          ],
        ),
        trailing: Checkbox(
          value: isCompleted,
          onChanged: (value) => onCheckBoxChanged!(value),
        ),
      ),
    );
  }
}

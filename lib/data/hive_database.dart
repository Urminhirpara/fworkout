import 'package:hive/hive.dart';
import 'package:workout/datetime/date_time.dart';
import 'package:workout/models/exercise.dart';
import 'package:workout/models/workout.dart';

class HiveDatabase {
  // reference our hive box
  final _myBox = Hive.box("workout_database2");

  // check if there is already data stored, if not, record the start date
  bool previousDataExists() {
    if (_myBox.isEmpty) {
      print("previous data does NOt Exist");
      _myBox.put("START_DATE", todaysDateYYYYMMDD());
      return false;
    } else {
      print("previous data does Exist");
      return true;
    }
  }

// return start date as yyyymmdd
  String getStartDate() {
    return _myBox.get("START_DATE");
  }

// write data
  void saveToDatabase(List<Workout> workouts) {
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);
    if (exerciseCompleted(workouts)) {
      _myBox.put("COMPLETION_STATUS_" + todaysDateYYYYMMDD(), 1);
    } else {
      _myBox.put("COMPLETION_STATUS_" + todaysDateYYYYMMDD(), 0);
    }
    _myBox.put("WORKOUTS", workoutList);
    _myBox.put("EXERCISES", exerciseList);
  }

  // read data, and return a list of workouts
  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];
    List<String> workoutNames = _myBox.get("WORKOUTS");
    final exerciseDetails = _myBox.get("EXERCISES");
    for (int i = 0; i < workoutNames.length; i++) {
      List<Exercise> exerciseInEachWorkout = [];
      for (int j = 0; j < exerciseDetails[i].length; j++) {
        exerciseInEachWorkout.add(Exercise(
          name: exerciseDetails[i][j][0],
          weight: exerciseDetails[i][j][1],
          reps: exerciseDetails[i][j][2],
          sets: exerciseDetails[i][j][3],
          isCompleted: exerciseDetails[i][j][4] == "true" ? true : false,
        ));
      }
      Workout workout =
          Workout(name: workoutNames[i], exercises: exerciseInEachWorkout);
      mySavedWorkouts.add(workout);
    }

    return mySavedWorkouts;
  }

// check if andy exercise
  bool exerciseCompleted(List<Workout> workouts) {
    for (var workout in workouts) {
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

// return completion status of given date yyyymmdd
  int getCompletedStatus(String yyyymmdd) {
    int completionSatus = _myBox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    return completionSatus;
  }
}

// converts workout objects into a list
List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [];

  for (int i = 0; i < workouts.length; i++) {
    workoutList.add(
      workouts[i].name,
    );
  }

  return workoutList;
}

// converts the exercises in a workout objects into a list of strings
List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [];

  for (int i = 0; i < workouts.length; i++) {
    List<Exercise> exercisesInWorkout = workouts[i].exercises;
    List<List<String>> individualWorkout = [];
    for (int j = 0; j < exercisesInWorkout.length; j++) {
      List<String> individualExercise = [];
      individualExercise.addAll(
        [
          exercisesInWorkout[j].name,
          exercisesInWorkout[j].weight,
          exercisesInWorkout[j].reps,
          exercisesInWorkout[j].sets,
          exercisesInWorkout[j].isCompleted.toString(),
        ],
      );
      individualWorkout.add(individualExercise);
    }
  }
  return exerciseList;
}

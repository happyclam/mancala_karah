import 'dart:collection';
import "./const.dart";
import "./player.dart";

void main() {
  // final List board = [0,1,1,1,1,1,1,0,1,1,1,1,1,1];
  final List board = [0,2,2,2,2,2,2,0,2,2,2,2,2,2];  
  List result =  List<int>.filled(14, 0, growable: false);
  
  Player first = new Player(FIRST);
  Player second = new Player(SECOND);
  print(board);
  Stopwatch watch = new Stopwatch();
  watch.start();
  // result = first.think(board, second, 50, FIRST_WIN, true);
  // result = second.think(board, first, 50, SECOND_WIN, true);
  for (var i = 1; i < 50; i++){
    result = first.think(board, second, i, FIRST_WIN, true);
    // result = second.think(board, first, i, SECOND_WIN, true);
    print("=== result = ${result[0]}, ${result[1]}, i = ${i}");
    if (result[0] == FIRST_WIN || result[0] == SECOND_WIN){
      break;
    }
  }
  print(watch.elapsedMilliseconds);
  print(result);

}

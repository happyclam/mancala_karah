import "./const.dart";

class Player{
  static final Map<int, Map> conv ={
    FIRST:{1: 13, 2: 12, 3: 11, 4: 10, 5: 9, 6: 8},
    SECOND:{8: 6, 9: 5, 10: 4, 11: 3, 12: 2, 13: 1}
  };
  static final Map<int, List> territory = {
    FIRST:[1, 2, 3, 4, 5, 6],
    SECOND:[8, 9, 10, 11, 12, 13]
  };
  int turn = 0;
  int depth = 0;
  Player(int turn, {int depth = 3}){
    this.turn = turn;
    this.depth = depth;
  }
  List think(List board, Player oppo, int limit, int pre_value, bool pre_turn){
    List result =  List<int>.filled(2, 0, growable: false);
    int moved = 0;
    int score = 0;
    int ret = 0;
    int lastscore = (this.turn == FIRST) ? SECOND_WIN : FIRST_WIN;
    int lastposi = -1;
    var goal = (this.turn == FIRST) ? FIRST_GOAL : DENTS;
    var start = (this.turn == FIRST) ? FIRST_START : SECOND_START;

    List temp = [0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    for (var i = start; i < goal; i++){
      temp = List.from(board);
      if (temp[i] == 0) continue;
      moved = karahaMove(temp, i, this.turn);
      ret = gameEnd(temp);
      if (ret == ONGAME && limit > 0){
        if (moved == FIRST_GOAL || moved == SECOND_GOAL){
          result = this.think(temp, oppo, limit - 1, lastscore, false);
        } else {
          result = oppo.think(temp, this, limit - 1, lastscore, true);
        }
        score = result[0];
      } else {
        score = evaluate(temp);
        lastscore = score;
        lastposi = i;
        break;
      }
      if ((score >= lastscore && this.turn == FIRST) || (score <= lastscore && this.turn == SECOND)){
        lastscore = score;
        lastposi = i;
      }
      if (pre_turn == true && ((pre_value < score && this.turn == FIRST) || (pre_value > score && this.turn == SECOND))) {
        break;
      }
    }
    result[0] = lastscore;
    result[1] = lastposi;
    return result;
  }
  int evaluate(List board){
    int first = 0;
    int second = 0;
    int f_temp = board.getRange(FIRST_START, FIRST_GOAL).reduce((v, next) => v + next);
    int s_temp = board.getRange(SECOND_START, DENTS).reduce((v, next) => v + next);
    bool gameover = false;

    first = board[FIRST_GOAL];
    second = board[SECOND_GOAL];
    if (f_temp == 0){
      second += s_temp;
      gameover = true;
    } else if (s_temp == 0){
      first += f_temp;
      gameover = true;
    }

    if ((first > second) && gameover){
      return FIRST_WIN;
    } else if ((second > first) && gameover){
      return SECOND_WIN;
    } else {
      return (first - second);
    }
  }
  int gameEnd(List board){
    int f_temp = board.getRange(FIRST_START, FIRST_GOAL).reduce((v, next) => v + next);
    int s_temp = board.getRange(SECOND_START, DENTS).reduce((v, next) => v + next);
    if (f_temp == 0){
      return FIRST;
    } else if (s_temp == 0){
      return SECOND;
    } else {
      return ONGAME;
    }
  }
  int oneMove(List list, int index) {
    var pebbles = list[index];
    list[index] = 0;
    var idx = index + 1;
    for (var i = 0; i < pebbles; i++){
      if (idx >= DENTS) idx = 0;
      list[idx] += 1;
      idx += 1;
    }
    return (idx - 1);
  }
  int karahaMove(List list, int index, int turn) {
    var pebbles = list[index];
    int stop;
    int cnt = 0;
    list[index] = 0;
    var idx = index + 1;
    while (cnt < pebbles){
      if (idx >= DENTS) idx = 0;
      if ((turn == FIRST) && (idx == SECOND_GOAL)){
        idx++;
        continue;
      } else if ((turn == SECOND) && (idx == FIRST_GOAL)){
        idx++;
        continue;
      }
      list[idx] += 1;
      idx += 1;
      cnt++;
    }
    stop = (idx - 1);
    if (Player.territory[turn]?.contains(stop) == true && list[stop] == 1 && list[Player.conv[turn]?[stop]] != 0){
      if (turn == FIRST){
        list[FIRST_GOAL] += list[stop];
        list[stop] = 0;
        list[FIRST_GOAL] += list[Player.conv[turn]?[stop]];
        list[Player.conv[turn]?[stop]] = 0;
      } else if (turn == SECOND){
        list[SECOND_GOAL] += list[stop];
        list[stop] = 0;
        list[SECOND_GOAL] += list[Player.conv[turn]?[stop]];
        list[Player.conv[turn]?[stop]] = 0;
      } else {
        print("=============== Error =============================");
      }
    }
    return stop;
  }

}

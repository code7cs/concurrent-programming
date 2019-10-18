monitor TWS { // E = W < S

  int state = 1;
  coondition first, second, third;

  first() {
    while(state!= 1) {
      first.wait();
    }
    state = 2;
    second.signal();
  }

  second() {
    while(state != 2) {
      second.wait();
    }
    state = 3;
    third.signal();
  }

  third() {
    while(state != 3) {
      third.wait();
    }
    state = 1;
    first.signal();
  }
}

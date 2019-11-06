monitor MyBarrier {
  final static int N = 3;
  int counter = 0;
  condition barrier;

  synchronize() {
    if (counter <= N) {
      counter++;
      while(counter < N) {
        barrier.wait();
      }
      // counter = 0;
      barrier.signal();
    }
  }
}

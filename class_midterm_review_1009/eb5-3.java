Semaphore[] permToBoard = {new Semaphore(0); new Semaphore(0);} // 允许上船

Semaphore permToSetSail = new Semaphore(0);   // 允许出发

Semaphore[] permToGetOff = {new Semaphore(0);new Semaphore(0);} // 允许下船

Semaphore permToReboard = new Semaphore(0); // 允许重新上船

thread Passenger[i]: {

  permToBoard[i].acquire();

  permToSetSail.release();

  // intransit

  permToGetOff[1 - i].acquire();
  permToReboard.release();
}

thread Ferry: {
  int i  = 0;
  while(true) {
    repeat(n) {
      permToBoard[i].release();
    }
    repeat(n) {
      permToSetSail.acquire();
    }
    
    // intransit

    i = 1 - i;

    repeat(n) {
      permToGetOff[i].release();
    }

    repeat(n) {
      permToReboard.acquire();
    }
  }
}

/**
 *     o
 *     |
 *    /\
 * ---------
 *    0    |
 */

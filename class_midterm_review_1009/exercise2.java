Semaphore mutex = new Semaphore(1);
Semaphore button = new Semaphore(2);

thread client: {

  button.acquire();
  // use dispenser
  button.release();

}

thread employee: {
  mutex.acquire();
  button.acquire();
  button.acquire();
  // fill the dispenser
  button.release();
  button.release();
  mutex.release();
}
























// Semaphore mutex = new Semaphore(1);
//
// Semaphore use[] = {new Semaphore(1); new Semaphore(1)};
//
// Semaphore perm_to_fill = new Semaphore(0);
// Semaphore done_fill = new Semaphore(0);
//
//
// // boolean isEmpty = true;
// int volume = 0;
//
// thread Client: {
//   mutex.acquire();
//   use[i].acquire();
//   use[1-i].acquire();
//   mutex.release();
//
//   perm_to_fill.release();
// 	// wait for Employee to fill dispenser
// 	done_fill.acquire();
//
//   use[i].release();
//   use[1-i].release();
// }
//
// thread Employee: {
//   while(true) {
//     perm_to_fill.acquire();
//     // refill the dispenser
//     done_fill.release();
//   }
// }

global int numReaders;
global Semaphore resource = new Semaphore (1);
global Semaphore readCountAccess = new Semaphore (1);
global Semaphore serviceQueue = new Semaphore (1);

Writer () {
  serviceQueue.acquire ();
  resource.acquire ();
  serviceQueue.release ();

  writeResource ();

  resource.release ();
}

Reader () {
  serviceQueue.acquire ();
  readCountAccess.acquire ();
  readCount ++;
  if (readCount == 1) {
    resource.acquire ();
  }
  readCountAccess.release ();
  serviceQueue.release ();

  readResource ();

  readCountAccess.acquire ();
  readCount --;
  if (readCount == 0) {
    resource.release ();
  }
  readCountAccess.release ();
}

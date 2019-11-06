// it's hydra file

int N = 10;
global int [] buffer = new int[N];
global Semaphore produce = new Semaphore(N);
global Semaphore consume = new Semaphore (0);
global int start = 0;
global int end = 0;
int counter = 0;

void consume(int i) { }

int produce() { return counter ++; }

global Semaphore mutexP = new Semaphore (1);
global Semaphore mutexC = new Semaphore (1);

Consumer(int id) {
  while (true) {
    consume.acquire ();
    mutexC.acquire ();
    consume(buffer[end]);
    print(id+" consumed product " + buffer[end] + " at " + end);
    end = (end +1) % N;
    mutexC.release ();
    produce.release ();
  }
}

Producer(int id) {
  while (true) {
    produce.acquire ();
    mutexP.acquire ();
    buffer[start] = produce ();
    print(id+" add product " + buffer[start]+ " at " + start);
    start = (start +1) % N;
    mutexP.release ();
    consume.release ();
  }
}

for (i=0; i <5; i++) {
  int id = i;
  thread Producer(id);
  thread Consumer(id);
}

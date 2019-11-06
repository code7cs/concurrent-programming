public class BarrierExample {
  public static class Barrier {
    public static void main(String[] args) {
      Barrier b = new Barrier();
      Thread t1 = new Thread(new p("a","1", b));


      t1.start();
      t1.join();
    }

  }

  public static class p implements Runnable {

  }
}

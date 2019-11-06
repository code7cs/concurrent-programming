import java.util.Random;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class Pizza {

    public static class PizzaShop {
        private final Lock lock;
        private final Condition largeAvail;
        private final Condition smallAvail;

        private int large, small;

        PizzaShop() {
            small = 0;
            large = 0;
            lock = new ReentrantLock();
            largeAvail = lock.newCondition();
            smallAvail = lock.newCondition();
        }

        public void buyLargePizza() {
            lock.lock();
            try {
                while (large == 0 && small < 2) {
                    System.out.println(Thread.currentThread().getName() + "-> buyLargePizza -> waiting");
                    System.out.println("State: large " + large + ", small " + small);
                    largeAvail.await();
                }
                System.out.println(Thread.currentThread().getName() + "-> buyLargePizza -> buying");
                System.out.println("State: large " + large + ", small " + small);
                if (large > 0) {
                    large--;
                } else {
                    small = small - 2;
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
            } finally {
                lock.unlock();
            }
        }

        public void buySmallPizza() {
            lock.lock();
            try {
                while (small == 0) {
                    System.out.println(Thread.currentThread().getName() + "-> buySmallPizza -> waiting");
                    System.out.println("State: large " + large + ", small " + small);
                    smallAvail.await();
                }
                System.out.println(Thread.currentThread().getName() + "-> buySmallPizza -> buying");
                System.out.println("State: large " + large + ", small " + small);
                small--;
            } catch (InterruptedException e) {
                e.printStackTrace();
            } finally {
                lock.unlock();
            }
        }

        public void bakeLargePizza() {
            lock.lock();
            try {
                large++;
                largeAvail.signal();
            } finally {
                lock.unlock();
            }
        }

        public void bakeSmallPizza() {
            lock.lock();
            try {
                small++;
                smallAvail.signal();
                largeAvail.signal();
            } finally {
                lock.unlock();
            }
        }
    }

    public static class Agent implements Runnable {
        private int type;
        private PizzaShop ps;

        Agent(int type, PizzaShop ps) {
            this.type = type;
            this.ps = ps;
        }

        public void run() {
            try {
                Thread.sleep(new Random().nextInt(1500));
            } catch (InterruptedException e) {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
            switch (type) {
                case 0:
                    System.out.println(Thread.currentThread().getName() + "-> buyLargePizza");
                    ps.buyLargePizza();
                    break;
                case 1:
                    System.out.println(Thread.currentThread().getName() + "-> buySmallPizza");
                    ps.buySmallPizza();
                    break;
                case 2:
                    System.out.println(Thread.currentThread().getName() + "-> bakeLargePizza");
                    ps.bakeLargePizza();
                    break;
                default:
                    System.out.println(Thread.currentThread().getName() + "-> bakeSmallPizza");
                    ps.bakeSmallPizza();
                    break;
            }
        }
    }

    public static void main(String[] args) {
        PizzaShop ps = new PizzaShop();
        final int N = 1000;
        Random r = new Random();
        // 0 -> buyLargePizza
        // 1 -> buySmallPizza
        // 2 -> bakeLargePizza
        // 3 -> bakeSmallPizza

        for (int i = 0; i < N; i++) {
            new Thread(new Agent(r.nextInt(4), ps)).start();
        }

    }
}

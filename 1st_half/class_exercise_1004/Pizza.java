package basics;

import java.util.Random;

public class Pizza {

	public static class PizzaShop {


		public void buyLargePizza() {
			
		}


		public void buySmallPizza() {

		}

		public void bakeLargePizza() {

		}

		public void bakeSmallPizza() {
		}

	}

	public static class Agent implements Runnable {
		private int type;
		private PizzaShop ps;

		Agent(int type, PizzaShop ps) {
			this.type=type;
			this.ps=ps;
		}

		public void run() {
			try {
				Thread.sleep(new Random().nextInt(1500));
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			switch (type) {
			case 0 :
				System.out.println(Thread.currentThread().getName()+"-> buyLargePizza");
				ps.buyLargePizza();
				break;
			case 1:
				System.out.println(Thread.currentThread().getName()+"-> buySmallPizza");
				ps.buySmallPizza();
				break;
			case 2 :
				System.out.println(Thread.currentThread().getName()+"-> bakeLargePizza");
				ps.bakeLargePizza();
				break;
			default:
				System.out.println(Thread.currentThread().getName()+"-> bakeSmallPizza");
				ps.bakeSmallPizza();
				break;
			}
		}
	}

		public static void main(String[] args) {
			PizzaShop ps = new PizzaShop();
			final int N=1000;
			Random r = new Random();
			// 0 -> buyLargePizza
			// 1 -> buySmallPizza
			// 2 -> bakeLargePizza
			// 3 -> bakeSmallPizza


			for (int i=0; i<N; i++) {
				new Thread(new Agent(r.nextInt(4),ps)).start();
			}

		}
}

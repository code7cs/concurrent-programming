monitor Pizzeria {
  // E = W  < S  (signal and continue)

  int small, large;
  condition smallAvail, largeAvail;

  purchaseLargePizza() {
    while (large == 0 && small < 2) {
      largeAvail.wait();
    }
    if (large > 0) {
      large--;
    } else {
      small = small - 2;
    }
  }

  purchaseSmallPizza() {
    while (small == 0) {
      smallAvail.wait();
    }
    small--;
  }

  bakeSmallPizza() {
    small++;
    smallAvail.signal();
    largeAvail.signal();
  }

  bakeLargePizza() {
    large++;
    largeAvail.signal();
  }
}

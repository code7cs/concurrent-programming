// Show an execution trace of the following program in which the ﬁnal value of n is 4.


global int n = 3;

thread P: {
  int local = n;
  n = local + 1;
}

thread Q: {
  int local;
  repeat (2) {
    local = n;
    n = local + 1;
  }
}

/**
 * my answer:
 * (IP_P, IP_Q, local_P, local_Q, n)
 *
 * (P7, Q12, NULL, NULL, 3)
 * (P8, Q12, 3, NULL, 3)
 * excute Q
 * (P8, Q14, 3, NULL, 3)
 * (P8, Q15, 3, 3, 3)
 * (P8, Q14, 3, 3, 4)
 * (P8, Q15, 3, 4, 4)
 * (P8, -, 3, 4, 5)
 * (-, -, 3, 4, 4)
 */

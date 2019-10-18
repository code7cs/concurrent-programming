

monitor PC {
	Object buffer;
	condition empty, full;

	void produce(Object o) {

		if (buffer != null) {
			empty.wait();
		}
		buffer = o;
		full.signal();
	}

	Object consume() {

		if (buffer == null) {
			full.wait();
			}
		Object temp = buffer;
		buffer = null;
		empty.signal();
		return temp;
	}
}

monitor RW {
	int readers = 0;
	int writers = 0;

	condition okToRead, okToWrite;

	void start_read() {
		if (writers !=  0 || !okToWrite.empty())) {
			okToRead.wait();
		}
		readers++;
		okToRead.signal();
	}

	void stop_read() {
		readers--;
		if (readers == 0){
			okToWrite.signal();
		}
	}

	void start_write() {
		if (writers != 0 || readers != 0){
			okToWrite.wait();
		}
		writers++;
	}

	void stop_write() {
		writers--;
		if (okToRead.empty()) {
			okToWrite.signal();
		} else {
			okToRead.signal();
		}
	}

}

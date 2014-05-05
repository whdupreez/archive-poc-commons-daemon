package com.willydupreez.poc.daemon;

public class DaemonLauncher {

	private static Object lock;
	private static boolean run;

    public static void start(String[] args) throws Exception  {
    	run = true;
    	lock = new Object();
    	new Thread(new Runnable() {

			@Override
			public void run() {
				synchronized (lock) {
					while (run) {
			            try {
			                lock.wait(1000);
			            } catch (InterruptedException e) {
			            }
			            System.out.println("running");
			        }
				}
			}
		}).start();
    }

    public static void stop(String[] args) throws Exception {
        System.out.println("stopping. Run is: " + run);
        synchronized (lock) {
        	run = false;
        	lock.notify();
		}
    }

    public static void main(String[] args) throws Exception {
        String mode = args[0];
        switch (mode) {
            case "start":
                start(args);
                break;
            case "stop":
                stop(args);
                break;
        }
    }

	public void init(String[] args) throws Exception {
		// Here open configuration files, create a trace file, create ServerSockets, Threads
		System.out.println("init");
	}

	public void start() throws Exception {
		// Start the Thread, accept incoming connections
		System.out.println("start");
	}

	public void stop() throws Exception {
		// Inform the Thread to terminate the run(), close the ServerSockets
		System.out.println("stop");
	}

	public void destroy() {
		// Destroy any object created in init()
		System.out.println("destroy");
	}

}

package com.willydupreez.poc.daemon;

public class DaemonLauncher {

	private static DaemonLauncher launcher;

	public static void main(String[] args) throws Exception {
		if (launcher == null) {
			System.out.println("Creating launcher");
			launcher = new DaemonLauncher();
		}
		System.out.println(launcher);
//		System.out.println("Num args: " + args.length);
//		System.out.println(args);
//		for (String string : args) {
//			System.out.println(string);
//		}
		Thread.sleep(20000);
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

class MonitorService : Service() {

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

        startForeground(1, createNotification())

        Thread {
            while (true) {
                checkApps()
                Thread.sleep(10000)
            }
        }.start()

        return START_STICKY
    }

    private fun checkApps() {
        Log.d("SERVICE", "Checking apps...")
    }
}
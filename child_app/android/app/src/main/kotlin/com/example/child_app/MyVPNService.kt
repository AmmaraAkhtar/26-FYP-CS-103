package com.example.childmonitor

import android.net.VpnService
import android.os.ParcelFileDescriptor
import java.io.FileInputStream
import java.io.FileOutputStream

class MyVpnService : VpnService() {

    private var vpnInterface: ParcelFileDescriptor? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        startVpn()
        return START_STICKY
    }

    private fun startVpn() {
        val builder = Builder()
        builder.addAddress("10.0.0.2", 24)      // VPN IP on device
        builder.addRoute("0.0.0.0", 0)          // Route all traffic
        vpnInterface = builder.setSession("ChildMonitorVPN").establish()

        // Traffic reading thread
        Thread {
            val inputStream = FileInputStream(vpnInterface?.fileDescriptor)
            val outputStream = FileOutputStream(vpnInterface?.fileDescriptor)
            val packet = ByteArray(32767)

            while (true) {
                val length = inputStream.read(packet)
                if (length > 0) {
                    // TODO: Parse packet & extract URL
                    val url = parsePacket(packet, length)
                    sendToBackend(url)
                    outputStream.write(packet, 0, length) // Forward traffic
                }
            }
        }.start()
    }

    private fun parsePacket(packet: ByteArray, length: Int): String {
        // Simplest version: Extract HTTP Host header
        return "dummy_url"
    }

    private fun sendToBackend(url: String) {
        // Send URL to Flutter via MethodChannel OR directly to server
    }

    override fun onDestroy() {
        vpnInterface?.close()
        super.onDestroy()
    }
}
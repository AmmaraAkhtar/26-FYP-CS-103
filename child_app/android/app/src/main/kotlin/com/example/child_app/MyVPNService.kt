package com.example.childmonitor

import android.content.Intent
import android.net.VpnService
import android.os.ParcelFileDescriptor
import java.io.FileInputStream
import java.io.FileOutputStream
import java.net.HttpURLConnection
import java.net.URL
import io.flutter.plugin.common.MethodChannel

class MyVpnService : VpnService() {

    companion object {
        var channel: MethodChannel? = null // Flutter side set karegi
    }

    private var vpnInterface: ParcelFileDescriptor? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        startVpn()
        return START_STICKY
    }

    private fun startVpn() {
        val builder = Builder()
        builder.addAddress("10.0.0.2", 24)
        builder.addRoute("0.0.0.0", 0)
        vpnInterface = builder.setSession("ChildMonitorVPN").establish()

        Thread {
            val inputStream = FileInputStream(vpnInterface?.fileDescriptor)
            val outputStream = FileOutputStream(vpnInterface?.fileDescriptor)
            val packet = ByteArray(32767)

            while (true) {
                val length = inputStream.read(packet)
                if (length > 0) {
                    val url = parsePacket(packet, length)
                    if (url.isNotEmpty()) {
                        sendToFlutter(url)
                        // Optional: Native backend call
                        sendToBackend(url)
                    }
                    outputStream.write(packet, 0, length) // Forward traffic
                }
            }
        }.start()
    }

    // HTTP URL & HTTPS domain parsing
    private fun parsePacket(packet: ByteArray, length: Int): String {
        val data = String(packet, 0, length)

        // HTTP request
        if (data.contains("GET") || data.contains("POST")) {
            val lines = data.split("\r\n")
            var host = ""
            var path = ""
            for (line in lines) {
                if (line.startsWith("Host:")) host = line.replace("Host:", "").trim()
                if (line.startsWith("GET") || line.startsWith("POST")) path = line.split(" ")[1]
            }
            if (host.isNotEmpty() && path.isNotEmpty()) return "http://$host$path"
        }

        // HTTPS domain detection (TLS SNI)
        if (data.contains("Client Hello")) {
            val hostMatch = Regex("(?<=\\x00)[a-zA-Z0-9.-]+(?=\\x00)").find(data)
            if (hostMatch != null) return hostMatch.value
        }

        return ""
    }

    // Send URL to Flutter frontend
    private fun sendToFlutter(url: String) {
        channel?.invokeMethod("onUrlDetected", url)
    }

    

    override fun onDestroy() {
        vpnInterface?.close()
        super.onDestroy()
    }
}
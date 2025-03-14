package com.example.marimo_client

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.marimo_client/bluetooth"
    private lateinit var bluetoothHelper: BluetoothHelper

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        bluetoothHelper = BluetoothHelper(this)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            handleMethodCall(call, result)
        }
    }

    private fun handleMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "connectBluetooth" -> {
                if (bluetoothHelper.checkAndRequestBluetoothPermission()) {
                    result.success(bluetoothHelper.enableBluetooth())
                } else {
                    result.error("BLUETOOTH_PERMISSION_DENIED", "Bluetooth permission is required", null)
                }
            }
            "getPairedDevices" -> {
                result.success(bluetoothHelper.getPairedDevices())
            }
            "getGalaxyBudsMacAddress" -> { // ✅ Galaxy Buds+ MAC 주소 요청 추가
                val macAddress = bluetoothHelper.getGalaxyBudsMacAddress()
                if (macAddress != null) {
                    result.success(macAddress)
                } else {
                    result.error("GALAXY_BUDS_NOT_FOUND", "Galaxy Buds+ not found", null)
                }
            }
            "connectToDevice" -> {
                val macAddress: String = call.arguments as String
                if (bluetoothHelper.connectToDevice(macAddress)) {
                    result.success("Connected to Device: $macAddress")
                } else {
                    result.error("CONNECTION_FAILED", "Failed to connect to $macAddress", null)
                }
            }
            else -> result.notImplemented()
        }
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == BluetoothHelper.REQUEST_BLUETOOTH_PICKER) {
            bluetoothHelper.handleBluetoothDeviceSelection(resultCode, data)
        }
    }
}

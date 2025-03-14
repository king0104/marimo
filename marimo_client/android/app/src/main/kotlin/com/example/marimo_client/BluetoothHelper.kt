package com.example.marimo_client

import android.Manifest
import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothSocket
import android.content.Intent
import android.content.pm.PackageManager
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.MethodChannel
import java.io.IOException
import java.util.*

class BluetoothHelper(private val activity: Activity) {
    companion object {
        const val REQUEST_ENABLE_BT = 1
        const val REQUEST_BLUETOOTH_PERMISSION = 2
        const val REQUEST_BLUETOOTH_PICKER = 3
    }

    private var bluetoothSocket: BluetoothSocket? = null
    private val bluetoothAdapter: BluetoothAdapter? = BluetoothAdapter.getDefaultAdapter()
    private var pendingResult: MethodChannel.Result? = null

    // ✅ 블루투스 권한 확인 및 요청
    fun checkAndRequestBluetoothPermission(): Boolean {
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
            if (ContextCompat.checkSelfPermission(activity, Manifest.permission.BLUETOOTH_CONNECT)
                != PackageManager.PERMISSION_GRANTED
            ) {
                ActivityCompat.requestPermissions(
                    activity, arrayOf(Manifest.permission.BLUETOOTH_CONNECT), REQUEST_BLUETOOTH_PERMISSION
                )
                return false
            }
        }
        return true
    }

    // ✅ 블루투스 활성화 요청
    fun enableBluetooth(): Boolean {
        if (bluetoothAdapter == null) {
            Log.e("BluetoothHelper", "Bluetooth is not supported on this device")
            return false
        }

        return if (!bluetoothAdapter.isEnabled) {
            val enableBtIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
            activity.startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT)
            false
        } else {
            true
        }
    }

    // ✅ 페어링된 블루투스 기기 목록 가져오기
    fun getPairedDevices(): List<String> {
        if (bluetoothAdapter == null) {
            Log.e("BluetoothHelper", "Bluetooth is not supported on this device")
            return emptyList()
        }

        val pairedDevices = bluetoothAdapter.bondedDevices
        val deviceList = mutableListOf<String>()

        pairedDevices?.forEach { device ->
            deviceList.add("${device.name ?: "Unknown"} (${device.address})")
        }

        return deviceList
    }

    // ✅ 블루투스 기기 선택 다이얼로그 실행
    fun showBluetoothDevicePicker(activity: Activity, result: MethodChannel.Result) {
        try {
            pendingResult = result
            val intent = Intent("android.bluetooth.devicepicker.action.LAUNCH")
            intent.putExtra("android.bluetooth.devicepicker.extra.NEED_AUTH", false)
            intent.putExtra("android.bluetooth.devicepicker.extra.FILTER_TYPE", 1)
            activity.startActivityForResult(intent, REQUEST_BLUETOOTH_PICKER)
        } catch (e: Exception) {
            Log.e("BluetoothHelper", "Failed to open Bluetooth picker", e)
            result.error("BLUETOOTH_PICKER_ERROR", "Failed to open Bluetooth picker", null)
        }
    }

    // ✅ 선택된 블루투스 기기의 MAC 주소 반환
    fun handleBluetoothDeviceSelection(resultCode: Int, data: Intent?) {
        if (resultCode == Activity.RESULT_OK && data != null) {
            val device: BluetoothDevice? = data.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)

            if (device != null) {
                val macAddress = device.address
                Log.d("BluetoothHelper", "✅ Selected Device MAC Address: $macAddress")
                pendingResult?.success(macAddress) // ✅ MAC 주소만 반환
            } else {
                Log.e("BluetoothHelper", "❌ No device selected or invalid data.")
                pendingResult?.success(null)
            }
        } else {
            Log.e("BluetoothHelper", "❌ Bluetooth device selection cancelled or failed.")
            pendingResult?.success(null)
        }
        pendingResult = null
    }

    // ✅ 블루투스 기기 연결
    fun connectToDevice(macAddress: String): Boolean {
        if (bluetoothAdapter == null) {
            Log.e("BluetoothHelper", "Bluetooth is not supported on this device")
            return false
        }

        if (!bluetoothAdapter.isEnabled) {
            Log.e("BluetoothHelper", "Bluetooth is turned off")
            return false
        }

        if (!BluetoothAdapter.checkBluetoothAddress(macAddress)) {
            Log.e("BluetoothHelper", "Invalid Bluetooth MAC Address: $macAddress")
            return false
        }

        val device = bluetoothAdapter.getRemoteDevice(macAddress)
        return try {
            Log.d("BluetoothHelper", "Trying to connect to device: $macAddress")
            val socket = device.createRfcommSocketToServiceRecord(UUID.fromString("00001101-0000-1000-8000-00805F9B34FB"))
            bluetoothAdapter.cancelDiscovery()
            socket.connect()
            bluetoothSocket = socket
            Log.d("BluetoothHelper", "Connected to: $macAddress")
            true
        } catch (e: IOException) {
            Log.e("BluetoothHelper", "Failed to connect: ${e.message}")
            false
        }
    }

    // ✅ Galaxy Buds+ 기기 MAC 주소 가져오기
    fun getGalaxyBudsMacAddress(): String? {
        if (bluetoothAdapter == null) {
            Log.e("BluetoothHelper", "Bluetooth is not supported on this device")
            return null
        }

        val pairedDevices = bluetoothAdapter.bondedDevices
        for (device in pairedDevices) {
            if (device.name.contains("Galaxy Buds", ignoreCase = true)) { // ✅ Galaxy Buds+ 찾기
                Log.d("BluetoothHelper", "✅ Found Galaxy Buds: ${device.name} (${device.address})")
                return device.address
            }
        }

        Log.e("BluetoothHelper", "❌ Galaxy Buds+ not found among paired devices.")
        return null
    }
}

package com.identos.contracing.ui.bluetooth

import android.Manifest
import android.bluetooth.*
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanSettings
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.ParcelUuid
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import com.livinglifetechway.quickpermissions_kotlin.runWithPermissions
import java.util.*

private const val TAG = "ContactScanner"

class ContactScanner(private val context: AppCompatActivity) {

    private val serviceUUID = UUID.fromString("ba209999-0c6c-11d2-97cf-00c04f8eea40")
    private val characteristicUUID = UUID.fromString("ba209999-0c6c-11d2-97cf-00c04f8eea41")
    private val appData = context.application.getSharedPreferences(context.application.packageName, Context.MODE_PRIVATE)


    @RequiresApi(Build.VERSION_CODES.M)
    fun start() {
        val adapter = BluetoothAdapter.getDefaultAdapter()

        if (adapter != null && !adapter.isEnabled) {
            val enableIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
            context.startActivityForResult(enableIntent, 1)
        }
        if (!adapter.isEnabled) {
            //handle error
        }

        val filter = ScanFilter.Builder().setServiceUuid(ParcelUuid(serviceUUID)).build()

        val settings = ScanSettings
                .Builder()
                .setScanMode(ScanSettings.SCAN_MODE_LOW_POWER)
                .build()

        adapter.bluetoothLeScanner.startScan(listOf(filter), settings, scanCallback)
    }

    private fun stop() {
        BluetoothAdapter.getDefaultAdapter().bluetoothLeScanner.stopScan(scanCallback)
    }

    private fun deviceFound(device: BluetoothDevice) {
        Log.i(TAG, "deviceFound")

        if (!appData.peripheralExists(device.address)) {
            appData.addPeripheral(device.address)
            device.connectGatt(context, false, gattCallback)
        }
    }

    private val scanCallback = object : ScanCallback() {

        override fun onBatchScanResults(results: MutableList<ScanResult>?) {
            Log.i(TAG, "onBatchScanResults")
            results?.forEach { result ->
                deviceFound(result.device)
            }
        }

        override fun onScanResult(callbackType: Int, result: ScanResult?) {
            Log.i(TAG, "onScanResult")
            result?.let { deviceFound(result.device) }
        }

        override fun onScanFailed(errorCode: Int) {
            Log.i(TAG, "onScanFailed")
//      handleError(errorCode)
        }
    }

    private val gattCallback = object : BluetoothGattCallback() {

        override fun onConnectionStateChange(gatt: BluetoothGatt?, status: Int, newState: Int) {
            Log.i(TAG, "onConnectionStateChange Status: $status, New: $newState ")
            if (newState == BluetoothGatt.STATE_CONNECTED) {
                gatt!!.requestMtu(256)
            } else {
            }
        }

        override fun onMtuChanged(gatt: BluetoothGatt?, mtu: Int, status: Int) {
            Log.i(TAG, "onMtuChanged")
            if(status == BluetoothGatt.GATT_SUCCESS){
                Log.i(TAG, "Mtu: $mtu")
                gatt!!.discoverServices()
            }
        }

        override fun onServicesDiscovered(gatt: BluetoothGatt?, status: Int) {
            Log.i(TAG, "onServicesDiscovered")
            val service = gatt!!.getService(serviceUUID)
            val characteristic = service.getCharacteristic(characteristicUUID)
            gatt.readCharacteristic(characteristic)
        }

        override fun onCharacteristicRead(gatt: BluetoothGatt?, characteristic: BluetoothGattCharacteristic?, status: Int) {
            Log.i(TAG, "onCharacteristicRead")
            val payload = ContactPayload.fromString(characteristic!!.getStringValue(0))
            appData.addPayload(payload)
            Log.i(TAG, "Contact Payload: $payload")
        }
    }
}
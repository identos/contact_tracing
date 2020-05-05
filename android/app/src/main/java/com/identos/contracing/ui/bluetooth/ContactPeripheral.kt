package com.identos.contracing.ui.bluetooth

import android.bluetooth.*
import android.bluetooth.le.AdvertiseCallback
import android.bluetooth.le.AdvertiseData
import android.bluetooth.le.AdvertiseSettings
import android.bluetooth.le.BluetoothLeAdvertiser
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.ParcelUuid
import android.util.Log
import androidx.appcompat.app.AppCompatActivity
import com.identos.contracing.ui.util.Utils
import java.util.*

private const val TAG = "ContactPeripheral"


class ContactPeripheral(private var context: AppCompatActivity) {

    /* Bluetooth API */
    private lateinit var manager: BluetoothManager
    private lateinit var gattServer: BluetoothGattServer
    private val appData = context.application.getSharedPreferences(context.application.packageName, Context.MODE_PRIVATE)

    private val serviceUUID = UUID.fromString("ba209999-0c6c-11d2-97cf-00c04f8eea40")
    private val characteristicUUID = UUID.fromString("ba209999-0c6c-11d2-97cf-00c04f8eea41")


    private fun createService(): BluetoothGattService {

        val service = BluetoothGattService(serviceUUID, BluetoothGattService.SERVICE_TYPE_PRIMARY)

        val characteristic = BluetoothGattCharacteristic(characteristicUUID,
                BluetoothGattCharacteristic.PROPERTY_READ or BluetoothGattCharacteristic.PROPERTY_NOTIFY,
                BluetoothGattCharacteristic.PERMISSION_READ
        )

        service.addCharacteristic(characteristic)
        return service
    }


    private val receiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.STATE_OFF)

            when (state) {
                BluetoothAdapter.STATE_ON -> {
                    startAdvertising()
                    start()
                }
                BluetoothAdapter.STATE_OFF -> {
                    stop()
                    stopAdvertising()
                }
            }
        }
    }


    private val advertiseCallback = object : AdvertiseCallback() {
        override fun onStartSuccess(settingsInEffect: AdvertiseSettings) {
            Log.i(TAG, "Advertising.")
        }

        override fun onStartFailure(errorCode: Int) {
            Log.w(TAG, "Failed to advertise with code: $errorCode")
        }
    }


    private val serverCallback = object : BluetoothGattServerCallback() {

        override fun onConnectionStateChange(device: BluetoothDevice, status: Int, newState: Int) {
            if (newState == BluetoothProfile.STATE_CONNECTED) {
                Log.i(TAG, "Device connected: $device")
            } else if (newState == BluetoothProfile.STATE_DISCONNECTED) {
                Log.i(TAG, "Device disconnected: $device")
            }
        }

        override fun onCharacteristicReadRequest(device: BluetoothDevice, requestId: Int, offset: Int, characteristic: BluetoothGattCharacteristic) {
            val payload = ContactPayload(UUID.randomUUID().toString(), "droid", Utils.getDeviceUUID(context))
            Log.i(TAG, "Read characteristic")
            Log.i(TAG, "Sending: $payload to ${device.name} for characteristic: ${characteristic.uuid}")
            appData.addPayload(payload)
            gattServer.sendResponse(device, requestId, BluetoothGatt.GATT_SUCCESS, 0, payload.toByteArray())
        }


        override fun onDescriptorReadRequest(device: BluetoothDevice, requestId: Int, offset: Int, descriptor: BluetoothGattDescriptor) {
            Log.i(TAG, "descriptor read")
            val returnValue = BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
            gattServer.sendResponse(device, requestId, BluetoothGatt.GATT_SUCCESS, 0, returnValue)
        }

    }

    fun start() {
        manager = context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        val filter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        context.registerReceiver(receiver, filter)
        startAdvertising()
        gattServer = manager.openGattServer(context, serverCallback)
        gattServer.addService(createService())
    }

    private fun stop() {
        gattServer?.close()
    }

    private fun startAdvertising() {
        val advertiser: BluetoothLeAdvertiser? =
                manager.adapter?.bluetoothLeAdvertiser


        val settings = AdvertiseSettings.Builder()
                .setAdvertiseMode(AdvertiseSettings.ADVERTISE_MODE_BALANCED)
                .setConnectable(true)
                .setTimeout(0)
                .setTxPowerLevel(AdvertiseSettings.ADVERTISE_TX_POWER_MEDIUM)
                .build()

        val data = AdvertiseData.Builder()
                .setIncludeDeviceName(false)
                .setIncludeTxPowerLevel(false)
                .addServiceUuid(ParcelUuid(serviceUUID))
                .build()

        advertiser?.startAdvertising(settings, data, advertiseCallback)

    }

    private fun stopAdvertising() {
        val bluetoothLeAdvertiser: BluetoothLeAdvertiser? =
                manager.adapter?.bluetoothLeAdvertiser
        bluetoothLeAdvertiser?.stopAdvertising(advertiseCallback)
    }

}
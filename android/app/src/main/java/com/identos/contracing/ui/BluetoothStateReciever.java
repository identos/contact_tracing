package com.identos.contracing.ui;

import android.bluetooth.BluetoothAdapter;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import com.google.android.material.snackbar.Snackbar;

public class BluetoothStateReciever extends BroadcastReceiver {

    private BluetoothStateChangeHandler bluetoothStateChangeHandler;

    public BluetoothStateReciever(BluetoothStateChangeHandler bluetoothStateChangeHandler) {
        this.bluetoothStateChangeHandler = bluetoothStateChangeHandler;
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        final String action = intent.getAction();
        if (action.equals(BluetoothAdapter.ACTION_STATE_CHANGED)) {
            final int state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.ERROR);
            this.bluetoothStateChangeHandler.handleBluetoothStateChange(state);
        }

    }
}

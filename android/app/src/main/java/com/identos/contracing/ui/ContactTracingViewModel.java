package com.identos.contracing.ui;

import android.bluetooth.BluetoothAdapter;

import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

public class ContactTracingViewModel extends ViewModel {

    final MutableLiveData<BluetoothState> bluetoothState = new MutableLiveData<>();
    private BluetoothAdapter bluetoothAdapter;
    public ContactTracingViewModel(){
        bluetoothState.setValue(BluetoothState.OFF);
        bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();

    }

    public enum BluetoothState {
        ON,
        OFF
    }

    public void checkBluetoothState(){
        if(bluetoothAdapter!= null && bluetoothAdapter.isEnabled()){
            bluetoothState.setValue(BluetoothState.ON);
        } else{
            bluetoothState.setValue(BluetoothState.OFF);
        }
    }
}

package com.identos.contracing.ui;

import androidx.appcompat.app.AppCompatActivity;
import androidx.databinding.DataBindingUtil;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProvider;
import androidx.navigation.NavController;
import androidx.navigation.NavDirections;
import androidx.navigation.Navigation;

import android.bluetooth.BluetoothAdapter;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;

import com.google.android.material.snackbar.Snackbar;
import com.identos.contracing.R;
import com.identos.contracing.databinding.ContactTracerActivityBinding;

public class ContactTracerMainActivity extends AppCompatActivity implements BluetoothStateChangeHandler {

    private SignUpViewModel signUpViewModel;
    private boolean isSignedUp;
    private BroadcastReceiver bluetoothStateBroadcastReceiver;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ContactTracerActivityBinding activityBinding = DataBindingUtil.
                setContentView(this, R.layout.activity_contact_tracer_main);

        signUpViewModel = new ViewModelProvider(this).get(SignUpViewModel.class);
        signUpViewModel.isSignedUp.observe(this, new Observer<Boolean>() {
            @Override
            public void onChanged(Boolean isSignedUp) {
                ContactTracerMainActivity.this.isSignedUp = isSignedUp;
            }
        });

        bluetoothStateBroadcastReceiver = new BluetoothStateReciever(this);
        IntentFilter intentFilter = new IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED);
        registerReceiver(bluetoothStateBroadcastReceiver, intentFilter);

        NavController navController = Navigation.findNavController(this, R.id.nav_host_fragment);
        navController.setGraph(R.navigation.navigation_graph);
    }

    @Override
    public void handleBluetoothStateChange(int newState) {
        if(newState == BluetoothAdapter.STATE_ON && isSignedUp){
            //strong assumption that the off fragment is currently shown
            NavDirections action = HomeeBluetoothOffDirections.actionHomeeBluetoothOffToHomeBluetoothOnFragment2();
            NavController navController = Navigation.findNavController(this, R.id.nav_host_fragment);
            navController.navigate(action);

        } else if(newState == BluetoothAdapter.STATE_OFF && isSignedUp){
            NavDirections action = HomeBluetoothOnFragmentDirections.actionHomeBluetoothOnFragmentToHomeeBluetoothOff();
            NavController navController = Navigation.findNavController(this, R.id.nav_host_fragment);
            navController.navigate(action);
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if(bluetoothStateBroadcastReceiver!= null)
            unregisterReceiver(bluetoothStateBroadcastReceiver);
    }

}

package com.identos.contracing.ui.signup;

import android.Manifest;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.databinding.DataBindingUtil;
import androidx.fragment.app.Fragment;
import androidx.navigation.NavDirections;
import androidx.navigation.Navigation;

import com.identos.contracing.NavigationGraphDirections;
import com.identos.contracing.R;
import com.identos.contracing.databinding.EnableBluetoothFragmentBinding;

import java.util.List;
import java.util.Objects;

import pub.devrel.easypermissions.EasyPermissions;


/**
 * A simple {@link Fragment} subclass.
 */
public class EnableBluetoothFragment extends Fragment implements View.OnClickListener, EasyPermissions.PermissionCallbacks {

    private static final int REQUEST_ENABLE_BT = 111;
    private static final int RC_BLUETOOTH_AND_LOCATION = 112;
    private EnableBluetoothFragmentBinding binding;

    public EnableBluetoothFragment() {
        // Required empty public constructor
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        binding = DataBindingUtil.inflate(inflater,
                R.layout.fragment_enable_bluetooth, container, false);
        binding.buttonContinue.setOnClickListener(this);
        return binding.getRoot();
    }

    @Override
    public void onClick(View v) {
        binding.buttonContinue.setVisibility(View.GONE);
        binding.progressBar3.setVisibility(View.VISIBLE);
        requestBluetoothEnable();
    }

    private void requestBluetoothEnable(){
        final BluetoothManager bluetoothManager = (BluetoothManager)requireActivity().getSystemService(Context.BLUETOOTH_SERVICE);
        BluetoothAdapter bluetoothAdapter = bluetoothManager.getAdapter();
        if (bluetoothAdapter == null || !bluetoothAdapter.isEnabled()) {
            Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            startActivityForResult(enableBtIntent, REQUEST_ENABLE_BT);
        } else {
            requestLocationPermissions();
        }
    }

    private void requestLocationPermissions(){
        String[] perms = {Manifest.permission.ACCESS_COARSE_LOCATION};
        if(EasyPermissions.hasPermissions(requireContext(), perms)){
            NavDirections action = EnableBluetoothFragmentDirections.
                    actionEnableBluetoothFragmentToBluetoothSwitchDialog();
            Navigation.findNavController(Objects.requireNonNull(getView())).navigate(action);
        } else {
            EasyPermissions.requestPermissions(this, getString(R.string.ble_rationale_msg)
                    , RC_BLUETOOTH_AND_LOCATION, perms );
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if(requestCode == REQUEST_ENABLE_BT){
            requestLocationPermissions();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);

        EasyPermissions.onRequestPermissionsResult(requestCode, permissions, grantResults, this);
    }

    private void navigateToHome() {

        NavDirections action = NavigationGraphDirections.actionGlobalHomeeBluetoothOff();
        Navigation.findNavController(getView()).navigate(action);
    }

    @Override
    public void onPermissionsGranted(int requestCode, @NonNull List<String> perms) {
        navigateToHome();
    }
    @Override
    public void onPermissionsDenied(int requestCode, @NonNull List<String> perms) {;
        navigateToHome();
    }
}

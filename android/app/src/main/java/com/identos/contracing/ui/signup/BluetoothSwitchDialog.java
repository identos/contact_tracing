package com.identos.contracing.ui.signup;

import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.fragment.app.DialogFragment;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;
import androidx.navigation.NavDirections;
import androidx.navigation.NavOptions;
import androidx.navigation.Navigation;
import androidx.navigation.fragment.NavHostFragment;

import com.identos.contracing.NavigationGraphDirections;
import com.identos.contracing.R;
import com.identos.contracing.ui.SignUpViewModel;

import static androidx.navigation.Navigation.findNavController;

/**
 * A simple {@link Fragment} subclass.
 */
public class BluetoothSwitchDialog extends DialogFragment {

    private SignUpViewModel signUpViewModel;
    public BluetoothSwitchDialog() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ViewModelProvider provider = new ViewModelProvider(requireActivity());
        signUpViewModel = provider.get(SignUpViewModel.class);
    }

    @NonNull
    @Override
    public Dialog onCreateDialog(@Nullable Bundle savedInstanceState) {
        final AlertDialog dialog = new AlertDialog.Builder(requireActivity())
                .setTitle(R.string.blueetooth_dialog_title)
                .setMessage(R.string.bluetooth_dialog_msg)
                .setPositiveButton(R.string.allow, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        //signup successful
                        //navigate home
                        NavDirections action = NavigationGraphDirections.actionGlobalHomeeBluetoothOff();
                        NavHostFragment.findNavController(BluetoothSwitchDialog.this).navigate(action);
                    }
                })
                .create();
        setCancelable(false);
        dialog.show();
        return dialog;
    }

}

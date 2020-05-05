package com.identos.contracing.ui;

import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.databinding.DataBindingUtil;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProvider;
import androidx.navigation.NavDirections;
import androidx.navigation.Navigation;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.identos.contracing.R;
import com.identos.contracing.databinding.BluetoothOffFragmentBinding;
import com.identos.contracing.ui.util.Utils;


/**
 * A simple {@link Fragment} subclass.
 */
public class HomeeBluetoothOff extends Fragment implements View.OnClickListener{

    private ContactTracingViewModel viewModel;
    private SignUpViewModel signUpViewModel;

    public HomeeBluetoothOff() {
        // Required empty public constructor
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        BluetoothOffFragmentBinding binding = DataBindingUtil.inflate(inflater,
                R.layout.fragment_homee_bluetooth_off, container, false);
        binding.content.button.setOnClickListener(this);
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull final View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        signUpViewModel = new ViewModelProvider(requireActivity()).get(SignUpViewModel.class);
        signUpViewModel.isSignedUp.observe(getViewLifecycleOwner(), new Observer<Boolean>() {
            @Override
            public void onChanged(Boolean isSignedUp) {
                if (Boolean.TRUE.equals(isSignedUp)) {
                    viewModel.checkBluetoothState();
                } else {
                    //launch sign up flow
                    NavDirections action = HomeeBluetoothOffDirections.actionHomeeBluetoothOffToSignUpGraph();
                    Navigation.findNavController(view).navigate(action);
                }
            }
        });
        viewModel = new ViewModelProvider(requireActivity()).get(ContactTracingViewModel.class);
        viewModel.bluetoothState.observe(getViewLifecycleOwner(), new Observer<ContactTracingViewModel.BluetoothState>() {
            @Override
            public void onChanged(ContactTracingViewModel.BluetoothState bluetoothState) {
                if(bluetoothState == ContactTracingViewModel.BluetoothState.ON){
                    //pop this view from stact and go to bluetooth on fragment
                    NavDirections action = HomeeBluetoothOffDirections.actionHomeeBluetoothOffToHomeBluetoothOnFragment2();
                    Navigation.findNavController(view).navigate(action);
                }
            }
        });

            signUpViewModel.checkIfSignedUp();

    }

    @Override
    public void onClick(View v) {
        Utils.requestBluetoothEnable(requireContext());
    }
}

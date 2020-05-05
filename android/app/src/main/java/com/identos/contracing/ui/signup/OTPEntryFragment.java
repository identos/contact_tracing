package com.identos.contracing.ui.signup;

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
import com.identos.contracing.databinding.OTPEntryFragmentBinding;
import com.identos.contracing.ui.SignUpViewModel;
import com.identos.contracing.ui.util.StateData;


/**
 * A simple {@link Fragment} subclass.
 */
public class OTPEntryFragment extends Fragment implements View.OnClickListener {

    public OTPEntryFragment() {
        // Required empty public constructor
    }

    private OTPEntryFragmentBinding binding;
    private SignUpViewModel signUpViewModel;

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_otp_entry,
                container, false);
        binding.buttonContinue.setOnClickListener(this);
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        signUpViewModel = new ViewModelProvider(requireActivity()).get(SignUpViewModel.class);
        signUpViewModel.getConfirmRegistrationLiveData().observe(getViewLifecycleOwner(),
                new RegistrationConfirmationObserver(view, binding));
        binding.setLifecycleOwner(this);
        binding.setSignUpViewModel(signUpViewModel);
    }

    @Override
    public void onClick(View v) {
        signUpViewModel.confirmRegistration();
    }

    private class RegistrationConfirmationObserver implements Observer<StateData<Void>> {

        private View view;
        private OTPEntryFragmentBinding binding;

        public RegistrationConfirmationObserver(View view, OTPEntryFragmentBinding binding) {
            this.view = view;
            this.binding = binding;
        }

        @Override
        public void onChanged(StateData<Void> voidStateData) {
            if(!voidStateData.isHandled()){
                voidStateData.getContentIfNotHandled();
                signUpViewModel.saveSignUpState(true);
                NavDirections action = OTPEntryFragmentDirections.actionOTPEntryFragmentToEnableBluetoothFragment();
                Navigation.findNavController(view).navigate(action);
            } else if(voidStateData.getStatus()== StateData.DataStatus.ERROR){
                binding.otpEntry.setError(view.getContext().getString(R.string.otp_error_msg));
            }
        }
    }
}

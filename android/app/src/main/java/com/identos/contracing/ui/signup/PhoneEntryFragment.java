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
import com.identos.contracing.databinding.PhoneEntryFragmentBinding;
import com.identos.contracing.ui.SignUpViewModel;
import com.identos.contracing.ui.api.ContactTracingAPIService;
import com.identos.contracing.ui.util.StateData;


/**
 * A simple {@link Fragment} subclass.
 */
public class PhoneEntryFragment extends Fragment implements View.OnClickListener {

    private SignUpViewModel signUpViewModel;
    private PhoneEntryFragmentBinding binding;

    public PhoneEntryFragment() {
        // Required empty public constructor
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        binding = DataBindingUtil.inflate(inflater,
                R.layout.fragment_phone_entry, container, false);
        binding.buttonContinue.setOnClickListener(this);
        return binding.getRoot();
    }

    @Override
    public void onViewCreated(@NonNull View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        signUpViewModel = new ViewModelProvider(requireActivity()).get(SignUpViewModel.class);
        signUpViewModel.getDeviceRegistrationResponse().observe(getViewLifecycleOwner(), new RegistrationObserver(view, binding));
        binding.setLifecycleOwner(this);
        binding.setSignUpViewModel(signUpViewModel);
    }

    @Override
    public void onClick(View v) {
        signUpViewModel.registerDevice();
    }

    private static class RegistrationObserver implements Observer<StateData<ContactTracingAPIService.RegistrationResponse>> {
        View view;
        PhoneEntryFragmentBinding binding;

        public RegistrationObserver(View view, PhoneEntryFragmentBinding binding) {
            this.view = view;
            this.binding = binding;
        }

        @Override
        public void onChanged(StateData<ContactTracingAPIService.RegistrationResponse> registrationResponseStateData) {
            if (registrationResponseStateData.getStatus() == StateData.DataStatus.SUCCESS
                    && !registrationResponseStateData.isHandled() ) {
                ContactTracingAPIService.RegistrationResponse data = registrationResponseStateData.getContentIfNotHandled();
                if(data.getIat() != null && data.getUuid() !=null){
                    NavDirections action = PhoneEntryFragmentDirections
                            .actionPhoneEntryFragmentToOTPEntryFragment();
                    Navigation.findNavController(view).navigate(action);
                }
            } else if(registrationResponseStateData.getStatus() == StateData.DataStatus.ERROR){
                binding.phoneNumberEntry.setError(view.getContext().getString(R.string.registration_error_msg));
        }
        }
    }
}

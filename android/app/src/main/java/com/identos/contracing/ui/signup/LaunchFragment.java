package com.identos.contracing.ui.signup;

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

import com.identos.contracing.R;
import com.identos.contracing.databinding.LaunchFragmentBinding;

public class LaunchFragment extends Fragment implements View.OnClickListener {

    public static LaunchFragment newInstance() {
        return new LaunchFragment();
    }

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container,
                             @Nullable Bundle savedInstanceState) {
        LaunchFragmentBinding launchFragmentBinding = DataBindingUtil.inflate(inflater,
                R.layout.fragment_launch_view, container, false);
        launchFragmentBinding.launchButton.setOnClickListener(this);
        return launchFragmentBinding.getRoot();
    }

    @Override
    public void onClick(View v) {
        NavDirections action = LaunchFragmentDirections.actionLaunchFragmentToPhoneEntryFragment();
        Navigation.findNavController(v).navigate(action);
    }
}

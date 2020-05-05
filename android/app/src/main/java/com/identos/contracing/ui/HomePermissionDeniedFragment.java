package com.identos.contracing.ui;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.databinding.DataBindingUtil;
import androidx.fragment.app.Fragment;

import com.identos.contracing.R;
import com.identos.contracing.databinding.HomePermissionDeniedFragmentBinding;

public class HomePermissionDeniedFragment extends Fragment {

    public HomePermissionDeniedFragment(){}

    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        //inflate
        HomePermissionDeniedFragmentBinding binding = DataBindingUtil.inflate(inflater, R.layout.fragment_home_permission_denied, container, false);

        return  binding.getRoot();
    }
}

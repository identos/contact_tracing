package com.identos.contracing.ui;

import android.app.Application;

import androidx.annotation.NonNull;
import androidx.lifecycle.AndroidViewModel;
import androidx.lifecycle.MutableLiveData;

import com.google.gson.Gson;
import com.identos.contracing.ui.api.ContactTracingAPIService;
import com.identos.contracing.ui.api.NetworkManager;
import com.identos.contracing.ui.api.Settings;
import com.identos.contracing.ui.util.StatefulLiveData;
import com.identos.contracing.ui.util.Utils;

import org.json.JSONObject;

public class SignUpViewModel extends AndroidViewModel {


    private static final String SETTINGS_FILE_NAME = "settings.json";
    private MutableLiveData<String> phoneNumber = new MutableLiveData<>();
    private MutableLiveData<String> otp = new MutableLiveData<>();

    private static final String PHONE_PREFIX ="+1";

    final MutableLiveData<Boolean> isSignedUp = new MutableLiveData<>();
    private StatefulLiveData<ContactTracingAPIService.RegistrationResponse> deviceRegistrationResult = new StatefulLiveData<>();
    private StatefulLiveData<Void> confirmRegistrationLiveData = new StatefulLiveData<>();


    private final ContactTracingAPIService contactTracingAPIService;

    public SignUpViewModel(@NonNull Application application){
        super(application);
        isSignedUp.setValue(false);
        Settings settings = loadSettingsFromAssets();
        ContactTracingAPIService.ContactTracingAPI contactTracingAPI = NetworkManager.
                createRetrofitService(settings.getBaseUrl());
        contactTracingAPIService = new ContactTracingAPIService(contactTracingAPI, settings,
                deviceRegistrationResult, confirmRegistrationLiveData);
    }

    private Settings loadSettingsFromAssets(){
        String settingsTxt = Utils.loadJSONFromAssetsWithFileName(getApplication(), SETTINGS_FILE_NAME);
        Settings settings = new Gson().fromJson(settingsTxt, Settings.class);
        return settings;
    }

    public void checkIfSignedUp(){

        Boolean isSignedUp = Utils.getSignUpState(getApplication());

        this.isSignedUp.setValue(isSignedUp);
    }

    public void saveSignUpState(boolean isSignedUp){
        Utils.saveSignUpState(getApplication(), isSignedUp);
    }

    public void confirmRegistration(){
        String deviceUUID = Utils.getDeviceUUID(getApplication());
        contactTracingAPIService.confirmDeviceRegistration(deviceUUID, otp.getValue());
    }
    void registerDevice(String phoneNumber, String uuid){
        contactTracingAPIService.registerDevice(PHONE_PREFIX + phoneNumber, uuid);
    }

    public void registerDevice(){
        String deviceUUID = Utils.getDeviceUUID(getApplication());
        registerDevice(phoneNumber.getValue(), deviceUUID);
    }

    public MutableLiveData<String> getPhoneNumber() {
        return phoneNumber;
    }

    public MutableLiveData<String> getOtp() {
        return otp;
    }

    public StatefulLiveData<ContactTracingAPIService.RegistrationResponse> getDeviceRegistrationResponse() {
        return deviceRegistrationResult;
    }

    public StatefulLiveData<Void> getConfirmRegistrationLiveData() {
        return confirmRegistrationLiveData;
    }
}

package com.identos.contracing.ui.api;


import com.google.gson.annotations.SerializedName;
import com.identos.contracing.ui.util.StatefulLiveData;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.http.Body;
import retrofit2.http.Header;
import retrofit2.http.POST;
import retrofit2.http.Path;

public class ContactTracingAPIService {

    private ContactTracingAPI contactTracingAPI;
    private final StatefulLiveData<RegistrationResponse> registrationResponseMutableLiveData;
    private final StatefulLiveData<Void> confirmRegistrationLiveData;
    private final Settings settings;

    public ContactTracingAPIService(ContactTracingAPI contactTracingAPI,
                                    Settings settings,
                                    StatefulLiveData<RegistrationResponse> registrationResponseMutableLiveData,
                                    StatefulLiveData<Void> confirmRegistrationLiveData) {
        this.contactTracingAPI = contactTracingAPI;
        this.settings = settings;
        this.registrationResponseMutableLiveData = registrationResponseMutableLiveData;
        this.confirmRegistrationLiveData = confirmRegistrationLiveData;
    }

    public void registerDevice(String phoneNumber, String uuid){
        registrationResponseMutableLiveData.postLoading();
        RequestBody requestBody = new RequestBody(phoneNumber, uuid);
        contactTracingAPI.registerDevice(settings.getApiKey(), requestBody).enqueue(new Callback<RegistrationResponse>() {
            @Override
            public void onResponse(Call<RegistrationResponse> call, Response<RegistrationResponse> response) {
                if(response.isSuccessful()){
                    registrationResponseMutableLiveData.postSuccess(response.body());
                } else {
                    registrationResponseMutableLiveData.postError(new Throwable());
                }
            }

            @Override
            public void onFailure(Call<RegistrationResponse> call, Throwable t) {
                registrationResponseMutableLiveData.postError(t);
            }
        });
    }

    public void  confirmDeviceRegistration(String deviceUUID, String otp){
        confirmRegistrationLiveData.postLoading();
        ConfirmationRequestBody requestBody = new ConfirmationRequestBody(otp);
        contactTracingAPI.confirmDeviceRegistration(settings.getApiKey(), deviceUUID, requestBody).enqueue(new Callback<Void>() {
            @Override
            public void onResponse(Call<Void> call, Response<Void> response) {
                if(response.isSuccessful()){
                    confirmRegistrationLiveData.postSuccess(response.body());
                } else {
                    confirmRegistrationLiveData.postError(new Throwable());
                }
            }

            @Override
            public void onFailure(Call<Void> call, Throwable t) {
                confirmRegistrationLiveData.postError(new Throwable());
            }
        });

    }

    public interface ContactTracingAPI {
        @POST("api/v1/devices")
        Call<RegistrationResponse> registerDevice(@Header ("x-functions-key") String key, @Body RequestBody requestBody);

        @POST("api/v1/devices/{uuid}/confirm")
        Call<Void> confirmDeviceRegistration(@Header ("x-functions-key") String key, @Path("uuid")String deviceUUID, @Body ConfirmationRequestBody requestBody);
    }

    static public class RegistrationResponse {
        @SerializedName("identifier")
        private String uuid;
        private String iat;

        public String getUuid() {
            return uuid;
        }

        public String getIat() {
            return iat;
        }
    }

    static public class RequestBody{
        private String phone;
        private String identifier;

        public RequestBody(String phone, String identifier) {
            this.phone = phone;
            this.identifier = identifier;
        }
    }

    static public class ConfirmationRequestBody {
        @SerializedName("user_code")
        private String otp;

        public ConfirmationRequestBody(String otp) {
            this.otp = otp;
        }

        public String getOtp() {
            return otp;
        }
    }
}

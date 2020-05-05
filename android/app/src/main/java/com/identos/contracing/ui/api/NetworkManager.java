package com.identos.contracing.ui.api;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class NetworkManager {

    public static ContactTracingAPIService.ContactTracingAPI createRetrofitService(String baseUrl){
        Gson gson = new GsonBuilder()
                .setLenient()
                .create();

        Retrofit retrofit = new  Retrofit.Builder()
                .baseUrl(baseUrl)
                .addConverterFactory(GsonConverterFactory.create(gson))
                .build();

        return retrofit.create(ContactTracingAPIService.ContactTracingAPI.class);
    }
}

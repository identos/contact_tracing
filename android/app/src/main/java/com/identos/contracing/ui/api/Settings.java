package com.identos.contracing.ui.api;

import com.google.gson.annotations.SerializedName;

public class Settings {
    @SerializedName("base_url")
    private String baseUrl;
    @SerializedName("api_key")
    private String apiKey;

    public String getBaseUrl() {
        return baseUrl;
    }

    public String getApiKey() {
        return apiKey;
    }
}

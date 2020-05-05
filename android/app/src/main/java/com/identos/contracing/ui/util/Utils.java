package com.identos.contracing.ui.util;

import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothManager;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.text.TextUtils;
import android.util.Log;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.UUID;

public class Utils {
    private static final String SIGN_UP_STATE_KEY = "sign_up_state";
    private static final String DEVICE_UUID = "device_uuid_key";
    private static final String TAG = "Utils";

    public static void saveSignUpState(Context context, boolean isSignedUp) {
        SharedPreferences sharedPreferences =context.getSharedPreferences(context.getPackageName(), Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putBoolean(SIGN_UP_STATE_KEY, isSignedUp);
        editor.apply();
    }

    public static boolean getSignUpState(Context context){
        SharedPreferences sharedPreferences = context.
                getSharedPreferences(context.getPackageName(),
                        Context.MODE_PRIVATE);
        return sharedPreferences.getBoolean(SIGN_UP_STATE_KEY, false);
    }

    public static String getDeviceUUID(Context context){
        SharedPreferences sharedPreferences = context.
                getSharedPreferences(context.getPackageName(),
                        Context.MODE_PRIVATE);
        String uuid = sharedPreferences.getString(DEVICE_UUID, null);
        if(uuid == null){
            uuid = createDeviceUUID();
            saveDeviceUUID(context, uuid);
        }
        return uuid;
    }

    private static String createDeviceUUID() {
        UUID uuid = UUID.randomUUID();
        return uuid.toString();
    }

    private static void saveDeviceUUID(Context context, String uuid) {
        SharedPreferences sharedPreferences =context.getSharedPreferences(context.getPackageName(), Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putString(DEVICE_UUID, uuid);
        editor.apply();
    }

    public static String loadJSONFromAssetsWithFileName(Context context, String fileName) {
        String json =null;
        try (InputStream is = context.getAssets().open(fileName)) {
            int size = is.available();
            byte[] buffer = new byte[size];
            int count = is.read(buffer);
            if(count >0){
                json = new String(buffer, StandardCharsets.UTF_8);
            }
        } catch (IOException ex) {
            Log.d(TAG, "Exception: " + ex);
        }
        return json;
    }

    public static void requestBluetoothEnable(Context context) {
        final BluetoothManager bluetoothManager = (BluetoothManager)context.getSystemService(Context.BLUETOOTH_SERVICE);
        BluetoothAdapter bluetoothAdapter = bluetoothManager.getAdapter();
        if (bluetoothAdapter == null || !bluetoothAdapter.isEnabled()) {
            Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            context.startActivity(enableBtIntent);
        }
    }
}

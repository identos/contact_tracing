package com.identos.contracing.ui.bluetooth

import android.content.SharedPreferences
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken

fun SharedPreferences.addPayload(payload: ContactPayload) {
  val updated = getPayloads().plus(payload)
  this.edit().putString("contactPayloads", Gson().toJson(updated)).apply()
}

fun SharedPreferences.getPayloads(): Array<ContactPayload> {
  val json = this.getString("contactPayloads", "[]")
  val type = object : TypeToken<Array<ContactPayload>>() {}.type
  return Gson().fromJson(json, type)
}

fun SharedPreferences.addPeripheral(peripheral: String) {
  val peripherals = getPeripherals()
  val updated = peripherals.plus(peripheral)
  this.edit().putString("peripherals", Gson().toJson(updated)).apply()
}

fun SharedPreferences.getPeripherals(): Array<String> {
  val json = this.getString("peripherals", "[]")
  val type = object : TypeToken<Array<String>>() {}.type
  return Gson().fromJson(json, type)
}

fun SharedPreferences.peripheralExists(peripheral: String): Boolean {
  return getPeripherals().contains(peripheral)
}

fun SharedPreferences.forgetPeripherals() {
  this.edit().putString("peripherals", "[]").apply()
}

fun SharedPreferences.forgetPayloads() {
  this.edit().putString("contactPayloads", "[]").apply()
}
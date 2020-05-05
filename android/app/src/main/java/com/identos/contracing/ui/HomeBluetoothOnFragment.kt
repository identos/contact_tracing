package com.identos.contracing.ui

import android.Manifest
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity
import androidx.databinding.DataBindingUtil
import androidx.fragment.app.Fragment
import androidx.navigation.Navigation
import com.identos.contracing.R
import com.identos.contracing.databinding.HomeBluetoothOnBinding
import com.identos.contracing.ui.bluetooth.ContactPeripheral
import com.identos.contracing.ui.bluetooth.ContactScanner
import pub.devrel.easypermissions.AfterPermissionGranted
import pub.devrel.easypermissions.EasyPermissions


/**
 * A simple [Fragment] subclass.
 */
class HomeBluetoothOnFragment : Fragment() {

    private lateinit var binding: HomeBluetoothOnBinding
    lateinit var scanner: ContactScanner
    lateinit var peripheral: ContactPeripheral

    private val RC_BLUETOOTH_AND_LOCATION = 112

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?,
                              savedInstanceState: Bundle?): View? {
        // Inflate the layout for this fragment
        binding = DataBindingUtil.inflate(inflater, R.layout.fragment_home_bluetooth_on, container, false)
        return binding.root
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        binding.content.shareAppButton.setOnClickListener {
            val action = HomeBluetoothOnFragmentDirections.actionHomeBluetoothOnToContactPayloadListFragment()
            Navigation.findNavController(view).navigate(action)
        }

        peripheral = ContactPeripheral(this.activity as AppCompatActivity)
        peripheral.start()
        startScanner()
    }

    @AfterPermissionGranted(112)
    private fun startScanner(){
        if (EasyPermissions.hasPermissions(context!!, Manifest.permission.ACCESS_COARSE_LOCATION)) {
            scanner = ContactScanner(this.activity as AppCompatActivity)
            scanner.start()
        } else {
            EasyPermissions.requestPermissions(this, getString(R.string.ble_rationale_msg),
                    112, Manifest.permission.ACCESS_COARSE_LOCATION)
        }
    }
}
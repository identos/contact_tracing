package com.identos.contracing.ui.bluetooth//package com.identos.contacttracing.ui.com.identos.contacttracing.ui.bluetooth

import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import androidx.annotation.LayoutRes
import androidx.fragment.app.Fragment
import androidx.navigation.Navigation
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.identos.contracing.R
import kotlinx.android.synthetic.main.contact_payload_list_item.view.*


class ContactPayloadAdapter(var payloads: Array<ContactPayload>) :
        RecyclerView.Adapter<ContactPayloadAdapter.UserViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, p1: Int) = UserViewHolder(
            LayoutInflater.from(parent.context).inflate(R.layout.contact_payload_list_item, parent, false)
    )

    override fun getItemCount() = payloads.size

    override fun onBindViewHolder(holder: UserViewHolder, position: Int) {
        holder.bind(payloads[position])
    }

    class UserViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        private val nonceText = view.payloadNonceText
        private val subText = view.payloadSubText
        private val audText = view.payloadAudText
        private val dateText = view.payloadDateText
        private val sentText = view.payloadSentRecievedText

        fun bind(payload: ContactPayload) {
            sentText.text = when(payload.received){
                true -> "Payload: Received"
                false -> "Payload: Sent"
            }
            subText.text = payload.sub
            audText.text = payload.aud
            nonceText.text = payload.nonce
            dateText.text = payload.date.toString()
        }
    }
}

fun ViewGroup.inflate(@LayoutRes layoutRes: Int, attachToRoot: Boolean = false): View {
    return LayoutInflater.from(context).inflate(layoutRes, this, attachToRoot)
}


class ContactPayloadListFragment : Fragment() {

    protected lateinit var rootView: View
    lateinit var recyclerView: RecyclerView


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        onCreateComponent()
    }

    private fun onCreateComponent() {

    }

    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View? {
        rootView = inflater.inflate(R.layout.fragment_contact_payload_list, container, false);
        initView()
        return rootView
    }

    private fun initView() {
        initializeRecyclerView()

        val rescanButton = rootView.findViewById(R.id.rescanButton) as Button
        val clearButton = rootView.findViewById(R.id.clearButton) as Button
        val closeButton = rootView.findViewById(R.id.closeButton) as Button

        rescanButton.setOnClickListener {
            activity!!.application!!.getSharedPreferences(activity!!.application.packageName, Context.MODE_PRIVATE).forgetPeripherals()
        }

        clearButton.setOnClickListener {
            activity!!.application!!.getSharedPreferences(activity!!.application.packageName, Context.MODE_PRIVATE).forgetPayloads()
            recyclerView.adapter?.notifyDataSetChanged()
        }

        closeButton.setOnClickListener {
            val action = ContactPayloadListFragmentDirections.actionContactPayloadListFragmentToHomeBluetoothOnFragment3()
            Navigation.findNavController(rootView).navigate(action)
        }
    }

    private fun initializeRecyclerView() {
        recyclerView = rootView.findViewById(R.id.recyclerView)
        recyclerView.layoutManager = LinearLayoutManager(activity)
        var payloads = activity!!.application!!.getSharedPreferences(activity!!.application.packageName, Context.MODE_PRIVATE).getPayloads()
        payloads.reverse()
        val adapter = ContactPayloadAdapter(payloads)
        recyclerView.adapter = adapter
    }
}
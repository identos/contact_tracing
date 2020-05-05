package com.identos.contracing.ui.bluetooth

import java.util.*

data class ContactPayload(val nonce: String,
                          val aud: String,
                          val sub: String,
                          var received:Boolean = false,
                          val date:Date = Date()) {
    companion object
}

fun ContactPayload.Companion.fromString(payloadString: String): ContactPayload {
    val commaSep = payloadString.split(",")
    return ContactPayload(commaSep[0], commaSep[1], commaSep[2], true)
}

fun ContactPayload.toByteArray(): ByteArray {
    return "$nonce,$aud,$sub".toByteArray()
}
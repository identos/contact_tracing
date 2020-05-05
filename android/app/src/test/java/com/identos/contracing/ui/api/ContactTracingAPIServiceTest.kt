package com.identos.contracing.ui.api

import com.google.gson.GsonBuilder
import junit.framework.Assert.assertEquals
import junit.framework.Assert.assertTrue
import okhttp3.mockwebserver.MockResponse
import okhttp3.mockwebserver.MockWebServer
import org.junit.After
import org.junit.Before
import org.junit.Test
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.net.HttpURLConnection

class ContactTracingAPIServiceTest {

    private var mockWebServer = MockWebServer()
    private lateinit var contactTracingAPI: ContactTracingAPIService.ContactTracingAPI;
    private lateinit var contactTracingAPIService: ContactTracingAPIService;

    @Before
    fun setup(){
        val gson = GsonBuilder()
                .setLenient()
                .create()

        contactTracingAPI = Retrofit.Builder()
                .baseUrl(mockWebServer.url("/"))
                .addConverterFactory(GsonConverterFactory.create(gson))
                .build().create(ContactTracingAPIService.ContactTracingAPI::class.java)

//        contactTracingAPIService  = ContactTracingAPIService(contactTracingAPI, Settings())
    }

    @After
    fun teardown() {
        mockWebServer.shutdown()
    }

    @Test
    fun registerDevice() {
        val response = MockResponse()
                .setResponseCode(HttpURLConnection.HTTP_OK)
                .setBody("{\n" +
                        "  \"identifier\": \"test-identifier\",\n" +
                        "  \"iat\": \"test-phone\"\n" +
                        "}")
        val requestBody = ContactTracingAPIService.RequestBody("test-phone","test-identifier")
        mockWebServer.enqueue(response)

        val registrationResponse = contactTracingAPI.registerDevice("test-key", requestBody).execute();

        assertTrue(registrationResponse.isSuccessful)
        assertEquals("test-identifier", registrationResponse.body().uuid)
        assertEquals("test-phone", registrationResponse.body().iat)

    }

    @Test
    fun confirmDeviceRegistration() {
        val response = MockResponse()
                .setResponseCode(HttpURLConnection.HTTP_OK)
                .setBody("{\"user-code\": \"test-otp\"}")
        mockWebServer.enqueue(response)
        val conirmReqResponse = contactTracingAPI.confirmDeviceRegistration("test-key",
                "test-uuid", ContactTracingAPIService.ConfirmationRequestBody("test-otp"))
                .execute();
        assertTrue(conirmReqResponse.isSuccessful)

    }
}
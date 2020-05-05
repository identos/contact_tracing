var twilioClient = require('twilio')(process.env["TWILIO_ACCOUNT_SID"], process.env["TWILIO_AUTH_TOKEN"]);

module.exports = async function (context, message) {
    context.log('JavaScript queue trigger function processed work item', message);
    // OR access using context.bindings.<name>
    // context.log('Node.js queue trigger function processed work item', context.bindings.queueItem);
    context.log('expirationTime =', context.bindingData.expirationTime);
    context.log('insertionTime =', context.bindingData.insertionTime);
    context.log('nextVisibleTime =', context.bindingData.nextVisibleTime);
    context.log('id =', context.bindingData.id);
    context.log('popReceipt =', context.bindingData.popReceipt);
    context.log('dequeueCount =', context.bindingData.dequeueCount);

    // get the phone number from the queue message
    var phone = message.phone;

    // send the Verify SMS to the phone number (including country code)
    twilioClient.verify.services(process.env["TWILIO_VERIFY_SERVICE_SID"])
        .verifications
        .create({to: '+' + phone, channel: 'sms'})
        .then(verification => console.log(verification.status));

    // TODO - handle failed Twilio send, and therefore do not close the item context

    context.done();
};
var twilioClient = require('twilio')(process.env["TWILIO_ACCOUNT_SID"], process.env["TWILIO_AUTH_TOKEN"]);

module.exports = async function (context, req) {
    context.log('Devices Confirm HTTP trigger function processed a request.');

    let phone = (req.body && req.body.phone) ? req.body.phone : null;
    let otp = (req.body && req.body.user_code) ? req.body.user_code : null;
    let identifier = context.bindingData.identifier;

    if (!identifier || !phone || !otp) {
        // context.log('phone', phone);
        // context.log('otp', otp);
        // context.log('identifier', identifier);

        return {
            status: 400,
            body: {
                error: "Please provide all required variables, per API specifications"
            }
        };
    }

    // check phone format -- (country code, 1)(area code, 3)(phone, 7)
    // TODO
    // TODO: make country list configurable? or allow passthrough?

    // check otp format -- 6 digits
    // TODO
    // TODO: make format regexp configurable?

    // Find the identifier in DB -- Azure Cosmos DB
    // TODO

    // send the Verify SMS to the phone number (including country code)
    try {
        var twilioRes = await twilioClient.verify.services(process.env["TWILIO_VERIFY_SERVICE_SID"])
            .verificationChecks
            .create({to: '+' + phone, code: otp});
    } catch(err) {
        context.log('twilioClient error', err);
        return {
            status: (err.status) ? err.status : 500,
            body: {
                error: (err.detail) ? err.detail : ''
            }
        }
    }
    
    context.log('twilioRes', twilioRes.status);

    if(twilioRes.status == 'approved') {
        // output status and response
        return {
            status: 204
        };
    } else if(twilioRes.status == 'pending') {
        // output status and response
        return {
            status: 400,
            body: {
                error: "Phone and User Code do not match"
            }
        };
    } else {
        return {
            status: 400,
            body: {
                error: "Something went wrong"
            }
        };
    }

    /*
    // send the Verify SMS to the phone number (including country code)
    twilioClient.verify.services(process.env["TWILIO_VERIFY_SERVICE_SID"])
        .verificationChecks
        .create({to: '+' + phone, code: otp})
        .then(verification_check => {
            context.log(verification_check.status);
            if(verification_check.status == 'approved') {
                // output status and response
                context.res = {
                    status: 204,
                    body: {}
                };
                context.done();
            } else if(verification_check.status == 'pending') {
                // output status and response
                context.res = {
                    status: 400,
                    body: {
                        error: "Phone and User Code do not match"
                    }
                };
                context.done();
            } else {
                context.res = {
                    status: 400,
                    body: {
                        error: "Something went wrong"
                    }
                };
                context.done();
            }
        });
    // TODO - handle failed Twilio send, and therefore do not close the item context
    */

};

// function twilioVerify(phone, code, log) {
//     try {
//         return twilioClient.verify.services(process.env["TWILIO_VERIFY_SERVICE_SID"])
//             .verificationChecks
//             .create({to: '+' + phone, code: code});
//     } catch (error) {
//         log('twilioVerify catch error:', error);
//         throw error;
//     }
// }

// Reference for Azure Promises handling
// https://github.com/Azure/Azure-Functions/issues/431
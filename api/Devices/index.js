module.exports = async function (context, req) {
    context.log('Devices HTTP trigger function processed a request.');

    var phone = (req.body && req.body.phone) ? req.body.phone : null;
    var uuid = (req.body && req.body.identifier) ? req.body.identifier : null;

    if (!phone || !uuid) {
        context.res = {
            status: 400,
            body: {
                error: "Please provide all required variables, per API specifications"
            }
        };
        context.done();
    }

    // check phone format -- (country code, 1)(area code, 3)(phone, 7)
    // TODO

    // check uuid format -- what type of format do we expect from devices?
    // TODO

    // Save the (new) device to DB -- Azure Cosmos DB
    // TODO

    // Place the (new) device on the SMS Queue
    context.bindings.sms = {
        uuid: uuid,
        phone: phone
    };
    // TODO - error handling if queue write fails

    // output status and response
    context.res = {
        // status: 200, /* Defaults to 200 */
        body: {
            "identifier": uuid,
            "iat": Date.now()
        }
    };
};
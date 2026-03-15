const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB({ region: "eu-central-1", apiVersion: "2012-08-10" });

exports.handler = (event, context, callback) => {
    const params = { TableName: "lp-dev-lab1-authors" };
    dynamodb.scan(params, (err, data) => {
        if (err) callback(err);
        else {
            const authors = data.Items.map(item => ({
                id: item.id.S,
                firstName: item.firstName.S,
                lastName: item.lastName.S
            }));
            callback(null, authors);
        }
    });
};
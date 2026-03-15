const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB({ region: "eu-central-1", apiVersion: "2012-08-10" });

exports.handler = (event, context, callback) => {
    const params = {
        TableName: "lp-dev-lab1-courses",
        Key: { id: { S: event.id } }
    };
    dynamodb.deleteItem(params, (err, data) => {
        if (err) callback(err || null, data);
    });
};
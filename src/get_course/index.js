const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB({ region: "eu-central-1", apiVersion: "2012-08-10" });

exports.handler = (event, context, callback) => {
    const params = {
        TableName: "lp-dev-lab1-courses",
        Key: { id: { S: event.id } }
    };
    dynamodb.getItem(params, (err, data) => {
        if (err) callback(err);
        else callback(null, {
            id: data.Item.id.S,
            title: data.Item.title.S,
            watchHref: data.Item.watchHref.S,
            authorId: data.Item.authorId.S,
            length: data.Item.length.S,
            category: data.Item.category.S
        });
    });
};
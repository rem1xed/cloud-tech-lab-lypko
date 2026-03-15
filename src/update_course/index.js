const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient, PutCommand } = require("@aws-sdk/lib-dynamodb");

const client = new DynamoDBClient({ region: "eu-central-1" });
const docClient = DynamoDBDocumentClient.from(client);

exports.handler = async (event) => {
    const item = {
        id: event.id,
        title: event.title,
        watchHref: event.watchHref,
        authorId: event.authorId,
        length: event.length,
        category: event.category
    };

    const command = new PutCommand({
        TableName: process.env.COURSES_TABLE,
        Item: item
    });

    try {
        await docClient.send(command);
        return item;
    } catch (err) {
        return err;
    }
};
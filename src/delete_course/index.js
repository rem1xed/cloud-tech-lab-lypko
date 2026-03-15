const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient, DeleteCommand } = require("@aws-sdk/lib-dynamodb");

const client = new DynamoDBClient({ region: "eu-central-1" });
const docClient = DynamoDBDocumentClient.from(client);

exports.handler = async (event) => {
    const command = new DeleteCommand({
        TableName: process.env.COURSES_TABLE,
        Key: { id: event.id }
    });

    try {
        await docClient.send(command);
        return {};
    } catch (err) {
        return err;
    }
};
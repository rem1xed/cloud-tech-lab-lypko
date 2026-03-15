const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient, GetCommand } = require("@aws-sdk/lib-dynamodb");

const client = new DynamoDBClient({ region: "eu-central-1" });
const docClient = DynamoDBDocumentClient.from(client);

exports.handler = async (event) => {
    const command = new GetCommand({
        TableName: process.env.COURSES_TABLE,
        Key: { id: event.id }
    });

    try {
        const data = await docClient.send(command);
        return data.Item;
    } catch (err) {
        return err;
    }
};
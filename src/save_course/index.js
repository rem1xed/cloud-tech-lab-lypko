const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient, PutCommand } = require("@aws-sdk/lib-dynamodb");

const client = new DynamoDBClient({ region: "eu-central-1" });
const docClient = DynamoDBDocumentClient.from(client);

exports.handler = async (event) => {

    const data = event.body ? JSON.parse(event.body) : event;

    const id = data.title.replace(/\s+/g, '-').toLowerCase();
    
    const item = {
        id: id,
        title: data.title,
        watchHref: `http://www.pluralsight.com/courses/${id}`,
        authorId: data.authorId,
        length: data.length,
        category: data.category
    };

    const command = new PutCommand({
        TableName: process.env.COURSES_TABLE,
        Item: item
    });

    try {
        await docClient.send(command);
        // 3. Правильний формат відповіді для API Gateway
        return {
            statusCode: 201,
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(item)
        };
    } catch (err) {
        return {
            statusCode: 500,
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ error: err.message })
        };
    }
};
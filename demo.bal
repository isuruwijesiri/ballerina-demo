import ballerina/http;
import ballerina/email;

listener http:Listener endpoint = new(9090);

email:SmtpConfiguration smtpConfig = {
    port: 465,
    security: "START_TLS_AUTO"
};

email:SmtpClient smtpClient = check new ("smtp.mailtrap.io","82053141012a87", "0d3a68bf2d3467", smtpConfig);

service http:Service /mail on endpoint {

    resource function get send(string id) returns string|error {

        http:Client httpClient = check new ("https://my-json-server.typicode.com/IsuruMaduranga/mock-rest");

        json user = check httpClient->get("/users/" + id);
        string email_address = check user.email;
        string todo = check user.todo;
        string name = check user.name;

        string msg = "Hello " + name + "!\nYour todos are.....\n\n" + todo;
        
        email:Message email = {
            to: [email_address],
            cc: [],
            bcc: [],

            subject: "Your Todos",
            body: msg,
            'from: "from@example.com",
            sender: "from@example.com",
            replyTo: []
        };

        check smtpClient->sendMessage(email);

        return "Email Sent Successfully to " + email_address + "!\n";
    }
    
}

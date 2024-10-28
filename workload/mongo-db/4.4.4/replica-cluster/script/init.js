try {
    var status = rs.status();
    printjson(status);
    print("Replica set is already created.");
} catch (e) {
    if (e.codeName === "NotYetInitialized") {
        // The replica set is not yet initiated
        print("Replica set is not yet initiated. Initiating now...");

        var rsConfig = {
            _id: "main",
            members: [
                { _id: 1, host: "mongo-db-1:7000" },
                { _id: 2, host: "mongo-db-2:7000" },
                { _id: 3, host: "mongo-db-3:7000" }
            ]
        };

        // Initiate the replica set
        rs.initiate(rsConfig);

        // Confirm replica set initiation
        var newStatus = rs.status();
        printjson(newStatus);
    } else {
        // Other errors
        print("An unexpected error occurred: " + e);
    }
}

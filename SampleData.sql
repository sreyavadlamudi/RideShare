
INSERT INTO User (UserID, UserType, Name, Email, Password, Rating) VALUES
    (1, 'Driver', 'Zakari Clark', 'zclark@gmail.com', 'password123', 4.6),
    (2, 'Rider', 'Sreya Vadlamudi', 'svadlamudi@gmail.com', 'password456', 4.5),
    (3, 'Driver', 'Brynn McGovern', 'bMcGovern@gmail.com', 'password789', 4.3),
    (4, 'Rider', 'Saniya Revankar', 'srevankar@gmail.com', 'password149', 4.4);


INSERT INTO Driver (DriverID, UserID, DriverMode) VALUES
    (1, 1, 1),
    (2, 3, 0);

INSERT INTO Rider (RiderID, UserID) VALUES
    (2, 2),
    (4, 4);


INSERT INTO Ride (RideID, DriverID, RiderID, PickUpLocation, DropOffLocation, Rating) VALUES
    (1, 1, 2, 'Location 1', 'Location 2', 4.3),
    (2, 3, 4, 'Location 3', 'Location 4', 4.1),
    (3, 1, 4, 'Location 5', 'Location 6', 4.4),
    (4, 3, 2, 'Location 2', 'Location 1', 4.8);

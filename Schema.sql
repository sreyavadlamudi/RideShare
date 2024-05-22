
CREATE TABLE User (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    UserType ENUM('Driver', 'Rider'),
    Name VARCHAR(255),
    Email VARCHAR(255),
    Password VARCHAR(255),
    Rating DECIMAL(3, 2)
);


CREATE TABLE Driver (
    DriverID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    DriverMode TINYINT NOT NULL DEFAULT 0,
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);


CREATE TABLE Rider (
    RiderID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    FOREIGN KEY (UserID) REFERENCES User(UserID)
);


CREATE TABLE Ride (
    RideID INT AUTO_INCREMENT PRIMARY KEY,
    DriverID INT,
    RiderID INT,
    PickUpLocation VARCHAR(255),
    DropOffLocation VARCHAR(255),
    Rating DECIMAL(3, 2)
);

SampleData.sql:

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

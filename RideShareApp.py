import mysql.connector

# Establish the database connection
conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="CPSC408!",
    database="RideShare"  
)

def create_user(conn):
    print("You are a new user. Let's create your account.")
    name = input("Enter your name: ")
    email = input("Enter your email: ")
    password = input("Enter your password: ")
    user_type = input("Are you a 'Driver' or 'Rider'? Enter your user type: ")

    cursor = conn.cursor()

    # Insert user data into the User table
    insert_user_query = "INSERT INTO User (Name, Email, Password, UserType) VALUES (%s, %s, %s, %s)"
    cursor.execute(insert_user_query, (name, email, password, user_type))
    conn.commit()

    user_id = cursor.lastrowid  # Get the User ID

    if user_type == "Driver":
        # If the user is a driver, insert data into the Driver table
        insert_driver_query = "INSERT INTO Driver (UserID) VALUES (%s)"
        cursor.execute(insert_driver_query, (user_id,))
    elif user_type == "Rider":
        # If the user is a rider, insert data into the Rider table
        insert_rider_query = "INSERT INTO Rider (UserID) VALUES (%s)"
        cursor.execute(insert_rider_query, (user_id,))

    conn.commit()
    print(f"Account created successfully! Your User ID is: {user_id}")

def returning_user(conn):
    print("You are a returning user.")
    user_id = input("Enter your User ID: ")
    cursor = conn.cursor()

    # Check if the user exists and retrieve their user type
    check_user_query = "SELECT UserType FROM User WHERE UserID = %s"
    cursor.execute(check_user_query, (user_id,))
    user_data = cursor.fetchone()

    if user_data:
        user_type = user_data[0]
        if user_type == "Driver":
            print("Welcome back, Driver!")
            driver_options(conn, user_id)
        elif user_type == "Rider":
            print("Welcome back, Rider!")
            rider_options(conn, user_id)
        else:
            print("Invalid user type.")
    else:
        print("User with the specified User ID does not exist.")

# Driver Options
def view_driver_rating(conn, driver_id):
    cursor = conn.cursor()

    # Retrieve the driver's rating from the User table
    get_driver_rating_query = "SELECT Rating FROM User WHERE UserID = %s"
    cursor.execute(get_driver_rating_query, (driver_id,))
    driver_rating = cursor.fetchone()

    if driver_rating:
        print(f"Your current driver rating is: {driver_rating[0]}")
    else:
        print("Driver not found or rating not available.")

def view_driver_rides(conn, driver_id):
    cursor = conn.cursor()

    # Query the Ride table to retrieve rides connected with the driver
    view_rides_query = "SELECT RideID, PickUpLocation, DropOffLocation, Rating FROM Ride WHERE DriverID = %s"
    cursor.execute(view_rides_query, (driver_id,))
    rides = cursor.fetchall()

    if not rides:
        print("You haven't driven any rides yet.")
    else:
        print("List of Rides You've Driven:")
        for ride in rides:
            ride_id, pickup_location, dropoff_location, rating = ride
            print(f"Ride ID: {ride_id}, Pick Up: {pickup_location}, Drop Off: {dropoff_location}, Rating: {rating}")

def activate_deactivate_driver_mode(conn, user_id):
    cursor = conn.cursor()

    # Check the current driver mode
    check_driver_mode_query = "SELECT DriverMode FROM Driver WHERE UserID = %s"
    cursor.execute(check_driver_mode_query, (user_id,))
    current_driver_mode = cursor.fetchone()

    if current_driver_mode:
        current_driver_mode = current_driver_mode[0]
        if current_driver_mode == 1:
            # Deactivate driver mode
            update_driver_mode_query = "UPDATE Driver SET DriverMode = 0 WHERE UserID = %s"
            cursor.execute(update_driver_mode_query, (user_id,))
            conn.commit()
            print("Driver mode deactivated.")
        elif current_driver_mode == 0:
            # Activate driver mode
            update_driver_mode_query = "UPDATE Driver SET DriverMode = 1 WHERE UserID = %s"
            cursor.execute(update_driver_mode_query, (user_id,))
            conn.commit()
            print("Driver mode activated.")
    else:
        print("User is not registered as a driver.")

    cursor.close()

def driver_options(conn, driver_id):
    while True:
        print("\nDriver Options:")
        print("1. View Rating")
        print("2. View Rides")
        print("3. Activate/Deactivate Driver Mode")
        print("4. Exit")

        choice = input("Enter your choice: ")

        if choice == "1":
            view_driver_rating(conn, driver_id)
        elif choice == "2":
            view_driver_rides(conn, driver_id)
        elif choice == "3":
            activate_deactivate_driver_mode(conn, driver_id)
        elif choice == "4":
            print("Exiting driver options.")
            break
        else:
            print("Invalid choice. Please enter a valid option.")

# Rider Options
def view_rides(conn, rider_id):
    cursor = conn.cursor()

    # Retrieve all rides connected with the rider
    view_rides_query = "SELECT RideID, DriverID, PickUpLocation, DropOffLocation, Rating FROM Ride WHERE RiderID = %s"
    cursor.execute(view_rides_query, (rider_id,))
    rider_rides = cursor.fetchall()

    if not rider_rides:
        print("You haven't taken any rides yet.")
    else:
        print("List of rides you've taken:")
        for ride in rider_rides:
            ride_id, driver_id, pickup_location, dropoff_location, rating = ride
            print(f"Ride ID: {ride_id}")
            print(f"Driver ID: {driver_id}")
            print(f"Pickup Location: {pickup_location}")
            print(f"Dropoff Location: {dropoff_location}")
            if rating is not None:
                print(f"Rating: {rating}")
            print("\n")

def find_driver(conn, rider_id):
    cursor = conn.cursor()

    # Check if the rider has any ongoing rides
    check_ongoing_rides_query = "SELECT RideID FROM Ride WHERE RiderID = %s AND Rating IS NULL"
    cursor.execute(check_ongoing_rides_query, (rider_id,))
    ongoing_ride = cursor.fetchone()

    if ongoing_ride:
        print("You already have an ongoing ride. Complete the current ride before finding a new one.")
        return

    # Get pick-up and drop-off locations from the rider
    pick_up_location = input("Enter the pick-up location: ")
    drop_off_location = input("Enter the drop-off location: ")

    # Find an available driver with an activated driver mode
    find_driver_query = "SELECT Driver.DriverID, User.Name " \
                        "FROM Driver " \
                        "JOIN User ON Driver.DriverID = User.UserID " \
                        "LEFT JOIN Ride ON Driver.DriverID = Ride.DriverID " \
                        "WHERE (Ride.RideID IS NULL OR Ride.Rating IS NOT NULL) " \
                        "AND Driver.DriverMode = 1 " \
                        "AND Driver.DriverID NOT IN (SELECT DriverID FROM Ride WHERE RiderID = %s AND Rating IS NULL) " \
                        "LIMIT 1"
    cursor.execute(find_driver_query, (rider_id,))
    driver_data = cursor.fetchone()

    if driver_data:
        driver_id, driver_name = driver_data

        # Create a new ride
        create_ride_query = "INSERT INTO Ride (DriverID, RiderID, PickUpLocation, DropOffLocation) " \
                            "VALUES (%s, %s, %s, %s)"
        cursor.execute(create_ride_query, (driver_id, rider_id, pick_up_location, drop_off_location))
        conn.commit()

        print(f"Ride created! You are matched with Driver {driver_name}.")
    else:
        print("No available drivers at the moment. Please try again later.")


def rider_options(conn, rider_id):
    while True:
        print("Rider Options:")
        print("1. View Rides")
        print("2. Find a driver")
        print("3. Rate my driver")
        print("4. Exit")

        choice = input("Enter your choice: ")

        if choice == "1":
            view_rides(conn, rider_id)
        elif choice == "2":
            find_driver(conn, rider_id)
        elif choice == "3":
            rate_my_driver(conn, rider_id)
        elif choice == "4":
            print("Goodbye!")
            break
        else:
            print("Invalid choice. Please select a valid option.")

def rate_my_driver(conn, rider_id):
    cursor = conn.cursor()

    # Find the last ride of the rider
    find_last_ride_query = "SELECT RideID, DriverID FROM Ride WHERE RiderID = %s ORDER BY RideID DESC LIMIT 1"
    cursor.execute(find_last_ride_query, (rider_id,))
    last_ride_data = cursor.fetchone()

    if last_ride_data:
        ride_id, driver_id = last_ride_data

        # Get the driver's name and rating
        get_driver_info_query = "SELECT User.Name, User.Rating FROM User JOIN Driver ON User.UserID = Driver.UserID WHERE Driver.DriverID = %s"
        cursor.execute(get_driver_info_query, (driver_id,))
        driver_info = cursor.fetchone()

        if driver_info:
            driver_name, driver_rating = driver_info
            print("Last Ride Information:")
            print(f"Ride ID: {ride_id}")
            print(f"Driver Name: {driver_name}")
            print(f"Driver Rating: {driver_rating}")

            # Confirm if the ride is correct
            confirm = input("Is this the correct ride to rate? (yes/no): ")

            if confirm.lower() == "yes":
                new_rating = float(input("Enter your rating for the driver (0.0 to 5.0): "))

                # Convert driver's rating to float and calculate the new rating
                driver_rating = float(driver_rating)
                updated_driver_rating = (driver_rating + new_rating) / 2

                # Update the driver's rating in the database
                update_driver_rating_query = "UPDATE User SET Rating = %s WHERE UserID = %s"
                cursor.execute(update_driver_rating_query, (updated_driver_rating, driver_id))
                conn.commit()
                print("Driver rating updated successfully.")
            else:
                print("Rating canceled. Please confirm the correct ride.")
        else:
            print("Driver information not found.")
    else:
        print("No previous rides found for this rider.")


def main():
    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="CPSC408!",
        database="RideShare"  
    )

    while True:
        print("Are you a new user or a returning user?")
        choice = input("Enter 'new' or 'return': ")

        if choice == 'new':
            create_user(conn)
        elif choice == 'return':
            returning_user(conn)
        else:
            print("Invalid choice. Please enter 'new' or 'return'.")

    conn.close()

if __name__ == "__main__":
    main()

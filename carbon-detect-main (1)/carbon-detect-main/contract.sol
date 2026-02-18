// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EmissionTracker {
    // --- Enums ---
    enum TransportCategory {Personal, Roadways, Railways, Airways}
    enum RoadwayType {Taxi, Bus, Auto}
    enum PersonalFuelType {Petrol, Diesel, CNG, Electricity}

    // --- Structs ---
    struct TripData {
        TransportCategory transportCategory;
        RoadwayType roadType; // Relevant for Roadways only
        PersonalFuelType personalFuelType; // Relevant for Personal only
        uint256 distance; // in kilometers
        uint256 co2Emitted; // in grams
    }

    // --- State Variables ---
    mapping(address => TripData[]) public userTrips;
    mapping(address => uint256) internal dailyEmissions;
    mapping(address => uint256) internal weeklyEmissions;
    mapping(address => uint256) internal monthlyEmissions;
    mapping(address => uint256) internal yearlyEmissions;

    mapping(address => uint256) public lastUserReset; // Daily
    mapping(address => uint256) private lastWeeklyReset;
    mapping(address => uint256) private lastMonthlyReset;
    mapping(address => uint256) private lastYearlyReset;

    // --- Emission Factors ---
    uint256 constant TAXI_EMISSION = 120;
    uint256 constant BUS_EMISSION = 80;
    uint256 constant AUTO_EMISSION = 100;
    uint256 constant RAIL_EMISSION = 50;
    uint256 constant AIR_EMISSION = 230;
    uint256 constant PETROL_EMISSION = 192; // Grams of CO2 per km for petrol vehicles
    uint256 constant DIESEL_EMISSION = 171; // Grams of CO2 per km for diesel vehicles
    uint256 constant CNG_EMISSION = 119; // Grams of CO2 per km for CNG vehicles
    uint256 constant ELECTRICITY_EMISSION = 50; // Grams of CO2 per km for electric vehicles (average grid electricity)

    // --- Events ---
    event TripEnded(
        address indexed user,
        TransportCategory transportCategory,
        uint8 roadType,
        uint8 personalFuelType,
        uint256 distance,
        uint256 co2Emitted 
    );

    event DailyEmissionsReset(address indexed user, uint256 previousEmissions);

    // --- Modifiers ---
    modifier validDistance(uint256 distance) {
        require(distance > 0, "Distance must be greater than 0");
        _;
    }

    // --- Internal Functions ---
    function _resetDailyEmissionsIfNeeded() internal {
        uint256 secondsInDay = 86400;
        uint256 currentDayMidnight = block.timestamp - (block.timestamp % secondsInDay);

        if (lastUserReset[msg.sender] < currentDayMidnight) {
            uint256 previousEmissions = dailyEmissions[msg.sender];
            dailyEmissions[msg.sender] = 0;
            lastUserReset[msg.sender] = currentDayMidnight;
            emit DailyEmissionsReset(msg.sender, previousEmissions);
        }
    }

    function _resetWeeklyEmissionsIfNeeded() internal {
        uint256 secondsInWeek = 7 * 86400;
        uint256 currentWeekStart = block.timestamp - (block.timestamp % secondsInWeek);
        if (lastWeeklyReset[msg.sender] < currentWeekStart) {
            weeklyEmissions[msg.sender] = 0;
            lastWeeklyReset[msg.sender] = currentWeekStart;
        }
    }

 function _resetMonthlyEmissionsIfNeeded() internal {
    uint256 secondsInDay = 86400;
    // Calculate the start of the current month (midnight of the 1st day)
    uint256 currentTime = block.timestamp;
    
    // Extract year, month, day components (simplified approach)
    uint256 timestamp = currentTime;
    
    uint256 SECONDS_IN_YEAR = 31536000; // 365 days
    uint256 SECONDS_IN_LEAP_YEAR = 31622400; // 366 days
    
    // Calculate year (approximate)
    uint256 year = 1970;
    while (timestamp > 0) {
        bool isLeapYear = ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0));
        uint256 secondsInCurrentYear = isLeapYear ? SECONDS_IN_LEAP_YEAR : SECONDS_IN_YEAR;
        
        if (timestamp >= secondsInCurrentYear) {
            timestamp -= secondsInCurrentYear;
            year++;
        } else {
            break;
        }
    }
    
    // Calculate month and day
    uint8[12] memory daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
        daysInMonth[1] = 29; // February in leap year
    }
    
    uint256 month = 0;
    for (uint256 i = 0; i < 12; i++) {
        uint256 secondsInMonth = uint256(daysInMonth[i]) * secondsInDay;
        if (timestamp >= secondsInMonth) {
            timestamp -= secondsInMonth;
            month++;
        } else {
            break;
        }
    }
    
    // Calculate the start of the current month
    uint256 currentMonthStart = currentTime - timestamp;
    
    if (lastMonthlyReset[msg.sender] < currentMonthStart) {
        monthlyEmissions[msg.sender] = 0;
        lastMonthlyReset[msg.sender] = currentMonthStart;
    }
}


function _resetYearlyEmissionsIfNeeded() internal {
    // Calculate the start of the current year (midnight of January 1st)
    uint256 currentTime = block.timestamp;
    
    // Extract year component
    uint256 timestamp = currentTime;
    uint256 SECONDS_IN_YEAR = 31536000; // 365 days
    uint256 SECONDS_IN_LEAP_YEAR = 31622400; // 366 days
    
    // Calculate year (approximate)
    uint256 year = 1970;
    uint256 accumulatedTime = 0;
    
    while (true) {
        bool isLeapYear = ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0));
        uint256 secondsInCurrentYear = isLeapYear ? SECONDS_IN_LEAP_YEAR : SECONDS_IN_YEAR;
        
        if (accumulatedTime + secondsInCurrentYear > timestamp) {
            break;
        }
        
        accumulatedTime += secondsInCurrentYear;
        year++;
    }
    
    uint256 currentYearStart = currentTime - (timestamp - accumulatedTime);
    
    if (lastYearlyReset[msg.sender] < currentYearStart) {
        yearlyEmissions[msg.sender] = 0;
        lastYearlyReset[msg.sender] = currentYearStart;
    }
}


    function _resetEmissionsIfNeeded() internal {
        _resetDailyEmissionsIfNeeded();
        _resetWeeklyEmissionsIfNeeded();
        _resetMonthlyEmissionsIfNeeded();
        _resetYearlyEmissionsIfNeeded();
    }

    // --- Public Functions ---
    function recordPersonalVehicleTrip(uint8 personalFuelType, uint256 distance)
        external
        validDistance(distance)
    {
        require(personalFuelType <= uint8(PersonalFuelType.Electricity), "Invalid fuel type");

        _resetEmissionsIfNeeded();

        uint256 emissionFactor;
        if (PersonalFuelType(personalFuelType) == PersonalFuelType.Petrol) {
            emissionFactor = PETROL_EMISSION;
        } else if (PersonalFuelType(personalFuelType) == PersonalFuelType.Diesel) {
            emissionFactor = DIESEL_EMISSION;
        } else if (PersonalFuelType(personalFuelType) == PersonalFuelType.CNG) {
            emissionFactor = CNG_EMISSION;
        } else if (PersonalFuelType(personalFuelType) == PersonalFuelType.Electricity) {
            emissionFactor = ELECTRICITY_EMISSION;
        }

        uint256 co2Emitted = distance * emissionFactor;

        userTrips[msg.sender].push(TripData({
            transportCategory: TransportCategory.Personal,
            roadType: RoadwayType.Taxi, // Not relevant for personal vehicles
            personalFuelType: PersonalFuelType(personalFuelType),
            distance: distance,
            co2Emitted: co2Emitted
        }));

        dailyEmissions[msg.sender] += co2Emitted;
        weeklyEmissions[msg.sender] += co2Emitted;
        monthlyEmissions[msg.sender] += co2Emitted;
        yearlyEmissions[msg.sender] += co2Emitted;

        emit TripEnded(msg.sender, TransportCategory.Personal, 0, personalFuelType, distance, co2Emitted);
    }

    function recordRoadwaysTrip(uint8 roadType, uint256 distance) external validDistance(distance) {
        require(roadType <= uint8(RoadwayType.Auto), "Invalid roadway type");

        _resetEmissionsIfNeeded();

        uint256 emissionFactor;
        if (RoadwayType(roadType) == RoadwayType.Taxi) {
            emissionFactor = TAXI_EMISSION;
        } else if (RoadwayType(roadType) == RoadwayType.Bus) {
            emissionFactor = BUS_EMISSION;
        } else if (RoadwayType(roadType) == RoadwayType.Auto) {
            emissionFactor = AUTO_EMISSION;
        }

        uint256 co2Emitted = distance * emissionFactor;

        userTrips[msg.sender].push(TripData({
            transportCategory: TransportCategory.Roadways,
            roadType: RoadwayType(roadType),
            personalFuelType: PersonalFuelType.Petrol, // Not relevant for roadways
            distance: distance,
            co2Emitted: co2Emitted
        }));

        dailyEmissions[msg.sender] += co2Emitted;
        weeklyEmissions[msg.sender] += co2Emitted;
        monthlyEmissions[msg.sender] += co2Emitted;
        yearlyEmissions[msg.sender] += co2Emitted;

        emit TripEnded(msg.sender, TransportCategory.Roadways, roadType, 0, distance, co2Emitted);
    }

    function recordRailwaysTrip(uint256 distance) external validDistance(distance) {
        _resetEmissionsIfNeeded();

        uint256 co2Emitted = distance * RAIL_EMISSION;

        userTrips[msg.sender].push(TripData({
            transportCategory: TransportCategory.Railways,
            roadType: RoadwayType.Taxi, // Dummy
            personalFuelType: PersonalFuelType.Petrol, // Not relevant for railways
            distance: distance,
            co2Emitted: co2Emitted
        }));

        dailyEmissions[msg.sender] += co2Emitted;
        weeklyEmissions[msg.sender] += co2Emitted;
        monthlyEmissions[msg.sender] += co2Emitted;
        yearlyEmissions[msg.sender] += co2Emitted;

        emit TripEnded(msg.sender, TransportCategory.Railways, 0, 0, distance, co2Emitted);
    }

    function recordAirwaysTrip(uint256 distance) external validDistance(distance) {
        _resetEmissionsIfNeeded();

        uint256 co2Emitted = distance * AIR_EMISSION;

        userTrips[msg.sender].push(TripData({
            transportCategory: TransportCategory.Airways,
            roadType: RoadwayType.Taxi, // Dummy
            personalFuelType: PersonalFuelType.Petrol, // Not relevant for airways
            distance: distance,
            co2Emitted: co2Emitted
        }));

        dailyEmissions[msg.sender] += co2Emitted;
        weeklyEmissions[msg.sender] += co2Emitted;
        monthlyEmissions[msg.sender] += co2Emitted;
        yearlyEmissions[msg.sender] += co2Emitted;

        emit TripEnded(msg.sender, TransportCategory.Airways, 0, 0, distance, co2Emitted);
    }

    // --- Getter Functions ---
    function getDailyEmissions(address user) external view returns (uint256) {
        return dailyEmissions[user];
    }

    function getWeeklyEmissions(address user) external view returns (uint256) {
        return weeklyEmissions[user];
    }

    function getMonthlyEmissions(address user) external view returns (uint256) {
        return monthlyEmissions[user];
    }

    function getYearlyEmissions(address user) external view returns (uint256) {
        return yearlyEmissions[user];
    }

    function getTripCount(address user) external view returns (uint256) {
        return userTrips[user].length;
    }

    function getTripData(address user, uint256 index)
        external
        view
        returns (
            TransportCategory,
            uint8,
            uint8,
            uint256,
            uint256
        )
    {
        require(index < userTrips[user].length, "Index out of bounds");
        TripData memory trip = userTrips[user][index];
        return (
            trip.transportCategory,
            uint8(trip.roadType),
            uint8(trip.personalFuelType),
            trip.distance,
            trip.co2Emitted
        );
    }
}

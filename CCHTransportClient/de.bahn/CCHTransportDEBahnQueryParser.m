//
//  CCHTransportDEBahnQueryParser.m
//  Departures
//
//  Created by Claus Höfele on 23.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportDEBahnQueryParser.h"

#import "CCHTransportDEBahnClient.h"
#import "CCHTransportDEBahnClientUtils.h"
#import "CCHTransportTrip.h"
#import "CCHTransportTripLeg.h"
#import "CCHTransportLocation.h"
#import "CCHTransportStation.h"
#import "CCHTransportService.h"
#import "CCHTransportEvent.h"
#import "CCHTransportDEBahnQueryNextGenerator.h"

#import <GZIP/GZIP.h>
#import <CCHBinaryData/CCHBinaryData.h>

NSString * const CCHTransportDEBahnQueryParserResultTripsKey = @"trips";
NSString * const CCHTransportDEBahnQueryParserResultContextKey = @"context";
NSString * const CCHTransportDEBahnQueryParserResultErrorKey = @"error";

@interface CCHTransportDEBahnQueryParser()

@property (nonatomic) CCHBinaryDataReader *binaryDataReader;
@property (nonatomic) CCHBinaryDataReader *stringsBinaryDataReader;
@property (nonatomic) CCHBinaryDataReader *stationsBinaryDataReader;
@property (nonatomic) int serviceDaysTablePointer;
@property (nonatomic) int disruptionsPointer;
@property (nonatomic) int tripDetailsPointer;
@property (nonatomic) short tripDetailsIndexOffset;
@property (nonatomic) short tripDetailsLegOffset;
@property (nonatomic) short tripDetailsLegSize;
@property (nonatomic) short tripDetailsOffset;
@property (nonatomic) short intermediateStopsSize;
@property (nonatomic) short intermediateStopsOffset;
@property (nonatomic) int attributesPointer;
@property (nonatomic) NSStringEncoding stringEncoding;
@property (nonatomic) NSDate *resDate;

@end

@implementation CCHTransportDEBahnQueryParser

- (NSDictionary *)parseResponseWithData:(NSData *)data
{
    data = [data gunzippedData];
    
    NSDictionary *result;
    if (data == nil) {
        NSError *error = [self.class errorWithMessage:@"Invalid data"];
        result = @{CCHTransportDEBahnQueryParserResultErrorKey: error};
    } else {
        CCHBinaryDataReader *binaryDataReader = [[CCHBinaryDataReader alloc] initWithData:data options:0];
        self.binaryDataReader = binaryDataReader;
        
        [binaryDataReader reset];
        short version = [self.binaryDataReader readShort];
        (void)version;
        NSAssert(version == 6 || version == 5, @"Invalid version");

        self.stringEncoding = NSASCIIStringEncoding;
        [binaryDataReader setNumberOfBytesRead:0x20];
        self.serviceDaysTablePointer = [binaryDataReader readInt];
        int stringsTablePointer = [binaryDataReader readInt];
        self.stringsBinaryDataReader = [self.class binaryDataReaderForData:data withOffset:stringsTablePointer length:self.serviceDaysTablePointer - stringsTablePointer];

        [binaryDataReader setNumberOfBytesRead:0x36];
        int stationTablePointer = [binaryDataReader readInt];
        int commentTablePointer = [binaryDataReader readInt];
        self.stationsBinaryDataReader = [self.class binaryDataReaderForData:data withOffset:stationTablePointer length:commentTablePointer - stationTablePointer];

        [binaryDataReader setNumberOfBytesRead:0x46];
        int extensionHeaderPointer = [binaryDataReader readInt];

        [binaryDataReader setNumberOfBytesRead:extensionHeaderPointer];
        [binaryDataReader skipNumberOfBytes:4]; // extensionHeaderLength
        [binaryDataReader skipNumberOfBytes:12];
        short errorCode = [binaryDataReader readShort];
        [binaryDataReader setNumberOfBytesRead:extensionHeaderPointer + 0x8];
        short sequenceNumber = [binaryDataReader readShort];
        
        if (errorCode != 0) {
            NSError *error = [self.class errorForErrorCode:errorCode];
            result = @{CCHTransportDEBahnQueryParserResultErrorKey: error};
        } else if (sequenceNumber <= 0) {
            NSError *error = [self.class errorWithMessage:@"Invalid sequence number"];
            result = @{CCHTransportDEBahnQueryParserResultErrorKey: error};
        } else {
            NSString *requestID = [self readString];
            self.tripDetailsPointer = [binaryDataReader readInt];
            NSAssert(self.tripDetailsPointer != 0, @"No connection details");
            
            [binaryDataReader skipNumberOfBytes:4];
            self.disruptionsPointer = [binaryDataReader readInt];
            [binaryDataReader skipNumberOfBytes:8];
            
            NSString *charset = [self readString];
            CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)charset);
            self.stringEncoding = CFStringConvertEncodingToNSStringEncoding(encoding);
            NSAssert(encoding != kCFStringEncodingInvalidId, @"Invalid encoding");
            
            NSString *ld = [self readString];
            self.attributesPointer = [binaryDataReader readInt];
            
            [binaryDataReader setNumberOfBytesRead:self.tripDetailsPointer];
            short tripDetailsVersion = [binaryDataReader readShort];
            (void)tripDetailsVersion;
            NSAssert(tripDetailsVersion == 1, @"Unknown trip details version");
            [binaryDataReader skipNumberOfBytes:0x02];
            self.tripDetailsIndexOffset = [binaryDataReader readShort];
            self.tripDetailsLegOffset = [binaryDataReader readShort];
            self.tripDetailsLegSize = [binaryDataReader readShort];
            self.intermediateStopsSize = [binaryDataReader readShort];
            self.intermediateStopsOffset = [binaryDataReader readShort];
            NSAssert(self.intermediateStopsSize == 26, @"Invalid stops size");
            
            [binaryDataReader reset];
            [binaryDataReader skipNumberOfBytes:0x02];
            [binaryDataReader skipNumberOfBytes:0x0E];  // resDeparture
            [binaryDataReader skipNumberOfBytes:0x0E];  // resArrival
            
            short numTrips = [binaryDataReader readShort];
            
            [binaryDataReader skipNumberOfBytes:0x08];
            self.resDate = [self readDate];
            
            NSMutableArray *trips = [NSMutableArray array];
            for (short tripIndex = 0; tripIndex < numTrips; tripIndex++) {
                [binaryDataReader setNumberOfBytesRead:0x4a + tripIndex * 12];
                
                CCHTransportTrip *trip = [self readTripWithIndex:tripIndex];
                [trips addObject:trip];
            }
            
            NSString *context;
            if (![self.class tripsContainSingleWalk:trips]) {
                context = [CCHTransportDEBahnQueryNextGenerator generateContextWithRequestID:requestID sequenceNumber:sequenceNumber ld:ld];
            }
            
            result = context ? @{CCHTransportDEBahnQueryParserResultTripsKey: trips, CCHTransportDEBahnQueryParserResultContextKey: context} : @{CCHTransportDEBahnQueryParserResultTripsKey: trips};
        }
    }
    
    return result;
}

+ (BOOL)tripsContainSingleWalk:(NSArray *)trips {
    BOOL tripsContainSingleWalk = NO;

    // If the only trip is a walk, there's no context for next request
    if (trips.count == 1) {
        CCHTransportTrip *trip = trips.firstObject;
        if (trip.legs.count == 1) {
            CCHTransportTripLeg *leg = trip.legs.firstObject;
            tripsContainSingleWalk = (leg.service.transportMode == CCHTransportServiceModePedestrian);
        }
    }
    
    return tripsContainSingleWalk;
}

- (CCHTransportTrip *)readTripWithIndex:(short)index
{
    CCHBinaryDataReader *binaryDataReader = self.binaryDataReader;

    short serviceDaysTableOffset = [binaryDataReader readShort];
    int tripLegsOffset = [binaryDataReader readInt];
    short numTripLegs = [binaryDataReader readShort];
    /*short numChanges = */[binaryDataReader readShort];
    
    [binaryDataReader setNumberOfBytesRead:self.serviceDaysTablePointer + serviceDaysTableOffset];
    short tripDayOffset = [self readTripDayOffset];
    
    [binaryDataReader setNumberOfBytesRead:self.tripDetailsPointer + self.tripDetailsIndexOffset + index * 2];
    self.tripDetailsOffset = [binaryDataReader readShort];
    
    NSMutableArray *tripLegs = [NSMutableArray array];
    CCHTransportTripLeg *previousTripLeg;
    for (short tripLegIndex = 0; tripLegIndex < numTripLegs; tripLegIndex++) {
        [binaryDataReader setNumberOfBytesRead:0x4a + tripLegsOffset + tripLegIndex * 20];
        
        CCHTransportTripLeg *tripLeg = [self readTripLegWithIndex:tripLegIndex tripDayOffset:tripDayOffset tripIndex:index];
        if (previousTripLeg.service.transportMode == CCHTransportServiceModePedestrian && tripLeg.service.transportMode == CCHTransportServiceModePedestrian) {
            // Coalesce adjacent walks into one
            NSArray *stops = @[previousTripLeg.stops.firstObject, tripLeg.stops.lastObject];
            CCHTransportTripLeg *updatedTripLeg = [[CCHTransportTripLeg alloc] initWithDeparture:previousTripLeg.departure arrival:tripLeg.arrival service:tripLeg.service stops:stops];
            [tripLegs removeObject:previousTripLeg];
            [tripLegs addObject:updatedTripLeg];
        } else {
            [tripLegs addObject:tripLeg];
        }
        
        previousTripLeg = tripLeg;
    }
    
    CCHTransportTrip *trip = [[CCHTransportTrip alloc] initWithLegs:tripLegs];
    return trip;
}

- (CCHTransportTripLeg *)readTripLegWithIndex:(short)tripLegIndex tripDayOffset:(short)tripDayOffset tripIndex:(short)tripIndex
{
    CCHBinaryDataReader *binaryDataReader = self.binaryDataReader;

    // Departure/arrival time
    NSDate *departureDate = [self readDateWithBaseDate:self.resDate dayOffset:tripDayOffset];
    CCHTransportLocation *departureLocation = [self readLocation];
    NSDate *arrivalDate = [self readDateWithBaseDate:self.resDate dayOffset:tripDayOffset];
    CCHTransportLocation *arrivalLocation = [self readLocation];
    short type = [binaryDataReader readShort];
    
    // Transport name
    NSString *serviceName = [self readString];
    serviceName = [serviceName stringByReplacingOccurrencesOfString:@"Fussweg" withString:@"Fußweg"];
    serviceName = [CCHTransportDEBahnClientUtils normalizeWhiteSpaceForString:serviceName];
    
    // Departure/arrival platform
    NSString *departurePlatform = [self readPlatform];
    NSString *arrivalPlatform = [self readPlatform];
    
    // Attributes
    NSInteger transportClass = 0;
    NSString *serviceDirectionName;
    short legAttributeIndex = [binaryDataReader readShort];
    [binaryDataReader setNumberOfBytesRead:self.attributesPointer + legAttributeIndex * 4];
    while (YES) {
        short attributeKeyOffset = [binaryDataReader readShort];
        if (attributeKeyOffset == 0) {
            break;
        } else {
            [self.stringsBinaryDataReader setNumberOfBytesRead:attributeKeyOffset];
            NSString *attributeKey = [self.stringsBinaryDataReader readNullTerminatedStringWithEncoding:self.stringEncoding];
            NSString *attributeValue = [self readString];
            
            if ([attributeKey isEqualToString:@"Direction"]) {
                serviceDirectionName = [attributeValue isEqualToString:@"---"] ? nil : attributeValue;
            } else if ([attributeKey isEqualToString:@"Class"]) {
                transportClass = attributeValue.integerValue;
            }
        }
    }
    
    // Transport category
    CCHTransportServiceMode transportMode;
    if (type == 1 /* Fußweg */|| type == 3 /* Übergang */|| type == 4 /* Übergang */) {
        transportMode = CCHTransportServiceModePedestrian;
    } else if (type == 2) {
        transportMode = [self.class transportModeForTransportClass:transportClass];
        NSAssert(transportMode != CCHTransportServiceModeUnknown, @"Unknown transport mode");
    } else {
        NSAssert(NO, @"Invalid trip leg type");
        transportMode = CCHTransportServiceModeUnknown;
    }
    
    CCHTransportService *service = [[CCHTransportService alloc] initWithName:serviceName transportMode:transportMode directionName:serviceDirectionName direction:CCHTransportServiceDirectionUnknown];

    // Departure/arrival delays
    [binaryDataReader setNumberOfBytesRead:self.tripDetailsPointer + self.tripDetailsOffset + self.tripDetailsLegOffset + tripLegIndex * self.tripDetailsLegSize];
    NSAssert(self.tripDetailsLegSize == 16, @"Invalid trip leg size");
    NSDate *predictedDepartureTime = [self readDateWithBaseDate:self.resDate dayOffset:tripDayOffset];
    NSTimeInterval departureDelay = [predictedDepartureTime timeIntervalSinceDate:departureDate];
    NSDate *predictedArrivalTime = [self readDateWithBaseDate:self.resDate dayOffset:tripDayOffset];
    NSTimeInterval arrivalDelay = [predictedArrivalTime timeIntervalSinceDate:arrivalDate];
    NSString *departureDelayPlatform = [self readPlatform];
    NSString *arrivalDelayPlatform = [self readPlatform];
    
    CCHTransportEvent *departure = [[CCHTransportEvent alloc] initWithDate:departureDate platform:departurePlatform delay:departureDelay delayPlatform:departureDelayPlatform];
    CCHTransportEvent *arrival = [[CCHTransportEvent alloc] initWithDate:arrivalDate platform:arrivalPlatform delay:arrivalDelay delayPlatform:arrivalDelayPlatform];
    
    unsigned short cancelledBits = [binaryDataReader readUnsignedShort];
    BOOL arrivalCancelled = (cancelledBits & 0x10) != 0;
    BOOL departureCancelled = (cancelledBits & 0x20) != 0;
    (void)arrivalCancelled;
    (void)departureCancelled;
    
    // Stop indices
    [binaryDataReader skipNumberOfBytes:0x2];
    short firstStopIndex = [binaryDataReader readShort];
    short numStops = [binaryDataReader readShort];

    // Disruption text
    [binaryDataReader setNumberOfBytesRead:self.disruptionsPointer];
    NSString *disruptionText = [self readDisruptionTextWithTripLegIndex:tripLegIndex tripIndex:tripIndex];
    (void)disruptionText;

    // Stops
    NSMutableArray *stops = [NSMutableArray array];
    [stops addObject:departureLocation];
    for (short stopIndex = 0; stopIndex < numStops; stopIndex++) {
        [binaryDataReader setNumberOfBytesRead:self.tripDetailsPointer + self.intermediateStopsOffset + firstStopIndex * self.intermediateStopsSize + stopIndex * self.intermediateStopsSize];
        
        [binaryDataReader skipNumberOfBytes:8]; // planned
        [binaryDataReader skipNumberOfBytes:4];
        [binaryDataReader skipNumberOfBytes:8]; // predicted
        [binaryDataReader skipNumberOfBytes:4];
        
        CCHTransportLocation *location = [self readLocation];
        [stops addObject:location];
    }
    [stops addObject:arrivalLocation];

    CCHTransportTripLeg *tripLeg = [[CCHTransportTripLeg alloc] initWithDeparture:departure arrival:arrival service:service stops:stops];
    return tripLeg;
}

- (NSString *)readDisruptionTextWithTripLegIndex:(short)tripLegIndex tripIndex:(short)tripIndex
{
    CCHBinaryDataReader *binaryDataReader = self.binaryDataReader;
    NSString *disruptionText;
    
    if ([binaryDataReader readShort] == 1) {
        [binaryDataReader skipNumberOfBytes:tripIndex * 2];
        short disruptionsOffset = [binaryDataReader readShort];
        while (disruptionsOffset != 0) {
            [binaryDataReader setNumberOfBytesRead:self.disruptionsPointer + disruptionsOffset];

            [self.binaryDataReader readShort];    // "0"
            short disruptionLeg = [binaryDataReader readShort];
            [binaryDataReader skipNumberOfBytes:2]; // bit mask
            [self.binaryDataReader readShort];    // start of line
            [self.binaryDataReader readShort];    // end of line
            [self.binaryDataReader readShort];    // id
            [self.binaryDataReader readShort];    // title
            
            NSString *textShort = [self readString];
            disruptionsOffset = [binaryDataReader readShort];
            
            if (disruptionLeg == tripLegIndex) {
                if (textShort.length == 0) {
                    short disruptionAttributesOffset = [binaryDataReader readShort];
                    [binaryDataReader setNumberOfBytesRead:self.attributesPointer + disruptionAttributesOffset * 4];
                    while (YES) {
                        NSString *key = [self readString];
                        if (key.length == 0) {
                            break;
                        } else if ([key isEqualToString:@"Text"]) {
                            disruptionText = [self readString];     // text long
                        } else {
                            [binaryDataReader skipNumberOfBytes:2];
                        }
                    }
                } else {
                    disruptionText = textShort;
                }
            }
        }
    }
    
    return disruptionText;
}

- (CCHTransportLocation *)readLocation
{
    CCHBinaryDataReader *binaryDataReader = self.binaryDataReader;

    short locationOffset = [binaryDataReader readShort];
    [self.stationsBinaryDataReader setNumberOfBytesRead:locationOffset * 14];
    short stringOffset = [self.stationsBinaryDataReader readShort];
    [self.stringsBinaryDataReader setNumberOfBytesRead:stringOffset];
    NSString *name = [self.stringsBinaryDataReader readNullTerminatedStringWithEncoding:self.stringEncoding];
    
    int id = [self.stationsBinaryDataReader readInt];
    int lon = [self.stationsBinaryDataReader readInt];
    int lat = [self.stationsBinaryDataReader readInt];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat / 1E6, lon / 1E6);

    CCHTransportLocation *location;
    if (id != 0) {
        NSString *stationID = @(id).stringValue;
        location = [[CCHTransportStation alloc] initWithStationID:stationID name:name coordinate:coordinate];
    } else {
        location = [[CCHTransportLocation alloc] initWithName:name coordinate:coordinate];
    }
    return location;
}

- (NSString *)readString
{
    short stringOffset = [self.binaryDataReader readShort];
    [self.stringsBinaryDataReader setNumberOfBytesRead:stringOffset];
   
    NSString *string = [self.stringsBinaryDataReader readNullTerminatedStringWithEncoding:self.stringEncoding];
    return string;
}

- (NSDate *)readDate
{
    CCHBinaryDataReader *binaryDataReader = self.binaryDataReader;
    short days = [binaryDataReader readShort];
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    dateComponents.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CET"];
    dateComponents.year = 1980;
    dateComponents.day = days;
    
    NSDate *date = [dateComponents date];
    return date;
}

- (NSString *)readPlatform
{
    NSString *platform = [self readString]; // "Pl. x", "Gleis x"
    
    if ([platform isEqualToString:@"---"]) {
        platform = nil;
    } else {
        // Check if platform ends with something containing a number
        NSArray *components = [platform componentsSeparatedByString:@" "];
        NSRange range = [components.lastObject rangeOfCharacterFromSet:NSCharacterSet.decimalDigitCharacterSet];
        if (components.count > 0 && range.location != NSNotFound) {
            platform = components.lastObject;
        }
    }
    
    return platform;
}

- (NSDate *)readDateWithBaseDate:(NSDate *)baseDate dayOffset:(short)dayOffset
{
    CCHBinaryDataReader *binaryDataReader = self.binaryDataReader;
    
    NSDate *date;
    
    unsigned short value = [binaryDataReader readUnsignedShort];
    if (value != 0xffff) {
        short hours = value / 100;
        short minutes = value % 100;
        
//        NSAssert(hours >= 0 && hours <= 24, @"Invalid hours");
//        NSAssert(minutes >= 0 && minutes <= 60, @"Invalid minutes");
        
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        dateComponents.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
        dateComponents.day = dayOffset;
        dateComponents.hour = hours;
        dateComponents.minute = minutes;
        
        date = [dateComponents.calendar dateByAddingComponents:dateComponents toDate:baseDate options:0];
    }
    
    return date;
}

- (short)readTripDayOffset
{
    CCHBinaryDataReader *binaryDataReader = self.binaryDataReader;
    
    [binaryDataReader skipNumberOfBytes:0x02];  // serviceDaysText
    short serviceBitBase = [binaryDataReader readShort];
    short serviceBitLength = [binaryDataReader readShort];
    
    short tripDayOffset = serviceBitBase * 8;
    for (short i = 0; i < serviceBitLength; i++) {
        unsigned char serviceBits = [binaryDataReader readUnsignedChar];
        if (serviceBits == 0) {
            tripDayOffset += 8;
            continue;
        }
        
        while ((serviceBits & 0x80) == 0) {
            serviceBits = serviceBits << 1;
            tripDayOffset++;
        }
        break;
    }
    
    return tripDayOffset;
}

+ (CCHTransportServiceMode)transportModeForTransportClass:(NSInteger)transportClass
{
    CCHTransportServiceMode transportMode;
    
    switch (transportClass) {
        case 1 << 0:
        case 1 << 1:
            transportMode = CCHTransportServiceModeLongDistanceTrain;
            break;

        case 1 << 2:
        case 1 << 3:
            transportMode = CCHTransportServiceModeRegionalTrain;
            break;

        case 1 << 4:
            transportMode = CCHTransportServiceModeSuburbanTrain;
            break;

        case 1 << 5:
            transportMode = CCHTransportServiceModeBus;
            break;

        case 1 << 6:
            transportMode = CCHTransportServiceModeFerry;
            break;

        case 1 << 7:
            transportMode = CCHTransportServiceModeSubway;
            break;

        case 1 << 8:
            transportMode = CCHTransportServiceModeStreetCar;
            break;

        case 1 << 9:
            transportMode = CCHTransportServiceModeOnDemandService;
            break;

        default:
            transportMode = CCHTransportServiceModeUnknown;
            break;
    }
    
    return transportMode;
}

+ (CCHBinaryDataReader *)binaryDataReaderForData:(NSData *)data withOffset:(NSUInteger)offset length:(NSUInteger)length
{
    void *dataBytes = (void *)(data.bytes + offset);
    NSData *offsetData = [NSData dataWithBytesNoCopy:dataBytes length:length freeWhenDone:NO];
    CCHBinaryDataReader *binaryDataReader = [[CCHBinaryDataReader alloc] initWithData:offsetData options:0];
    
    return binaryDataReader;
}

+ (NSError *)errorForErrorCode:(short)errorCode
{
    NSString *message;
    switch (errorCode) {
        case 1: message = @"Session expired"; break;
        case 8: message = @"Ambiguous"; break;
        case 887: message = @"Your inquiry was too complex. Please try entering less intermediate stations."; break;
        case 890: message = @"No connections have been found that correspond to your request. It is possible that the requested service does not operate from or to the places you stated on the requested date of travel."; break;
        case 891: message = @"Unfortunately there was no route found. Missing timetable data could be the reason."; break;
        case 892: message = @"Your inquiry was too complex. Please try entering less intermediate stations."; break;
        case 895: message = @"Departure/Arrival are too near"; break;
        case 899: message = @"There was an unsuccessful or incomplete search due to a timetable change."; break;
        case 900: message = @"Unsuccessful or incomplete search (timetable change)."; break;
        case 9220: message = @"Nearby to the given address stations could not be found."; break;
        case 9240: message = @"Unfortunately there was no route found. Perhaps your start or destination is not served at all or with the selected means of transport on the required date/time."; break;
        case 9260: message = @"Unknown departure station"; break;
        case 9320: message = @"The input is incorrect or incomplete"; break;
        case 9360: message = @"Unfortunately your connection request can currently not be processed."; break;
        case 9380: message = @"Dep./Arr./Intermed. or equivalent station defined more than once"; break;
            
        default: message = @"Unknown error"; break;
    }

    NSError *error = [NSError errorWithDomain:CCHTransportDEBahnClientErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey: message}];
    return error;
}

+ (NSError *)errorWithMessage:(NSString *)message
{
    NSError *error = [NSError errorWithDomain:CCHTransportDEBahnClientErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey: message}];
    return error;
}

@end

//
//  CCHTransportDEVBBConResParser.m
//  Departures
//
//  Created by Claus Höfele on 09.08.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportDEVBBConResParser.h"
#import "CCHTransportTrip.h"
#import "CCHTransportTripLeg.h"
#import "CCHTransportLocation.h"
#import "CCHTransportStation.h"
#import "CCHTransportService.h"
#import "CCHTransportEvent.h"

#import "XCTestCase+CCHTransportClientUtils.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface CCHTransportDEVBBConResParserTests : XCTestCase

@property (nonatomic) CCHTransportDEVBBConResParser *parser;

@end

@implementation CCHTransportDEVBBConResParserTests

- (void)setUp
{
    [super setUp];
    
    self.parser = [[CCHTransportDEVBBConResParser alloc] init];
}

- (void)testParseTripsStations
{
    NSData *data = [self.class loadDataWithFileName:@"ConRes-bellevue-wannsee" ofType:@"xml"];
    NSArray *trips = [self.parser parseResponseWithData:data];
    XCTAssertEqual(trips.count, 6);
    {
        // Trip 0
        CCHTransportTrip *trip = trips[0];
        XCTAssertEqual(trip.legs.count, 2);
        {
            CCHTransportTripLeg *tripLeg = trip.legs[0];
            XCTAssertEqualObjects(tripLeg.departure.date, [self.class dateFromGMTWithMonth:8 day:8 hour:21 minute:11]);
            XCTAssertEqualObjects(tripLeg.arrival.date, [self.class dateFromGMTWithMonth:8 day:8 hour:21 minute:14]);
            XCTAssertEqualObjects(tripLeg.service.name, @"S5");
            XCTAssertEqualObjects(tripLeg.service.directionName, @"S Grunewald (Berlin)");
            XCTAssertEqual(tripLeg.service.transportMode, CCHTransportServiceModeSuburbanTrain);
            XCTAssertEqual(tripLeg.departure.delay, 0);
            XCTAssertEqual(tripLeg.arrival.delay, 0);
            XCTAssertEqualObjects(tripLeg.departure.platform, @"4");
            XCTAssertEqualObjects(tripLeg.arrival.platform, @"6");
            XCTAssertNil(tripLeg.departure.delayPlatform);
            XCTAssertNil(tripLeg.arrival.delayPlatform);
            
            XCTAssertEqual(tripLeg.stops.count, 3);
            {
                CCHTransportStation *stop = tripLeg.stops[0];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"S Bellevue (Berlin)");
                XCTAssertEqualObjects(stop.stationID, @"009003102");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
            {
                CCHTransportStation *stop = tripLeg.stops[1];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"S Tiergarten (Berlin)");
                XCTAssertEqualObjects(stop.stationID, @"009003103");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
            {
                CCHTransportStation *stop = tripLeg.stops[2];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"S+U Zoologischer Garten Bhf (Berlin)");
                XCTAssertEqualObjects(stop.stationID, @"009023201");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
        }

        {
            CCHTransportTripLeg *tripLeg = trip.legs[1];
            XCTAssertEqualObjects(tripLeg.departure.date, [self.class dateFromGMTWithMonth:8 day:8 hour:21 minute:21]);
            XCTAssertEqualObjects(tripLeg.arrival.date, [self.class dateFromGMTWithMonth:8 day:8 hour:21 minute:33]);
            XCTAssertEqualObjects(tripLeg.service.name, @"RE7");
            XCTAssertEqualObjects(tripLeg.service.directionName, @"Bad Belzig, Bahnhof");
            XCTAssertEqual(tripLeg.service.transportMode, CCHTransportServiceModeRegionalTrain);
            XCTAssertEqual(tripLeg.departure.delay, 240);
            XCTAssertEqual(tripLeg.arrival.delay, 240);
            XCTAssertEqualObjects(tripLeg.departure.platform, @"3");
            XCTAssertEqualObjects(tripLeg.arrival.platform, @"5");
            XCTAssertNil(tripLeg.departure.delayPlatform);
            XCTAssertNil(tripLeg.arrival.delayPlatform);
            
            XCTAssertEqual(tripLeg.stops.count, 3);
            {
                CCHTransportStation *stop = tripLeg.stops[0];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"S+U Zoologischer Garten Bhf (Berlin)");
                XCTAssertEqualObjects(stop.stationID, @"009023201");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
            {
                CCHTransportStation *stop = tripLeg.stops[1];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"S Charlottenburg Bhf (Berlin)");
                XCTAssertEqualObjects(stop.stationID, @"009024101");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
            {
                CCHTransportStation *stop = tripLeg.stops[2];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"S Wannsee Bhf (Berlin)");
                XCTAssertEqualObjects(stop.stationID, @"009053301");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
        }
    }
}

@end

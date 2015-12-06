//
//  CCHTransportDEBahnQueryParserTests.m
//  CCHTransportClient
//
//  Copyright (C) 2015 Claus Höfele
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "CCHTransportDEBahnQueryParser.h"
#import "CCHTransportTrip.h"
#import "CCHTransportTripLeg.h"
#import "CCHTransportLocation.h"
#import "CCHTransportStation.h"
#import "CCHTransportService.h"
#import "CCHTransportEvent.h"

#import "XCTestCase+CCHTransportClientUtils.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface CCHTransportDEBahnQueryParserTests : XCTestCase

@property (nonatomic) CCHTransportDEBahnQueryParser *parser;

@end

@implementation CCHTransportDEBahnQueryParserTests

- (void)setUp
{
    [super setUp];

    self.parser = [[CCHTransportDEBahnQueryParser alloc] init];
}

- (void)testParseTripsStations
{
    NSData *data = [self.class loadDataWithFileName:@"query-bellevue-wannsee" ofType:@"bin"];
    NSArray *trips = [self.parser parseResponseWithData:data][CCHTransportDEBahnQueryParserResultTripsKey];
    XCTAssertEqual(trips.count, 3);
    {
        // Trip 0
        CCHTransportTrip *trip = trips[0];
        XCTAssertEqual(trip.legs.count, 2);
        {
            CCHTransportTripLeg *tripLeg = trip.legs[0];
            XCTAssertEqualObjects(tripLeg.departure.date, [self.class dateFromGMTWithMonth:7 day:31 hour:16 minute:3]);
            XCTAssertEqualObjects(tripLeg.arrival.date, [self.class dateFromGMTWithMonth:7 day:31 hour:16 minute:11]);
            XCTAssertEqualObjects(tripLeg.service.name, @"Bus SEV");
            XCTAssertEqualObjects(tripLeg.service.directionName, @"Berlin Zoologischer Garten");
            XCTAssertEqual(tripLeg.service.transportMode, CCHTransportServiceModeRegionalTrain); // [sic]
            XCTAssertEqual(tripLeg.departure.delay, 0);
            XCTAssertEqual(tripLeg.arrival.delay, 0);
            XCTAssertNil(tripLeg.departure.platform);
            XCTAssertNil(tripLeg.arrival.platform);
            XCTAssertNil(tripLeg.departure.delayPlatform);
            XCTAssertNil(tripLeg.arrival.delayPlatform);
            
            XCTAssertEqual(tripLeg.stops.count, 4);
            {
                CCHTransportStation *stop = tripLeg.stops[0];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"Berlin Bellevue");
                XCTAssertEqualObjects(stop.stationID, @"8089005");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
            {
                CCHTransportStation *stop = tripLeg.stops[1];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"Hansaplatz (U), Berlin");
                XCTAssertEqualObjects(stop.stationID, @"730737");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
            {
                CCHTransportStation *stop = tripLeg.stops[2];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"Berlin-Tiergarten");
                XCTAssertEqualObjects(stop.stationID, @"8089091");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
            {
                CCHTransportStation *stop = tripLeg.stops[3];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"Berlin Zoologischer Garten");
                XCTAssertEqualObjects(stop.stationID, @"8010406");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
        }
        {
            CCHTransportTripLeg *tripLeg = trip.legs[1];
            XCTAssertEqualObjects(tripLeg.departure.date, [self.class dateFromGMTWithMonth:7 day:31 hour:16 minute:17]);
            XCTAssertEqualObjects(tripLeg.arrival.date, [self.class dateFromGMTWithMonth:7 day:31 hour:16 minute:28]);
            XCTAssertEqualObjects(tripLeg.service.name, @"RE 18130");
            XCTAssertEqual(tripLeg.service.transportMode, CCHTransportServiceModeRegionalTrain);
            XCTAssertNil(tripLeg.service.directionName);
            XCTAssertEqual(tripLeg.departure.delay, 0);
            XCTAssertEqual(tripLeg.arrival.delay, 0);
            XCTAssertEqualObjects(tripLeg.departure.platform, @"4");
            XCTAssertEqualObjects(tripLeg.arrival.platform, @"5");
            XCTAssertNil(tripLeg.departure.delayPlatform);
            XCTAssertNil(tripLeg.arrival.delayPlatform);

            XCTAssertEqual(tripLeg.stops.count, 3);
            {
                CCHTransportStation *stop = tripLeg.stops[0];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"Berlin Zoologischer Garten");
                XCTAssertEqualObjects(stop.stationID, @"8010406");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
            {
                CCHTransportStation *stop = tripLeg.stops[1];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"Berlin-Charlottenburg");
                XCTAssertEqualObjects(stop.stationID, @"8010403");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
            {
                CCHTransportStation *stop = tripLeg.stops[2];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"Berlin Wannsee");
                XCTAssertEqualObjects(stop.stationID, @"8010405");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
        }
    }
    {
        // Trip 1
        CCHTransportTrip *trip = trips[1];
        XCTAssertEqual(trip.legs.count, 2);
        {
            CCHTransportTripLeg *tripLeg = trip.legs[0];
            XCTAssertEqualObjects(tripLeg.departure.date, [self.class dateFromGMTWithMonth:7 day:31 hour:16 minute:6]);
            XCTAssertEqualObjects(tripLeg.arrival.date, [self.class dateFromGMTWithMonth:7 day:31 hour:16 minute:14]);
            XCTAssertEqualObjects(tripLeg.service.name, @"Bus SEV");
            XCTAssertEqualObjects(tripLeg.service.directionName, @"Berlin Zoologischer Garten");
            XCTAssertEqual(tripLeg.service.transportMode, CCHTransportServiceModeRegionalTrain); // [sic]
            XCTAssertEqual(tripLeg.departure.delay, 0);
            XCTAssertEqual(tripLeg.arrival.delay, 0);
            XCTAssertNil(tripLeg.departure.platform);
            XCTAssertNil(tripLeg.arrival.platform);
            XCTAssertNil(tripLeg.departure.delayPlatform);
            XCTAssertNil(tripLeg.arrival.delayPlatform);

            XCTAssertEqual(tripLeg.stops.count, 4);
            {
                CCHTransportStation *stop = tripLeg.stops[0];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"Berlin Bellevue");
                XCTAssertEqualObjects(stop.stationID, @"8089005");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
            {
                CCHTransportStation *stop = tripLeg.stops[1];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"Hansaplatz (U), Berlin");
                XCTAssertEqualObjects(stop.stationID, @"730737");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
            {
                CCHTransportStation *stop = tripLeg.stops[2];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"Berlin-Tiergarten");
                XCTAssertEqualObjects(stop.stationID, @"8089091");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
            {
                CCHTransportStation *stop = tripLeg.stops[3];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"Berlin Zoologischer Garten");
                XCTAssertEqualObjects(stop.stationID, @"8010406");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
        }
        
        {
            CCHTransportTripLeg *tripLeg = trip.legs[1];
            XCTAssertEqualObjects(tripLeg.departure.date, [self.class dateFromGMTWithMonth:7 day:31 hour:16 minute:21]);
            XCTAssertEqualObjects(tripLeg.arrival.date, [self.class dateFromGMTWithMonth:7 day:31 hour:16 minute:33]);
            XCTAssertEqualObjects(tripLeg.service.name, @"RE 18727");
            XCTAssertEqual(tripLeg.service.transportMode, CCHTransportServiceModeRegionalTrain);
            XCTAssertNil(tripLeg.service.directionName);
            XCTAssertEqual(tripLeg.departure.delay, 60);
            XCTAssertEqual(tripLeg.arrival.delay, 60);
            XCTAssertEqualObjects(tripLeg.departure.platform, @"3");
            XCTAssertEqualObjects(tripLeg.arrival.platform, @"5");
            XCTAssertNil(tripLeg.departure.delayPlatform);
            XCTAssertNil(tripLeg.arrival.delayPlatform);

            XCTAssertEqual(tripLeg.stops.count, 3);
            {
                CCHTransportStation *stop = tripLeg.stops[0];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"Berlin Zoologischer Garten");
                XCTAssertEqualObjects(stop.stationID, @"8010406");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
            {
                CCHTransportStation *stop = tripLeg.stops[1];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"Berlin-Charlottenburg");
                XCTAssertEqualObjects(stop.stationID, @"8010403");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
            {
                CCHTransportStation *stop = tripLeg.stops[2];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"Berlin Wannsee");
                XCTAssertEqualObjects(stop.stationID, @"8010405");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
        }
    }
    
    {
        // Trip 2
        CCHTransportTrip *trip = trips[2];
        XCTAssertEqual(trip.legs.count, 2);
        
        {
            CCHTransportTripLeg *tripLeg = trip.legs[0];
            XCTAssertEqualObjects(tripLeg.departure.date, [self.class dateFromGMTWithMonth:7 day:31 hour:16 minute:15]);
            XCTAssertEqualObjects(tripLeg.arrival.date, [self.class dateFromGMTWithMonth:7 day:31 hour:16 minute:23]);
            XCTAssertEqualObjects(tripLeg.service.name, @"Bus SEV");
            XCTAssertEqualObjects(tripLeg.service.directionName, @"Berlin Zoologischer Garten");
            XCTAssertEqual(tripLeg.service.transportMode, CCHTransportServiceModeRegionalTrain); // [sic]
            XCTAssertEqual(tripLeg.departure.delay, 0);
            XCTAssertEqual(tripLeg.arrival.delay, 0);
            XCTAssertNil(tripLeg.departure.platform);
            XCTAssertNil(tripLeg.arrival.platform);
            XCTAssertNil(tripLeg.departure.delayPlatform);
            XCTAssertNil(tripLeg.arrival.delayPlatform);

            XCTAssertEqual(tripLeg.stops.count, 4);
            {
                CCHTransportStation *stop = tripLeg.stops[0];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"Berlin Bellevue");
                XCTAssertEqualObjects(stop.stationID, @"8089005");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
            {
                CCHTransportStation *stop = tripLeg.stops[1];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"Hansaplatz (U), Berlin");
                XCTAssertEqualObjects(stop.stationID, @"730737");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
            {
                CCHTransportStation *stop = tripLeg.stops[2];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"Berlin-Tiergarten");
                XCTAssertEqualObjects(stop.stationID, @"8089091");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
            {
                CCHTransportStation *stop = tripLeg.stops[3];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"Berlin Zoologischer Garten");
                XCTAssertEqualObjects(stop.stationID, @"8010406");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
        }
        
        {
            CCHTransportTripLeg *tripLeg = trip.legs[1];
            XCTAssertEqualObjects(tripLeg.departure.date, [self.class dateFromGMTWithMonth:7 day:31 hour:16 minute:30]);
            XCTAssertEqualObjects(tripLeg.arrival.date, [self.class dateFromGMTWithMonth:7 day:31 hour:16 minute:51]);
            XCTAssertEqualObjects(tripLeg.service.name, @"S 7");
            XCTAssertEqualObjects(tripLeg.service.directionName, @"Berlin Wannsee");
            XCTAssertEqual(tripLeg.service.transportMode, CCHTransportServiceModeSuburbanTrain);
            XCTAssertEqual(tripLeg.departure.delay, 0);
            XCTAssertEqual(tripLeg.arrival.delay, 0);
            XCTAssertEqualObjects(tripLeg.departure.platform, @"6");
            XCTAssertEqualObjects(tripLeg.arrival.platform, @"4");
            XCTAssertNil(tripLeg.departure.delayPlatform);
            XCTAssertNil(tripLeg.arrival.delayPlatform);

            XCTAssertEqual(tripLeg.stops.count, 7);
            {
                CCHTransportStation *stop = tripLeg.stops[0];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"Berlin Zoologischer Garten");
                XCTAssertEqualObjects(stop.stationID, @"8010406");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
            {
                CCHTransportStation *stop = tripLeg.stops[1];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"Berlin Savignyplatz");
                XCTAssertEqualObjects(stop.stationID, @"8089037");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
            {
                CCHTransportStation *stop = tripLeg.stops[2];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"Berlin-Charlottenburg");
                XCTAssertEqualObjects(stop.stationID, @"8010403");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
            {
                CCHTransportStation *stop = tripLeg.stops[3];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"Berlin Westkreuz");
                XCTAssertEqualObjects(stop.stationID, @"8089047");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
            {
                CCHTransportStation *stop = tripLeg.stops[4];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"Berlin-Grunewald");
                XCTAssertEqualObjects(stop.stationID, @"8089062");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
            {
                CCHTransportStation *stop = tripLeg.stops[5];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"Berlin-Nikolassee");
                XCTAssertEqualObjects(stop.stationID, @"8089078");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
            {
                CCHTransportStation *stop = tripLeg.stops[6];
                XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
                XCTAssertEqualObjects(stop.name, @"Berlin Wannsee");
                XCTAssertEqualObjects(stop.stationID, @"8010405");
                XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
            }
        }
    }
}

- (void)testParseTripsLocation
{
    NSData *data = [self.class loadDataWithFileName:@"query-52523300_13412700-wannsee" ofType:@"bin"];
    NSArray *trips = [self.parser parseResponseWithData:data][CCHTransportDEBahnQueryParserResultTripsKey];
    XCTAssertEqual(trips.count, 3);

    XCTAssertEqual([trips[0] legs].count, 5);
    XCTAssertEqual([trips[1] legs].count, 2);
    XCTAssertEqual([trips[2] legs].count, 4);
    
    // Trip includes two walks coalesced into one
    CCHTransportTrip *trip = trips[1];
    XCTAssertEqual(trip.legs.count, 2);
    {
        CCHTransportTripLeg *tripLeg = trip.legs[0];
        XCTAssertEqualObjects(tripLeg.service.name, @"Fußweg");
        XCTAssertNil(tripLeg.service.directionName);
        XCTAssertEqual(tripLeg.service.transportMode, CCHTransportServiceModePedestrian);
        
        XCTAssertEqual(tripLeg.stops.count, 2);
        {
            CCHTransportLocation *stop = tripLeg.stops[0];
            XCTAssertTrue([stop isKindOfClass:CCHTransportLocation.class]);
            XCTAssertTrue(CLLocationCoordinate2DIsValid(stop.coordinate));
        }
        {
            CCHTransportStation *stop = tripLeg.stops[1];
            XCTAssertTrue([stop isKindOfClass:CCHTransportStation.class]);
            XCTAssertEqualObjects(stop.name, @"Berlin Alexanderplatz");
        }
    }
}

- (void)testParseTripsError
{
    NSData *data = [self.class loadDataWithFileName:@"query-error" ofType:@"bin"];
    NSDictionary *result = [self.parser parseResponseWithData:data];
    NSArray *trips = result[CCHTransportDEBahnQueryParserResultTripsKey];
    id context = result[CCHTransportDEBahnQueryParserResultContextKey];
    NSError *error = result[CCHTransportDEBahnQueryParserResultErrorKey];

    XCTAssertEqual(trips.count, 0);
    XCTAssertNil(context);
    XCTAssertEqual(error.code, 9220);
}

- (void)testParseTripsMessages
{
    NSData *data = [self.class loadDataWithFileName:@"query-messages" ofType:@"bin"];
    NSArray *trips = [self.parser parseResponseWithData:data][CCHTransportDEBahnQueryParserResultTripsKey];

    XCTAssertEqual(trips.count, 3);
}

- (void)testParseTripsDisruptionText
{
    NSData *data = [self.class loadDataWithFileName:@"query-disruptiontext" ofType:@"bin"];
    NSArray *trips = [self.parser parseResponseWithData:data][CCHTransportDEBahnQueryParserResultTripsKey];
    
    XCTAssertEqual(trips.count, 4);
}

- (void)testParseTripsWalk
{
    NSData *data = [self.class loadDataWithFileName:@"query-walk" ofType:@"bin"];
    NSDictionary *result = [self.parser parseResponseWithData:data];
    NSArray *trips = result[CCHTransportDEBahnQueryParserResultTripsKey];
    id context = result[CCHTransportDEBahnQueryParserResultContextKey];
    NSError *error = result[CCHTransportDEBahnQueryParserResultErrorKey];
    
    XCTAssertEqual(trips.count, 1);
    XCTAssertNil(context);
    XCTAssertNil(error);
}

@end

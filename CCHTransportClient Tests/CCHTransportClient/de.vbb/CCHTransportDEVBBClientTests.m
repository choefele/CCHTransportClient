//
//  CCHTransportDEVBBClientTests.m
//  Departures
//
//  Created by Hoefele, Claus on 10.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportDEVBBClient.h"
#import "CCHTransportDeparture.h"
#import "CCHTransportService.h"
#import "CCHTransportEvent.h"
#import "CCHTransportStation.h"
#import "CCHTransportTrip.h"
#import "CCHTransportTripLeg.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface CCHTransportDEVBBClientTests : XCTestCase

@property (nonatomic) id<CCHTransportClient> transportClient;

@end

@implementation CCHTransportDEVBBClientTests

- (void)setUp
{
    [super setUp];
    
    NSString *accessID = [[NSUserDefaults standardUserDefaults] stringForKey:@"accessID"];
    NSAssert(accessID, @"Missing access ID");
    self.transportClient = [[CCHTransportDEVBBClient alloc] initWithAccessID:accessID];
}

- (void)testRetrieveDepartures
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    
    NSString *stationID = @"9100001"; // S+U Friedrichstr. Bhf (Berlin)
    [self.transportClient retrieveDeparturesForDate:nil stationID:stationID maxNumberOfResults:10 completionHandler:^(NSArray *departures, NSError *error) {
        XCTAssertNil(error);
        XCTAssertGreaterThan(departures.count, 1);
        
        if (departures.count > 0) {
            CCHTransportDeparture *departure = departures[0];
            XCTAssertNotNil(departure.service.directionName);
            XCTAssertNotNil(departure.service.name);
            XCTAssertNotEqual(departure.service.transportMode, CCHTransportServiceModeUnknown);
            XCTAssertNotNil(departure.event.date);
        }
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:NULL];
}

- (void)testRetrieveTripsStationID
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    
    // 9003102,,S Bellevue (Berlin),,52.5199510,13.3470980,,,0,
    CCHTransportStation *from = [[CCHTransportStation alloc] initWithStationID:@"9003102" name:nil coordinate:CLLocationCoordinate2DMake(0, 0)];
    
    // 9053301,,S Wannsee Bhf (Berlin),,52.4214570,13.1790990,,,0,
    CCHTransportStation *to = [[CCHTransportStation alloc] initWithStationID:@"9053301" name:nil coordinate:CLLocationCoordinate2DMake(0, 0)];
    
    [self.transportClient retrieveTripsForDate:nil fromLocation:from toLocation:to transportModeMask:CCHTransportClientModeAll maxNumberOfResults:10 completionHandler:^(NSArray *trips, id context, NSError *error) {
        XCTAssertNil(error);
        XCTAssertGreaterThan(trips.count, 0);
        
        if (trips.count > 0) {
            CCHTransportTrip *trip = trips[0];
            XCTAssertNotNil(trip.legs);
            XCTAssertGreaterThan(trip.legs.count, 0);
            CCHTransportTripLeg *tripLeg = trip.legs[0];
            XCTAssertNotNil(tripLeg.departure.date);
            XCTAssertNotNil(tripLeg.arrival.date);
            XCTAssertNotNil(tripLeg.service.name);
        }
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:NULL];
}

@end

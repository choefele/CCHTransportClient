//
//  CCHTransportDEBahnClientTests.m
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

#import "CCHTransportDEBahnClient.h"
#import "CCHTransportDeparture.h"
#import "CCHTransportStation.h"
#import "CCHTransportTrip.h"
#import "CCHTransportTripLeg.h"
#import "CCHTransportService.h"
#import "CCHTransportEvent.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface CCHTransportDEBahnClientTests : XCTestCase

@property (nonatomic) id<CCHTransportClient> transportClient;

@end

@implementation CCHTransportDEBahnClientTests

- (void)setUp
{
    [super setUp];
    
    self.transportClient = [[CCHTransportDEBahnClient alloc] init];
}

- (void)testRetrieveDepartures
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    
    NSString *stationID = @"0732531";   // Berlin Friedrichstraße
    [self.transportClient retrieveDeparturesForDate:nil stationID:stationID maxNumberOfResults:10 completionHandler:^(NSArray *departures, NSError *error) {
        XCTAssertNil(error);
        XCTAssertGreaterThan(departures.count, 0);
        
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

- (void)testRetrieveStationsNearCoordinate
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(52.5233, 13.4127);   // Alexanderplatz
    [self.transportClient retrieveStationsNearCoordinate:coordinate maxDistance:5000 maxNumberOfResults:10 completionHandler:^(NSArray *stations, NSError *error) {
        XCTAssertNil(error);
        XCTAssertGreaterThan(stations.count, 0);

        if (stations.count > 0) {
            CCHTransportStation *station = stations[0];
            XCTAssertNotNil(station.stationID);
            XCTAssertNotNil(station.name);
        }
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:NULL];
}

- (void)testRetrieveStationsForSearchString
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    
    NSString *searchString = @"bellevue";
    [self.transportClient retrieveStationsForSearchString:searchString maxNumberOfResults:10 completionHandler:^(NSArray *stations, NSError *error) {
        XCTAssertNil(error);
        XCTAssertGreaterThan(stations.count, 0);
        
        if (stations.count > 0) {
            CCHTransportStation *station = stations[0];
            XCTAssertNotNil(station.stationID);
            XCTAssertNotNil(station.name);
        }
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:NULL];
}

- (void)testRetrieveTripsStationID
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    
    // [[STATION 8089005 52519953/13348262 null "Berlin Bellevue"]
    CCHTransportStation *from = [[CCHTransportStation alloc] initWithStationID:@"8089005" name:nil coordinate:CLLocationCoordinate2DMake(0, 0)];

    // [[STATION 8010405 52421053/13179336 null "Berlin Wannsee"]
    CCHTransportStation *to = [[CCHTransportStation alloc] initWithStationID:@"8010405" name:nil coordinate:CLLocationCoordinate2DMake(0, 0)];
    
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

- (void)testRetrieveTripsCoordinate
{
    XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
    
    // [[STATION 8089005 52519953/13348262 null "Berlin Bellevue"]
    CCHTransportLocation *from = [[CCHTransportLocation alloc] initWithName:nil coordinate:CLLocationCoordinate2DMake(52.519953, 13.348262)];
    
    // [[STATION 8010405 52421053/13179336 null "Berlin Wannsee"]
    CCHTransportLocation *to = [[CCHTransportLocation alloc] initWithName:nil coordinate:CLLocationCoordinate2DMake(52.421053, 13.179336)];
    
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

- (void)testRetrieveMoreTrips
{
    // [[STATION 8089005 52519953/13348262 null "Berlin Bellevue"]
    CCHTransportStation *from = [[CCHTransportStation alloc] initWithStationID:@"8089005" name:nil coordinate:CLLocationCoordinate2DMake(0, 0)];
    
    // [[STATION 8010405 52421053/13179336 null "Berlin Wannsee"]
    CCHTransportStation *to = [[CCHTransportStation alloc] initWithStationID:@"8010405" name:nil coordinate:CLLocationCoordinate2DMake(0, 0)];
    
    __block id moreTripsContext;
    {
        XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
        [self.transportClient retrieveTripsForDate:nil fromLocation:from toLocation:to transportModeMask:CCHTransportClientModeAll maxNumberOfResults:10 completionHandler:^(NSArray *trips, id context, NSError *error) {
            XCTAssertNil(error);
            XCTAssertGreaterThan(trips.count, 0);
            moreTripsContext = context;
            
            [expectation fulfill];
        }];
        
        [self waitForExpectationsWithTimeout:5 handler:NULL];
    }

    {
        XCTestExpectation *expectation = [self expectationWithDescription:NSStringFromSelector(_cmd)];
        [self.transportClient retrieveMoreTripsWithContext:moreTripsContext forward:YES maxNumberOfResults:10 completionHandler:^(NSArray *trips, id context, NSError *error) {
            XCTAssertNil(error);
            XCTAssertGreaterThan(trips.count, 0);
            XCTAssertNotNil(context);
            
            [expectation fulfill];
        }];
        
        [self waitForExpectationsWithTimeout:5 handler:NULL];
    }
}

@end

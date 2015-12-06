//
//  CCHTransportDEVBBClientTests.m
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

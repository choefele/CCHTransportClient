//
//  CCHTransportTripTests.m
//  Departures
//
//  Created by Claus Höfele on 06.08.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "CCHTransportTrip.h"
#import "CCHTransportTripLeg.h"
#import "CCHTransportService.h"
#import "CCHTransportEvent.h"

@interface CCHTransportTripTests : XCTestCase

@end

@implementation CCHTransportTripTests

- (void)testNumberOfChanges
{
    CCHTransportTripLeg *tripLeg = [[CCHTransportTripLeg alloc] initWithDeparture:nil arrival:nil service:nil stops:nil];
    CCHTransportTrip *trip = [[CCHTransportTrip alloc] initWithLegs:@[tripLeg, tripLeg]];
    XCTAssertEqual(trip.numberOfChanges, 1);
}

- (void)testNumberOfChanges0
{
    CCHTransportTripLeg *tripLeg = [[CCHTransportTripLeg alloc] initWithDeparture:nil arrival:nil service:nil stops:nil];
    CCHTransportTrip *trip = [[CCHTransportTrip alloc] initWithLegs:@[tripLeg]];
    XCTAssertEqual(trip.numberOfChanges, 0);
}

- (void)testNumberOfChangesNil
{
    CCHTransportTrip *trip = [[CCHTransportTrip alloc] initWithLegs:nil];
    XCTAssertEqual(trip.numberOfChanges, 0);
}

- (void)testNumberOfChangesWalk
{
    CCHTransportService *service = [[CCHTransportService alloc] initWithName:nil transportMode:CCHTransportServiceModePedestrian directionName:nil direction:CCHTransportServiceDirectionUnknown];
    CCHTransportTripLeg *tripLegWalk = [[CCHTransportTripLeg alloc] initWithDeparture:nil arrival:nil service:service stops:nil];
    CCHTransportTripLeg *tripLeg = [[CCHTransportTripLeg alloc] initWithDeparture:nil arrival:nil service:nil stops:nil];
    CCHTransportTrip *trip = [[CCHTransportTrip alloc] initWithLegs:@[tripLegWalk, tripLeg, tripLegWalk, tripLeg]];
    XCTAssertEqual(trip.numberOfChanges, 1);
}

@end

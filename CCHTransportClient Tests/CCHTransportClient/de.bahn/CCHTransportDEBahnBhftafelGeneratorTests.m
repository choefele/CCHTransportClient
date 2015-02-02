//
//  CCHTransportDEBahnBhftafelGeneratorTests.m
//  Departures
//
//  Created by Hoefele, Claus on 08.08.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportDEBahnBhftafelGenerator.h"
#import "XCTestCase+CCHTransportClientUtils.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface CCHTransportDEBahnBhftafelGeneratorTests : XCTestCase

@end

@implementation CCHTransportDEBahnBhftafelGeneratorTests

- (void)testDate
{
    NSDate *date = [self.class dateFromGMTWithMonth:3 day:17 hour:0 minute:0];
    CCHTransportDEBahnBhftafelGenerator *generator = [[CCHTransportDEBahnBhftafelGenerator alloc] initWithDate:date stationID:nil maxNumberOfResults:0];
    NSURLRequest *request = [generator generateRequest];
    NSString *URLString = request.URL.query;
    XCTAssertTrue([URLString containsString:@"date=17.03.14"]);
}

- (void)testTime
{
    NSDate *date = [self.class dateFromGMTWithMonth:0 day:0 hour:2 minute:59];
    CCHTransportDEBahnBhftafelGenerator *generator = [[CCHTransportDEBahnBhftafelGenerator alloc] initWithDate:date stationID:nil maxNumberOfResults:0];
    NSURLRequest *request = [generator generateRequest];
    NSString *URLString = request.URL.query;
    XCTAssertTrue([URLString containsString:@"time=03:59"]); // GMT -> MEZ
}

- (void)testLocationStationID
{
    CCHTransportDEBahnBhftafelGenerator *generator = [[CCHTransportDEBahnBhftafelGenerator alloc] initWithDate:nil stationID:@"09876543" maxNumberOfResults:0];
    NSURLRequest *request = [generator generateRequest];
    NSString *URLString = request.URL.query;
    XCTAssertTrue([URLString containsString:@"input=09876543"]);
}

- (void)testMaxNumberOfResults
{
    CCHTransportDEBahnBhftafelGenerator *generator = [[CCHTransportDEBahnBhftafelGenerator alloc] initWithDate:nil stationID:nil maxNumberOfResults:123];
    NSURLRequest *request = [generator generateRequest];
    NSString *URLString = request.URL.query;
    XCTAssertTrue([URLString containsString:@"maxJourneys=123"]);
}

@end

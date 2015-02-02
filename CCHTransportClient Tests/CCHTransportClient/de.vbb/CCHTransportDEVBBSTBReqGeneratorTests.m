//
//  CCHTransportDEVBBSTBReqGeneratorTests.m
//  Departures
//
//  Created by Hoefele, Claus on 08.08.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportDEVBBSTBReqGenerator.h"
#import "XCTestCase+CCHTransportClientUtils.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface CCHTransportDEVBBSTBReqGeneratorTests : XCTestCase

@end

@implementation CCHTransportDEVBBSTBReqGeneratorTests

- (void)testDate
{
    NSDate *date = [self.class dateFromGMTWithMonth:3 day:17 hour:0 minute:0];
    CCHTransportDEVBBSTBReqGenerator *generator = [[CCHTransportDEVBBSTBReqGenerator alloc] initWithAccessID:nil date:date stationID:nil maxNumberOfResults:0];
    NSURLRequest *request = [generator generateRequest];
    NSString *dataString = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    XCTAssertTrue([dataString containsString:@"<DateBegin>20140317</DateBegin>"]);
}

- (void)testTime
{
    NSDate *date = [self.class dateFromGMTWithMonth:0 day:0 hour:2 minute:59];
    CCHTransportDEVBBSTBReqGenerator *generator = [[CCHTransportDEVBBSTBReqGenerator alloc] initWithAccessID:nil date:date stationID:nil maxNumberOfResults:0];
    NSURLRequest *request = [generator generateRequest];
    NSString *dataString = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    XCTAssertTrue([dataString containsString:@"<Time>03:59</Time>"]); // GMT -> MEZ
}

- (void)testLocationStationID
{
    CCHTransportDEVBBSTBReqGenerator *generator = [[CCHTransportDEVBBSTBReqGenerator alloc] initWithAccessID:nil date:nil stationID:@"09876543" maxNumberOfResults:0];
    NSURLRequest *request = [generator generateRequest];
    NSString *dataString = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    XCTAssertTrue([dataString containsString:@"<TableStation externalId='09876543' />"]);
}

- (void)testMaxNumberOfResults
{
    CCHTransportDEVBBSTBReqGenerator *generator = [[CCHTransportDEVBBSTBReqGenerator alloc] initWithAccessID:nil date:nil stationID:nil maxNumberOfResults:123];
    NSURLRequest *request = [generator generateRequest];
    NSString *dataString = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    XCTAssertTrue([dataString containsString:@"maxJourneys='123'"]);
}

@end

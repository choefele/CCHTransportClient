//
//  CCHTransportDEBahnQueryYGeneratorTests.m
//  Departures
//
//  Created by Hoefele, Claus on 08.08.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportDEBahnQueryYGenerator.h"
#import "XCTestCase+CCHTransportClientUtils.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface CCHTransportDEBahnQueryYGeneratorTests : XCTestCase

@end

@implementation CCHTransportDEBahnQueryYGeneratorTests

- (void)testDate
{
    CCHTransportDEBahnQueryYGenerator *generator = [[CCHTransportDEBahnQueryYGenerator alloc] initWithCoordinate:CLLocationCoordinate2DMake(12.3456, -87.654) maxDistance:0 maxNumberOfResults:0];
    NSURLRequest *request = [generator generateRequest];
    NSString *URLString = request.URL.query;
    XCTAssertTrue([URLString containsString:@"look_x=-87654000&look_y=12345600"]); // x = lon * 1E6
}

- (void)testMaxDistance
{
    CCHTransportDEBahnQueryYGenerator *generator = [[CCHTransportDEBahnQueryYGenerator alloc] initWithCoordinate:CLLocationCoordinate2DMake(0, 0) maxDistance:1234.7 maxNumberOfResults:123];
    NSURLRequest *request = [generator generateRequest];
    NSString *URLString = request.URL.query;
    XCTAssertTrue([URLString containsString:@"look_maxdist=1235"]); // rounded to closest value
}

- (void)testMaxNumberOfResults
{
    CCHTransportDEBahnQueryYGenerator *generator = [[CCHTransportDEBahnQueryYGenerator alloc] initWithCoordinate:CLLocationCoordinate2DMake(0, 0) maxDistance:0 maxNumberOfResults:123];
    NSURLRequest *request = [generator generateRequest];
    NSString *URLString = request.URL.query;
    XCTAssertTrue([URLString containsString:@"look_maxno=123"]);
}

@end

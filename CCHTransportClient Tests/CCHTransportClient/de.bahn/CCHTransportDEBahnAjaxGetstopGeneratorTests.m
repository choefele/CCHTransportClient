//
//  CCHTransportDEBahnAjaxGetstopGeneratorTests.m
//  Departures
//
//  Created by Hoefele, Claus on 08.08.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportDEBahnAjaxGetstopGenerator.h"
#import "XCTestCase+CCHTransportClientUtils.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface CCHTransportDEBahnAjaxGetstopGeneratorTests : XCTestCase

@end

@implementation CCHTransportDEBahnAjaxGetstopGeneratorTests

- (void)testSearchString
{
    CCHTransportDEBahnAjaxGetstopGenerator *generator = [[CCHTransportDEBahnAjaxGetstopGenerator alloc] initWithSearchString:@"test 123!" maxNumberOfResults:0];
    NSURLRequest *request = [generator generateRequest];
    NSString *URLString = request.URL.query;
    XCTAssertTrue([URLString containsString:@"REQ0JourneyStopsS0G=test%20123%21?"]);  // ? added by request
}

- (void)testMaxNumberOfResults
{
    CCHTransportDEBahnAjaxGetstopGenerator *generator = [[CCHTransportDEBahnAjaxGetstopGenerator alloc] initWithSearchString:nil maxNumberOfResults:123];
    NSURLRequest *request = [generator generateRequest];
    NSString *URLString = request.URL.query;
    XCTAssertTrue([URLString containsString:@"REQ0JourneyStopsB=123"]);
}

@end

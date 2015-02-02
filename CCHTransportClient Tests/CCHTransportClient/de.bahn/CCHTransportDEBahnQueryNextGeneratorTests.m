//
//  CCHTransportDEBahnQueryNextGeneratorTests.m
//  Departures
//
//  Created by Claus Höfele on 08.08.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportDEBahnQueryNextGenerator.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface CCHTransportDEBahnQueryNextGeneratorTests : XCTestCase

@end

@implementation CCHTransportDEBahnQueryNextGeneratorTests

- (void)testGenerateContext
{
    NSString *context = [CCHTransportDEBahnQueryNextGenerator generateContextWithRequestID:@"requestID" sequenceNumber:123 ld:@"ld"];
    XCTAssertTrue([context containsString:@"ident=requestID"]);
    XCTAssertTrue([context containsString:@"seqnr=123"]);
    XCTAssertTrue([context containsString:@"ld=ld"]);
}

- (void)testDate
{
    NSString *context = [CCHTransportDEBahnQueryNextGenerator generateContextWithRequestID:@"requestID" sequenceNumber:123 ld:@"ld"];
    CCHTransportDEBahnQueryNextGenerator *generator = [[CCHTransportDEBahnQueryNextGenerator alloc] initWithContext:context laterTrips:YES];
    NSURLRequest *request = [generator generateRequest];
    NSString *URLString = request.URL.query;
    XCTAssertTrue([URLString containsString:@"REQ0HafasScrollDir=1"]);
}

@end

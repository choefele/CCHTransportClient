//
//  CCHTransportDEVBBSTBReqGeneratorTests.m
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

//
//  CCHTransportDEBahnQueryGeneratorTests.m
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

#import "CCHTransportDEBahnQueryGenerator.h"
#import "CCHTransportLocation.h"
#import "CCHTransportStation.h"

#import "XCTestCase+CCHTransportClientUtils.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface CCHTransportDEBahnQueryGeneratorTests : XCTestCase

@end

@implementation CCHTransportDEBahnQueryGeneratorTests

- (void)testDate
{
    NSDate *date = [self.class dateFromGMTWithMonth:3 day:17 hour:0 minute:0];
    CCHTransportDEBahnQueryGenerator *generator = [[CCHTransportDEBahnQueryGenerator alloc] initWithDate:date fromLocation:nil toLocation:nil transportModeMask:CCHTransportClientModeAll];
    NSURLRequest *request = [generator generateRequest];
    NSString *URLString = request.URL.query;
    XCTAssertTrue([URLString containsString:@"REQ0JourneyDate=17.03.14"]);
}

- (void)testTime
{
    NSDate *date = [self.class dateFromGMTWithMonth:0 day:0 hour:2 minute:59];
    CCHTransportDEBahnQueryGenerator *generator = [[CCHTransportDEBahnQueryGenerator alloc] initWithDate:date fromLocation:nil toLocation:nil transportModeMask:CCHTransportClientModeAll];
    NSURLRequest *request = [generator generateRequest];
    NSString *URLString = request.URL.query;
    XCTAssertTrue([URLString containsString:@"REQ0JourneyTime=03:59"]); // GMT -> MEZ
}

- (void)testLocationStationID
{
    CCHTransportStation *from = [[CCHTransportStation alloc] initWithStationID:@"12345678" name:nil coordinate:CLLocationCoordinate2DMake(0, 0)];
    CCHTransportStation *to = [[CCHTransportStation alloc] initWithStationID:@"09876543" name:nil coordinate:CLLocationCoordinate2DMake(0, 0)];
    
    CCHTransportDEBahnQueryGenerator *generator = [[CCHTransportDEBahnQueryGenerator alloc] initWithDate:nil fromLocation:from toLocation:to transportModeMask:CCHTransportClientModeAll];
    NSURLRequest *request = [generator generateRequest];
    NSString *URLString = request.URL.query;
    XCTAssertTrue([URLString containsString:@"REQ0JourneyStopsS0ID=A%3D1@L%3D12345678"]);    // '=' -> %3D
    XCTAssertTrue([URLString containsString:@"REQ0JourneyStopsZ0ID=A%3D1@L%3D09876543"]);
}

- (void)testLocationCoordinate
{
    CCHTransportLocation *from = [[CCHTransportLocation alloc] initWithName:nil coordinate:CLLocationCoordinate2DMake(1.2345, -10.9876)];
    CCHTransportLocation *to = [[CCHTransportLocation alloc] initWithName:nil coordinate:CLLocationCoordinate2DMake(-5.6789, 12.3456)];
    
    CCHTransportDEBahnQueryGenerator *generator = [[CCHTransportDEBahnQueryGenerator alloc] initWithDate:nil fromLocation:from toLocation:to transportModeMask:CCHTransportClientModeAll];
    NSURLRequest *request = [generator generateRequest];
    NSString *URLString = request.URL.query;
    XCTAssertTrue([URLString containsString:@"REQ0JourneyStopsS0ID=A%3D16@X%3D-10987600@Y%3D1234500"]);
    XCTAssertTrue([URLString containsString:@"REQ0JourneyStopsZ0ID=A%3D16@X%3D12345600@Y%3D-5678900"]);
}

- (void)testTransportModeMask
{
    NSDictionary *transportModeMasks = @{
        @(CCHTransportClientModeNone) : @"REQ0JourneyProduct_prod_list_1=0000000000",
        @(CCHTransportClientModeSuburbanTrain) : @"REQ0JourneyProduct_prod_list_1=0000100000",
        @(CCHTransportClientModeSubway) : @"REQ0JourneyProduct_prod_list_1=0000000100",
        @(CCHTransportClientModeBus) : @"REQ0JourneyProduct_prod_list_1=0000010000",
        @(CCHTransportClientModeStreetCar) : @"REQ0JourneyProduct_prod_list_1=0000000010",
        @(CCHTransportClientModeRegionalTrain) : @"REQ0JourneyProduct_prod_list_1=0011000000",
        @(CCHTransportClientModeLongDistanceTrain) : @"REQ0JourneyProduct_prod_list_1=1100000000",
        @(CCHTransportClientModeFerry) : @"REQ0JourneyProduct_prod_list_1=0000001000",
        @(CCHTransportClientModeOnDemandService) : @"REQ0JourneyProduct_prod_list_1=0000000001",
        @(CCHTransportClientModeAll) : @"REQ0JourneyProduct_prod_list_1=1111111111",
        @(CCHTransportClientModeSuburbanTrain | CCHTransportClientModeSubway | CCHTransportClientModeBus) : @"REQ0JourneyProduct_prod_list_1=0000110100",
    };
    
    for (NSNumber *transportModeMask in transportModeMasks) {
        CCHTransportDEBahnQueryGenerator *generator = [[CCHTransportDEBahnQueryGenerator alloc] initWithDate:nil fromLocation:nil toLocation:nil transportModeMask:transportModeMask.integerValue];
        NSURLRequest *request = [generator generateRequest];
        NSString *URLString = request.URL.query;
        
        NSString *transportMaskAsString = transportModeMasks[transportModeMask];
        
        if (![URLString containsString:transportMaskAsString]) {
            NSLog(@"");
        }
        
        XCTAssertTrue([URLString containsString:transportMaskAsString]);
    }
    
}

@end

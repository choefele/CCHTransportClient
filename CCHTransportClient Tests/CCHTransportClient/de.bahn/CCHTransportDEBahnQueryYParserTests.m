//
//  CCHTransportDEBahnQueryYParserTests.m
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

#import "CCHTransportDEBahnQueryYParser.h"
#import "CCHTransportStation.h"

#import "XCTestCase+CCHTransportClientUtils.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface CCHTransportDEBahnQueryYParserTests : XCTestCase

@property (nonatomic) CCHTransportDEBahnQueryYParser *parser;

@end

@implementation CCHTransportDEBahnQueryYParserTests

- (void)setUp
{
    [super setUp];
    
    self.parser = [[CCHTransportDEBahnQueryYParser alloc] init];
}

- (void)testParseStations
{
    NSData *data = [self.class loadDataWithFileName:@"query-y" ofType:@"json"];
    NSArray *stations = [self.parser parseResponseWithData:data];
    XCTAssertEqual(stations.count, 4);  // stopweight != 0
    
    CCHTransportStation *station = stations[0];
    XCTAssertEqualWithAccuracy(station.coordinate.latitude, 52.52318, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(station.coordinate.longitude, 13.413946, FLT_EPSILON);
    XCTAssertEqualObjects(station.name, @"Alexanderplatz [Bus] (U), Berlin");
    XCTAssertEqualObjects(station.stationID, @"728658");
}

- (void)testParseStationsInvalidCharacter
{
    NSData *data = [self.class loadDataWithFileName:@"query-y-invalid-character" ofType:@"json"];
    NSArray *stations = [self.parser parseResponseWithData:data];
    XCTAssertEqual(stations.count, 10);
    
    CCHTransportStation *station = stations[2];
    XCTAssertEqualObjects(station.name, @"Julius Kühn-Institut, Kleinmachnow");
}

@end

//
//  CCHTransportDEBahnQueryYParserTests.m
//  Departures
//
//  Created by Claus Höfele on 20.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
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
    XCTAssertEqual(stations.count, 3);
    
    CCHTransportStation *station = stations[0];
    XCTAssertEqualWithAccuracy(station.coordinate.latitude, 52.52318, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(station.coordinate.longitude, 13.413946, FLT_EPSILON);
    XCTAssertEqualObjects(station.name, @"Alexanderplatz [Bus] (U), Berlin");
    XCTAssertEqualObjects(station.stationID, @"728658");
}

@end

//
//  CCHTransportDEBahnAjaxGetstopParserTests.m
//  Departures
//
//  Created by Claus Höfele on 21.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportDEBahnAjaxGetstopParser.h"
#import "CCHTransportStation.h"

#import "XCTestCase+CCHTransportClientUtils.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface CCHTransportDEBahnAjaxGetstopParserTests : XCTestCase

@property (nonatomic) CCHTransportDEBahnAjaxGetstopParser *parser;

@end

@implementation CCHTransportDEBahnAjaxGetstopParserTests

- (void)setUp
{
    [super setUp];
    
    self.parser = [[CCHTransportDEBahnAjaxGetstopParser alloc] init];
}

- (void)testParseStations
{
    NSData *data = [self.class loadDataWithFileName:@"ajax-getstop" ofType:@"json"];
    NSArray *stations = [self.parser parseResponseWithData:data];
    XCTAssertEqual(stations.count, 50);
    
    CCHTransportStation *station = stations[0];
    XCTAssertEqualWithAccuracy(station.coordinate.latitude, 52.521481, FLT_EPSILON);
    XCTAssertEqualWithAccuracy(station.coordinate.longitude, 13.410961, FLT_EPSILON);
    XCTAssertEqualObjects(station.name, @"Berlin Alexanderplatz");
    XCTAssertEqualObjects(station.stationID, @"008011155");
}

@end
//
//  CCHTransportDEBahnBhftafelParserTests.m
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

#import "CCHTransportDEBahnBhftafelParser.h"
#import "CCHTransportDeparture.h"
#import "CCHTransportService.h"
#import "CCHTransportEvent.h"

#import "XCTestCase+CCHTransportClientUtils.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface CCHTransportDEBahnBhftafelParserTests : XCTestCase

@property (nonatomic) CCHTransportDEBahnBhftafelParser *parser;

@end

@implementation CCHTransportDEBahnBhftafelParserTests

- (void)setUp
{
    [super setUp];
    
    self.parser = [[CCHTransportDEBahnBhftafelParser alloc] init];
}

- (void)testDeparturesRegionalTrain
{
    NSData *data = [self.class loadDataWithFileName:@"bhftafel-delay" ofType:@"xml"];
    NSArray *departures = [self.parser parseResponseWithData:data];
    XCTAssertEqual(departures.count, 20);
    
    CCHTransportDeparture *departure = departures[15];
    XCTAssertEqualObjects(departure.event.platform, @"3");
    XCTAssertEqualObjects(departure.service.name, @"RE 18188");
    XCTAssertEqual(departure.service.transportMode, CCHTransportServiceModeRegionalTrain);
    XCTAssertEqualObjects(departure.service.directionName, @"Brandenburg Hbf");
    XCTAssertEqual(departure.service.direction, CCHTransportServiceDirectionUnknown);
    XCTAssertEqualObjects(departure.event.date, [self.class dateFromGMTWithMonth:7 day:13 hour:17 minute:36]);
}

- (void)testDeparturesStreetCar
{
    NSData *data = [self.class loadDataWithFileName:@"bhftafel" ofType:@"xml"];
    NSArray *departures = [self.parser parseResponseWithData:data];
    XCTAssertEqual(departures.count, 20);
    
    CCHTransportDeparture *departure = departures[0];
    XCTAssertNil(departure.event.platform);
    XCTAssertEqualObjects(departure.service.name, @"STR M1");
    XCTAssertEqual(departure.service.transportMode, CCHTransportServiceModeStreetCar);
    XCTAssertEqualObjects(departure.service.directionName, @"Rosenthal Nord, Berlin");
    XCTAssertEqual(departure.service.direction, CCHTransportServiceDirectionUnknown);
    XCTAssertEqualObjects(departure.event.date, [self.class dateFromGMTWithMonth:7 day:12 hour:17 minute:44]);
}

- (void)testDeparturesBus
{
    NSData *data = [self.class loadDataWithFileName:@"bhftafel" ofType:@"xml"];
    NSArray *departures = [self.parser parseResponseWithData:data];
    XCTAssertEqual(departures.count, 20);
    
    CCHTransportDeparture *departure = departures[5];
    XCTAssertNil(departure.event.platform);
    XCTAssertEqualObjects(departure.service.name, @"Bus 147");
    XCTAssertEqual(departure.service.transportMode, CCHTransportServiceModeBus);
    XCTAssertEqualObjects(departure.service.directionName, @"Robert-Koch-Platz, Berlin");
    XCTAssertEqual(departure.service.direction, CCHTransportServiceDirectionUnknown);
    XCTAssertEqualObjects(departure.event.date, [self.class dateFromGMTWithMonth:7 day:12 hour:17 minute:50]);
}

- (void)testDeparturesSuburbanTrain
{
    NSData *data = [self.class loadDataWithFileName:@"bhftafel-delay" ofType:@"xml"];
    NSArray *departures = [self.parser parseResponseWithData:data];
    XCTAssertEqual(departures.count, 20);
    
    CCHTransportDeparture *departure = departures[0];
    XCTAssertEqualObjects(departure.event.platform, @"12");
    XCTAssertEqualObjects(departure.service.name, @"S 1");
    XCTAssertEqual(departure.service.transportMode, CCHTransportServiceModeSuburbanTrain);
    XCTAssertEqualObjects(departure.service.directionName, @"Oranienburg");
    XCTAssertEqual(departure.service.direction, CCHTransportServiceDirectionUnknown);
    XCTAssertEqualObjects(departure.event.date, [self.class dateFromGMTWithMonth:7 day:13 hour:17 minute:27]);
}

- (void)testDeparturesSubway
{
    NSData *data = [self.class loadDataWithFileName:@"bhftafel" ofType:@"xml"];
    NSArray *departures = [self.parser parseResponseWithData:data];
    XCTAssertEqual(departures.count, 20);
    
    CCHTransportDeparture *departure = departures[1];
    XCTAssertNil(departure.event.platform);
    XCTAssertEqualObjects(departure.service.name, @"U 6");
    XCTAssertEqual(departure.service.transportMode, CCHTransportServiceModeSubway);
    XCTAssertEqualObjects(departure.service.directionName, @"Alt-Tegel Bus (U), Berlin");
    XCTAssertEqual(departure.service.direction, CCHTransportServiceDirectionUnknown);
    XCTAssertEqualObjects(departure.event.date, [self.class dateFromGMTWithMonth:7 day:12 hour:17 minute:44]);
}

- (void)testDeparturesDelay
{
    NSData *data = [self.class loadDataWithFileName:@"bhftafel-delay" ofType:@"xml"];
    NSArray *departures = [self.parser parseResponseWithData:data];
    
    CCHTransportDeparture *departure0 = departures[0];
    XCTAssertEqualObjects(departure0.event.date, [self.class dateFromGMTWithMonth:7 day:13 hour:17 minute:27]);
    XCTAssertEqual(departure0.event.delay, 5 * 60);
    XCTAssertNil(departure0.event.delayPlatform);
    
    CCHTransportDeparture *departure1 = departures[1];
    XCTAssertEqualObjects(departure1.event.date, [self.class dateFromGMTWithMonth:7 day:13 hour:17 minute:29]);
    XCTAssertEqual(departure1.event.delay, 10 * 60);
    XCTAssertNil(departure0.event.delayPlatform);
    
    CCHTransportDeparture *departure2 = departures[2];
    XCTAssertEqualObjects(departure2.event.date, [self.class dateFromGMTWithMonth:7 day:13 hour:17 minute:30]);
    XCTAssertEqual(departure2.event.delay, 0 * 60);
    XCTAssertNil(departure2.event.delayPlatform);
}

- (void)testDeparturesMessage
{
    NSData *data = [self.class loadDataWithFileName:@"bhftafel-delay" ofType:@"xml"];
    NSArray *departures = [self.parser parseResponseWithData:data];
    
    CCHTransportDeparture *departure = departures[0];
    XCTAssertNil(departure.message);
    
    CCHTransportDeparture *departure1 = departures[16];
    XCTAssertEqualObjects(departure1.message, @"Sonderfahrt");
}

- (void)testDeparturesCancelled
{
    NSData *data = [self.class loadDataWithFileName:@"bhftafel-delay" ofType:@"xml"];
    NSArray *departures = [self.parser parseResponseWithData:data];
    
    CCHTransportDeparture *departure = departures[13];
    XCTAssertEqualObjects(departure.message, @"Zug gestrichen");
}

@end

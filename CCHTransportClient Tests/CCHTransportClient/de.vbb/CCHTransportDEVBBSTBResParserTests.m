//
//  CCHTransportDEVBBSTBresParserTests.m
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

#import "CCHTransportDEVBBSTBResParser.h"
#import "CCHTransportDeparture.h"
#import "CCHTransportService.h"
#import "CCHTransportEvent.h"

#import "XCTestCase+CCHTransportClientUtils.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface CCHTransportDEVBBSTBresParserTests : XCTestCase

@property (nonatomic) CCHTransportDEVBBSTBResParser *parser;

@end

@implementation CCHTransportDEVBBSTBresParserTests

- (void)setUp
{
    [super setUp];
    
    self.parser = [[CCHTransportDEVBBSTBResParser alloc] init];
}

- (void)testDeparturesRegionalTrain
{
    NSData *data = [self.class loadDataWithFileName:@"STBRes" ofType:@"xml"];
    NSArray *departures = [self.parser parseResponseWithData:data];
    XCTAssertEqual(departures.count, 16);
    
    CCHTransportDeparture *departure = departures[0];
    XCTAssertEqualObjects(departure.event.platform, @"5");
    XCTAssertEqualObjects(departure.service.name, @"RE1");
    XCTAssertEqual(departure.service.transportMode, CCHTransportServiceModeRegionalTrain);
    XCTAssertEqualObjects(departure.service.directionName, @"Brandenburg, Hauptbahnhof");
    XCTAssertEqual(departure.service.direction, CCHTransportServiceDirectionBackward);
    XCTAssertEqualObjects(departure.event.date, [self.class dateFromGMTWithMonth:6 day:25 hour:22 minute:6]);
}

- (void)testDeparturesStreetCar
{
    NSData *data = [self.class loadDataWithFileName:@"STBRes-ubahn" ofType:@"xml"];
    NSArray *departures = [self.parser parseResponseWithData:data];
    
    CCHTransportDeparture *departure = departures[7];
    XCTAssertNil(departure.event.platform);
    XCTAssertEqualObjects(departure.service.name, @"Tram 12");
    XCTAssertEqual(departure.service.transportMode, CCHTransportServiceModeStreetCar);
    XCTAssertEqualObjects(departure.service.directionName, @"Pasedagplatz (Berlin)");
    XCTAssertEqual(departure.service.direction, CCHTransportServiceDirectionBackward);
    XCTAssertEqualObjects(departure.event.date, [self.class dateFromGMTWithMonth:7 day:1 hour:10 minute:51]);
}

- (void)testDeparturesBus
{
    NSData *data = [self.class loadDataWithFileName:@"STBRes" ofType:@"xml"];
    NSArray *departures = [self.parser parseResponseWithData:data];
    XCTAssertEqual(departures.count, 16);
    
    CCHTransportDeparture *departure = departures[1];
    XCTAssertNil(departure.event.platform);
    XCTAssertEqualObjects(departure.service.name, @"Bus 118");
    XCTAssertEqual(departure.service.transportMode, CCHTransportServiceModeBus);
    XCTAssertEqualObjects(departure.service.directionName, @"Zehlendorf Eiche");
    XCTAssertEqual(departure.service.direction, CCHTransportServiceDirectionBackward);
    XCTAssertEqualObjects(departure.event.date, [self.class dateFromGMTWithMonth:6 day:25 hour:22 minute:9]);
}

- (void)testDeparturesSuburbanTrain
{
    NSData *data = [self.class loadDataWithFileName:@"STBRes" ofType:@"xml"];
    NSArray *departures = [self.parser parseResponseWithData:data];
    XCTAssertEqual(departures.count, 16);
    
    CCHTransportDeparture *departure = departures[2];
    XCTAssertEqualObjects(departure.event.platform, @"3");
    XCTAssertEqualObjects(departure.service.name, @"S1");
    XCTAssertEqual(departure.service.transportMode, CCHTransportServiceModeSuburbanTrain);
    XCTAssertEqualObjects(departure.service.directionName, @"S Frohnau (Berlin)");
    XCTAssertEqual(departure.service.direction, CCHTransportServiceDirectionForward);
    XCTAssertEqualObjects(departure.event.date, [self.class dateFromGMTWithMonth:6 day:25 hour:22 minute:12]);
}

- (void)testDeparturesSubway
{
    NSData *data = [self.class loadDataWithFileName:@"STBRes-ubahn" ofType:@"xml"];
    NSArray *departures = [self.parser parseResponseWithData:data];
    
    CCHTransportDeparture *departure = departures[1];
    XCTAssertNil(departure.event.platform);
    XCTAssertEqualObjects(departure.service.name, @"U6");
    XCTAssertEqual(departure.service.transportMode, CCHTransportServiceModeSubway);
    XCTAssertEqualObjects(departure.service.directionName, @"U Alt-Tegel (Berlin)");
    XCTAssertEqual(departure.service.direction, CCHTransportServiceDirectionBackward);
    XCTAssertEqualObjects(departure.event.date, [self.class dateFromGMTWithMonth:7 day:1 hour:10 minute:49]);
}

- (void)testDeparturesFerry
{
    NSData *data = [self.class loadDataWithFileName:@"STBRes-ferry" ofType:@"xml"];
    NSArray *departures = [self.parser parseResponseWithData:data];
    
    CCHTransportDeparture *departure = departures[4];
    XCTAssertNil(departure.event.platform);
    XCTAssertEqualObjects(departure.service.name, @"F10");
    XCTAssertEqual(departure.service.transportMode, CCHTransportServiceModeFerry);
    XCTAssertEqualObjects(departure.service.directionName, @"Alt-Kladow (Berlin)");
    XCTAssertEqual(departure.service.direction, CCHTransportServiceDirectionForward);
    XCTAssertEqualObjects(departure.event.date, [self.class dateFromGMTWithMonth:7 day:10 hour:16 minute:00]);
}

- (void)testDeparturesDelay
{
    NSData *data = [self.class loadDataWithFileName:@"STBRes-delay" ofType:@"xml"];
    NSArray *departures = [self.parser parseResponseWithData:data];
    
    CCHTransportDeparture *departure0 = departures[0];
    XCTAssertEqualObjects(departure0.event.date, [self.class dateFromGMTWithMonth:7 day:10 hour:13 minute:53]);
    XCTAssertEqual(departure0.event.delay, 17 * 60);
    XCTAssertEqualObjects(departure0.event.delayPlatform, @"3");

    CCHTransportDeparture *departure1 = departures[1];
    XCTAssertEqualObjects(departure1.event.date, [self.class dateFromGMTWithMonth:7 day:10 hour:13 minute:55]);
    XCTAssertEqual(departure1.event.delay, 10 * 60);
    XCTAssertEqualObjects(departure1.event.delayPlatform, @"11");

    CCHTransportDeparture *departure2 = departures[6];
    XCTAssertEqualObjects(departure2.event.date, [self.class dateFromGMTWithMonth:7 day:10 hour:14 minute:3]);
    XCTAssertEqual(departure2.event.delay, 0 * 60);
    XCTAssertNil(departure2.event.delayPlatform);

    CCHTransportDeparture *departure3 = departures[7];
    XCTAssertEqualObjects(departure3.event.date, [self.class dateFromGMTWithMonth:7 day:10 hour:14 minute:3]);
    XCTAssertEqual(departure3.event.delay, 0 * 60);
    XCTAssertNil(departure3.event.delayPlatform);
}

- (void)testDeparturesMessage
{
    NSData *data = [self.class loadDataWithFileName:@"STBRes-delay" ofType:@"xml"];
    NSArray *departures = [self.parser parseResponseWithData:data];
    
    CCHTransportDeparture *departure0 = departures[0];
    XCTAssertNil(departure0.message);

    CCHTransportDeparture *departure1 = departures[4];
    XCTAssertEqualObjects(departure1.message, @"Ankündigung! 14.7. bis 25.8. abschnittsweise kein S-Bahn-Verkehr Zoologischer Garten - Ostbahnhof");
}

@end

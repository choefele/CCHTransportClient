//
//  CCHTransportDEVBBConResParser.m
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

#import "CCHTransportDEVBBConResParser.h"

#import "CCHTransportTrip.h"
#import "CCHTransportTripLeg.h"
#import "CCHTransportService.h"
#import "CCHTransportStation.h"
#import "CCHTransportEvent.h"

#import "CCHTransportDEVBBClientUtils.h"

#import <Ono/Ono.h>

@implementation CCHTransportDEVBBConResParser

- (NSArray *)parseResponseWithData:(NSData *)data
{
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:data error:NULL];
    
    NSMutableArray *trips = [NSMutableArray array];
    [document enumerateElementsWithXPath:@"/ResC/ConRes/ConnectionList/Connection" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        NSString *baseDateAsString = [[element firstChildWithXPath:@"Overview/Date"] stringValue];
        NSDate *baseDate = [self.class baseDateFromString:baseDateAsString];
        
        NSMutableArray *legs = [NSMutableArray array];
        [element enumerateElementsWithXPath:@"ConSectionList/ConSection" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
            // Departure
            ONOXMLElement *departureAsXML = [element firstChildWithXPath:@"Departure/BasicStop/Dep[@getIn='YES']"];
            NSString *departureTimeAsString = [[departureAsXML firstChildWithXPath:@"Time"] stringValue];
            NSDate *departureDate = [self.class dateFromString:departureTimeAsString withBaseDate:baseDate];
            NSString *departurePlatform = [[departureAsXML firstChildWithXPath:@"Platform/Text"] stringValue];
            ONOXMLElement *departureDelayAsXML = [element firstChildWithXPath:@"Departure/BasicStop/StopPrognosis/Dep"];
            NSString *departureDelayTimeAsString = [[departureDelayAsXML firstChildWithXPath:@"Time"] stringValue];
            NSDate *departureDelayTime = [self.class dateFromString:departureDelayTimeAsString withBaseDate:baseDate];
            NSTimeInterval departureDelay = [departureDelayTime timeIntervalSinceDate:departureDate];
            NSString *departureDelayPlatform = [[departureDelayAsXML firstChildWithXPath:@"Platform/Text"] stringValue];
            CCHTransportEvent *departure = [[CCHTransportEvent alloc] initWithDate:departureDate platform:departurePlatform delay:departureDelay delayPlatform:departureDelayPlatform];
            
            // Arrival
            ONOXMLElement *arrivalAsXML = [element firstChildWithXPath:@"Arrival/BasicStop/Arr[@getOut='YES']"];
            NSString *arrivalTimeAsString = [[arrivalAsXML firstChildWithXPath:@"Time"] stringValue];
            NSDate *arrivalDate = [self.class dateFromString:arrivalTimeAsString withBaseDate:baseDate];
            NSString *arrivalPlatform = [[arrivalAsXML firstChildWithXPath:@"Platform/Text"] stringValue];
            ONOXMLElement *arrivalDelayAsXML = [element firstChildWithXPath:@"Arrival/BasicStop/StopPrognosis/Arr"];
            NSString *arrivalDelayTimeAsString = [[arrivalDelayAsXML firstChildWithXPath:@"Time"] stringValue];
            NSDate *arrivalDelayTime = [self.class dateFromString:arrivalDelayTimeAsString withBaseDate:baseDate];
            NSTimeInterval arrivalDelay = [arrivalDelayTime timeIntervalSinceDate:arrivalDate];
            NSString *arrivalDelayPlatform = [[arrivalDelayAsXML firstChildWithXPath:@"Platform/Text"] stringValue];
            CCHTransportEvent *arrival = [[CCHTransportEvent alloc] initWithDate:arrivalDate platform:arrivalPlatform delay:arrivalDelay delayPlatform:arrivalDelayPlatform];
            
            // Service
            NSString *serviceName = [[element firstChildWithXPath:@"Journey/JourneyAttributeList//Attribute[@type='NAME']/AttributeVariant/Text"] stringValue];
            NSString *transportModeName = [[element firstChildWithXPath:@"Journey/JourneyAttributeList//Attribute[@type='CATEGORY']/AttributeVariant[@type='NORMAL']/Text"] stringValue];
            CCHTransportServiceMode transportMode = [CCHTransportDEVBBClientUtils transportModeFromString:transportModeName];
            NSString *serviceDirectionName = [[element firstChildWithXPath:@"Journey/JourneyAttributeList//Attribute[@type='DIRECTION']/AttributeVariant/Text"] stringValue];
            CCHTransportService *service = [[CCHTransportService alloc] initWithName:serviceName transportMode:transportMode directionName:serviceDirectionName direction:CCHTransportServiceDirectionUnknown];
        
            NSMutableArray *stops = [NSMutableArray array];
            [element enumerateElementsWithXPath:@"Journey/PassList/BasicStop" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
                ONOXMLElement *stationAsXML = [element firstChildWithXPath:@"Station"];
                NSString *stationID = stationAsXML.attributes[@"externalStationNr"];
                NSString *name = stationAsXML.attributes[@"name"];
                double latitude = [stationAsXML.attributes[@"y"] doubleValue] / 1E6;
                double longitude = [stationAsXML.attributes[@"x"] doubleValue] / 1E6;
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
                
                CCHTransportStation *station = [[CCHTransportStation alloc] initWithStationID:stationID name:name coordinate:coordinate];
                [stops addObject:station];
            }];

            CCHTransportTripLeg *leg = [[CCHTransportTripLeg alloc] initWithDeparture:departure arrival:arrival service:service stops:stops];
            [legs addObject:leg];
        }];
        
        CCHTransportTrip *trip = [[CCHTransportTrip alloc] initWithLegs:legs];
        [trips addObject:trip];
    }];

    return trips;
}

+ (NSDate *)baseDateFromString:(NSString *)string
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyyMMdd";
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CET"];
    });
    
    NSDate *date = [dateFormatter dateFromString:string];
    NSAssert(date, @"Invalid date: %@", string);
    
    return date;
}

+ (NSDate *)dateFromString:(NSString *)string withBaseDate:(NSDate *)baseDate
{
    NSArray *dayTimeComponents = [string componentsSeparatedByString:@"d"];
    NSAssert(dayTimeComponents.count == 2, @"Invalid string: %@", string);
    NSArray *timeComponents = [dayTimeComponents.lastObject componentsSeparatedByString:@":"];
    NSAssert(timeComponents.count == 3, @"Invalid string: %@", string);
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    dateComponents.day = [dayTimeComponents.firstObject integerValue];
    dateComponents.hour = [timeComponents[0] integerValue];
    dateComponents.minute = [timeComponents[1] integerValue];
    dateComponents.second = [timeComponents[2] integerValue];

    NSDate *date = [dateComponents.calendar dateByAddingComponents:dateComponents toDate:baseDate options:0];
    return date;
}

@end

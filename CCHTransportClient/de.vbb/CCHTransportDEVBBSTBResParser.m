//
//  CCHTransportDEVBBSTBResParser.m
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

#import "CCHTransportDEVBBClientUtils.h"

#import <Ono/Ono.h>

@implementation CCHTransportDEVBBSTBResParser

- (NSArray *)parseResponseWithData:(NSData *)data
{
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:data error:NULL];
    
    NSMutableArray *departures = [NSMutableArray array];
    [document enumerateElementsWithXPath:@"/ResC/STBRes/JourneyList/STBJourney" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        NSString *timeString = [[element firstChildWithXPath:@"MainStop/BasicStop/Dep/Time"] stringValue];
        NSDate *eventDate = [self.class dateFromString:timeString];

        NSTimeInterval eventDelay = 0;
        NSString *eventDelayPlatform;
        ONOXMLElement *delayElement = [element firstChildWithXPath:@"MainStop/BasicStop/StopPrognosis"];
        if (delayElement) {
            NSString *delayString = [[delayElement firstChildWithXPath:@"Dep/Time"] stringValue];
            NSDate *delayDate = [self.class dateFromString:delayString];
            eventDelay = [delayDate timeIntervalSinceDate:eventDate];
            eventDelayPlatform = [[delayElement firstChildWithXPath:@"Dep/Platform/Text"] stringValue];
        }
        NSString *eventPlatform = [[element firstChildWithXPath:@"MainStop/BasicStop/Dep/Platform/Text"] stringValue];
        CCHTransportEvent *event = [[CCHTransportEvent alloc] initWithDate:eventDate platform:eventPlatform delay:eventDelay delayPlatform:eventDelayPlatform];
        
        NSString *message = [element firstChildWithXPath:@"IList/I"].attributes[@"header"];
        
        NSString *serviceName = [[element firstChildWithXPath:@"JourneyAttributeList//Attribute[@type='NAME']/AttributeVariant/Text"] stringValue];
        NSString *transportModeName = [[element firstChildWithXPath:@"JourneyAttributeList//Attribute[@type='CATEGORY']/AttributeVariant/Text"] stringValue];
        CCHTransportServiceMode transportMode = [CCHTransportDEVBBClientUtils transportModeFromString:transportModeName];
        NSString *serviceDirectionName = [[element firstChildWithXPath:@"JourneyAttributeList//Attribute[@type='DIRECTION']/AttributeVariant/Text"] stringValue];
        NSString *directionString = [[element firstChildWithXPath:@"JourneyAttributeList//Attribute[@type='DIRECTIONFLAG']/AttributeVariant/Text"] stringValue];
        CCHTransportServiceDirection serviceDirection = [self.class directionFromString:directionString];
        CCHTransportService *service = [[CCHTransportService alloc] initWithName:serviceName transportMode:transportMode directionName:serviceDirectionName direction:serviceDirection];

        CCHTransportDeparture *departure = [[CCHTransportDeparture alloc] initWithMessage:message event:event service:service];
        [departures addObject:departure];
    }];
    
    return departures;
}

+ (CCHTransportServiceDirection)directionFromString:(NSString *)string
{
    NSAssert([string isEqualToString:@"1"] || [string isEqualToString:@"2"] || string == nil, @"Unknown direction: %@", string);
    
    CCHTransportServiceDirection direction;
    if ([string isEqualToString:@"1"]) {
        direction = CCHTransportServiceDirectionForward;
    } else if ([string isEqualToString:@"2"]) {
        direction = CCHTransportServiceDirectionBackward;
    } else {
        direction = CCHTransportServiceDirectionUnknown;
    }

    return direction;
}

+ (NSDate *)dateFromString:(NSString *)string
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd.MM.yy'T'HH:mm";
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CET"];
    });

    NSDate *date = [dateFormatter dateFromString:string];
    NSAssert(date, @"Invalid date: %@", string);

    return date;
}

@end

//
//  CCHTransportDEBahnBhftafelParser.m
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

#import "CCHTransportDEBahnClientUtils.h"

#import <Ono/Ono.h>

@implementation CCHTransportDEBahnBhftafelParser

- (NSArray *)parseResponseWithData:(NSData *)data
{
    // Wrap in a root element to make it valid XML
    NSMutableString *departuresAsString = [[NSMutableString alloc] initWithString:@"<?xml version='1.0' encoding='ISO-8859-1'?><root>"];
    NSMutableString *dataAsString = [[NSMutableString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
    [departuresAsString appendString:dataAsString];
    [departuresAsString appendString:@"</root>"];
    
    ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithString:departuresAsString encoding:NSISOLatin1StringEncoding error:NULL];
    
    NSMutableArray *departures = [NSMutableArray array];
    [document enumerateElementsWithXPath:@"/root/Journey" usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
        NSDate *eventDate = [self.class dateFromTimeString:element.attributes[@"fpTime"] dateString:element.attributes[@"fpDate"]];
        NSTimeInterval eventDelay = [element.attributes[@"e_delay"] doubleValue] * 60;
        NSString *eventPlatform = element.attributes[@"platform"];
        CCHTransportEvent *event = [[CCHTransportEvent alloc] initWithDate:eventDate platform:eventPlatform delay:eventDelay delayPlatform:nil];
        
        NSString *message = [element firstChildWithTag:@"HIMMessage"].attributes[@"header"];
        message = [self.class messageFromDelayString:element.attributes[@"delay"] messageString:message];
        
        NSString *serviceDirectionName = element.attributes[@"targetLoc"];
        NSString *prodString = element.attributes[@"prod"];
        CCHTransportServiceMode transportMode = [self.class transportModeFromString:prodString];
        NSString *serviceName = [self.class transportNameFromString:prodString];
        CCHTransportService *service = [[CCHTransportService alloc] initWithName:serviceName transportMode:transportMode directionName:serviceDirectionName direction:CCHTransportServiceDirectionUnknown];
    
        CCHTransportDeparture *departure = [[CCHTransportDeparture alloc] initWithMessage:message event:event service:service];
        [departures addObject:departure];
    }];
     
    return departures;
}

+ (CCHTransportServiceMode)transportModeFromString:(NSString *)string
{
    static NSDictionary *nameToModeMap;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nameToModeMap = @{
          @"S"     : @(CCHTransportServiceModeSuburbanTrain),
          @"U"     : @(CCHTransportServiceModeSubway),
          @"Bus"   : @(CCHTransportServiceModeBus),
          @"STR"   : @(CCHTransportServiceModeStreetCar),
          @"RE"    : @(CCHTransportServiceModeRegionalTrain),
          @"RB"    : @(CCHTransportServiceModeRegionalTrain),
          @"IC"    : @(CCHTransportServiceModeLongDistanceTrain),
          @"CNL"   : @(CCHTransportServiceModeLongDistanceTrain),
          @"Fähre" : @(CCHTransportServiceModeFerry)
        };
    });
    
    // Format "<transport name>#<category>"
    NSArray *components = [string componentsSeparatedByString:@"#"];
    NSAssert(components.count == 2, @"Invalid category string: %@", string);
    
    NSInteger transportMode = CCHTransportServiceModeUnknown;
    if (components.count > 1) {
        transportMode = [nameToModeMap[components[1]] integerValue];
        NSAssert(transportMode != CCHTransportServiceModeUnknown, @"Unknown transport mode: %@", string);
    }
    
    return transportMode;
}

+ (NSString *)transportNameFromString:(NSString *)string
{
    // Format "<transport name>#<category>"
    NSArray *components = [string componentsSeparatedByString:@"#"];
    NSAssert(components.count == 2, @"Invalid category string: %@", string);

    NSString *transportName;
    if (components.count > 0) {
        transportName = [CCHTransportDEBahnClientUtils normalizeWhiteSpaceForString:components[0]];
    }
    
    return transportName;
}


+ (NSDate *)dateFromTimeString:(NSString *)timeString dateString:(NSString *)dateString
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd.MM.yy'T'HH:mm";
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CET"];
    });
    
    NSString *dateTimeString = [NSString stringWithFormat:@"%@T%@", dateString, timeString];
    NSDate *date = [dateFormatter dateFromString:dateTimeString];
    NSAssert(date, @"Invalid date: %@", dateTimeString);
    
    return date;
}

+ (NSString *)messageFromDelayString:(NSString *)delayString messageString:(NSString *)messageString
{
    NSString *message;

    if (messageString) {
        message = messageString;
    } else if ([delayString isEqualToString:@"cancel"]) {
        message = @"Zug gestrichen";
    }
    
    return message;
}

@end

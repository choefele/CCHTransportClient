//
//  CCHTransportDEVBBClientUtils.m
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

#import "CCHTransportDEVBBClientUtils.h"

static NSString * const API_URL_TEST = @"http://demo.hafas.de/bin/pub/vbb/extxml.exe";

@implementation CCHTransportDEVBBClientUtils

+ (NSMutableURLRequest *)URLRequestWithData:(NSString *)data accessID:(NSString *)accessID
{
    NSURL *URL = [NSURL URLWithString:API_URL_TEST];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    NSString *dataAsXML = [self.class XMLForPayload:data accessID:accessID];
    request.HTTPBody = [dataAsXML dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";

    return request;
}

+ (NSString *)XMLForPayload:(NSString *)payload accessID:(NSString *)accessID
{
    NSString *xmlFormat = @"<?xml version='1.0' encoding='utf-8'?><ReqC lang='%@' prod='testsystem' ver='1.1' accessId='%@'>%@</ReqC>";
    NSString *languageIdentifier = [self.class languageIdentifier];
    NSString *xml = [NSString stringWithFormat:xmlFormat, languageIdentifier, accessID, payload];
    
    return xml;
}

+ (NSString *)timeStringFromDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"HH:mm";
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CET"];
    });
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)dateStringFromDate:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyyMMdd";
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"CET"];
    });
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)languageIdentifier
{
    NSString *languageIdentifier;
    
    NSArray *preferredLanguages = [NSLocale preferredLanguages];
    BOOL useGermanLanguage = preferredLanguages.count > 0 && [preferredLanguages[0] hasPrefix:@"de"];
    if (useGermanLanguage) {
        languageIdentifier = @"DE";
    } else {
        languageIdentifier = @"EN";
    }
    
    return languageIdentifier;
}

+ (CCHTransportServiceMode)transportModeFromString:(NSString *)string
{
    static NSDictionary *nameToTransportModeMap;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nameToTransportModeMap = @{
              @"S"     : @(CCHTransportServiceModeSuburbanTrain),
              @"U"     : @(CCHTransportServiceModeSubway),
              @"Bus"   : @(CCHTransportServiceModeBus),
              @"Tram"  : @(CCHTransportServiceModeStreetCar),
              @"RE"    : @(CCHTransportServiceModeRegionalTrain),
              @"RB"    : @(CCHTransportServiceModeRegionalTrain),
              @"IC"    : @(CCHTransportServiceModeLongDistanceTrain),
              @"CNL"   : @(CCHTransportServiceModeLongDistanceTrain),
              @"Fähre" : @(CCHTransportServiceModeFerry)
        };
    });
    
    NSString *transportModeAsString = [string stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
    NSInteger transportMode = [nameToTransportModeMap[transportModeAsString] integerValue];
    NSAssert(transportMode != CCHTransportServiceModeUnknown, @"Unknown transport mode: %@", string);
    
    return transportMode;
}

@end

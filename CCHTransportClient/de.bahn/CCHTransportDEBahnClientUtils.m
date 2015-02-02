//
//  CCHTransportDEBahnClientUtils.m
//  Departures
//
//  Created by Claus Höfele on 21.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportDEBahnClientUtils.h"

@implementation CCHTransportDEBahnClientUtils

+ (NSString *)languageIdentifier
{
    NSString *languageIdentifier;
    
    NSArray *preferredLanguages = [NSLocale preferredLanguages];
    BOOL useGermanLanguage = preferredLanguages.count > 0 && [preferredLanguages[0] hasPrefix:@"de"];
    if (useGermanLanguage) {
        languageIdentifier = @"dn";
    } else {
        languageIdentifier = @"en";
    }
    
    return languageIdentifier;
}

+ (NSString *)normalizeWhiteSpaceForString:(NSString *)string
{
    NSString *result = [string stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
    result = [result stringByReplacingOccurrencesOfString:@"[ ]+"
                                               withString:@" "
                                                  options:NSRegularExpressionSearch
                                                    range:NSMakeRange(0, result.length)];

    return result;
}

+ (NSString *)encodeQueryValue:(NSString *)string withEncoding:(NSStringEncoding)encoding
{
    CFStringEncoding encodingCF = CFStringConvertNSStringEncodingToEncoding(encoding);
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)string, NULL, CFSTR("!*'();:@&=+$,/?%#[]\" "), encodingCF));
    
    return escapedString;
}

@end

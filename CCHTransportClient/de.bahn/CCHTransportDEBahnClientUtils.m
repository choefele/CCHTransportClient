//
//  CCHTransportDEBahnClientUtils.m
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

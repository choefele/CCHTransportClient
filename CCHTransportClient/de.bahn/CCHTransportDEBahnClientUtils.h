//
//  CCHTransportDEBahnClientUtils.h
//  Departures
//
//  Created by Claus Höfele on 21.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCHTransportDEBahnClientUtils : NSObject

+ (NSString *)languageIdentifier;
+ (NSString *)normalizeWhiteSpaceForString:(NSString *)string;
+ (NSString *)encodeQueryValue:(NSString *)string withEncoding:(NSStringEncoding)encoding;

@end

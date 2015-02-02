//
//  CCHTransportDEVBBClientUtils.h
//  Departures
//
//  Created by Claus Höfele on 08.08.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCHTransportService.h"

@interface CCHTransportDEVBBClientUtils : NSObject

+ (NSMutableURLRequest *)URLRequestWithData:(NSString *)data accessID:(NSString *)accessID;

+ (NSString *)timeStringFromDate:(NSDate *)date;
+ (NSString *)dateStringFromDate:(NSDate *)date;
+ (NSString *)languageIdentifier;
+ (CCHTransportServiceMode)transportModeFromString:(NSString *)string;

@end

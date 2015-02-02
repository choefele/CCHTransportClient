//
//  CCHTransportDEBahnQueryParser.h
//  Departures
//
//  Created by Claus Höfele on 23.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCHTransportParser.h"

extern NSString * const CCHTransportDEBahnQueryParserResultTripsKey;
extern NSString * const CCHTransportDEBahnQueryParserResultContextKey;
extern NSString * const CCHTransportDEBahnQueryParserResultErrorKey;

@interface CCHTransportDEBahnQueryParser : NSObject<CCHTransportParser>

- (NSDictionary *)parseResponseWithData:(NSData *)data;

@end

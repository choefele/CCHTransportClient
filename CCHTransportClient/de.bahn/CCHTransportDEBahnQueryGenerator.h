//
//  CCHTransportDEBahnQueryGenerator.h
//  Departures
//
//  Created by Claus Höfele on 23.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCHTransportGenerator.h"
#import "CCHTransportClient.h"

@class CCHTransportLocation;

@interface CCHTransportDEBahnQueryGenerator : NSObject<CCHTransportGenerator>

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDate:(NSDate *)date fromLocation:(CCHTransportLocation *)fromLocation toLocation:(CCHTransportLocation *)toLocation transportModeMask:(CCHTransportClientMode)transportModeMask NS_DESIGNATED_INITIALIZER;
- (NSURLRequest *)generateRequest;

@end

//
//  CCHTransportDEVBBReqCGenerator.h
//  Departures
//
//  Created by Claus Höfele on 08.08.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCHTransportGenerator.h"

@class CCHTransportLocation;

@interface CCHTransportDEVBBConReqGenerator : NSObject<CCHTransportGenerator>

- (instancetype)initWithAccessID:(NSString *)accessID date:(NSDate *)date fromLocation:(CCHTransportLocation *)fromLocation toLocation:(CCHTransportLocation *)toLocation maxNumberOfResults:(NSUInteger)maxNumberOfResults NS_DESIGNATED_INITIALIZER;
- (NSURLRequest *)generateRequest;

@end

//
//  CCHTransportDEBahnQueryNextGenerator.h
//  Departures
//
//  Created by Claus Höfele on 08.08.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCHTransportGenerator.h"

@interface CCHTransportDEBahnQueryNextGenerator : NSObject<CCHTransportGenerator>

- (instancetype)initWithContext:(NSString *)context laterTrips:(BOOL)laterTrips NS_DESIGNATED_INITIALIZER;
- (NSURLRequest *)generateRequest;

+ (NSString *)generateContextWithRequestID:(NSString *)requestID sequenceNumber:(short)sequenceNumber ld:(NSString *)ld;

@end

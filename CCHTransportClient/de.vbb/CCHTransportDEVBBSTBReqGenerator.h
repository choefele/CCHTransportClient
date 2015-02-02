//
//  CCHTransportClientVBBSTBReqGenerator.h
//  Abfahrt Berlin
//
//  Created by Hoefele, Claus on 26.06.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCHTransportGenerator.h"

@interface CCHTransportDEVBBSTBReqGenerator : NSObject<CCHTransportGenerator>

- (instancetype)initWithAccessID:(NSString *)accessID date:(NSDate *)date stationID:(NSString *)stationID maxNumberOfResults:(NSUInteger)maxNumberOfResults NS_DESIGNATED_INITIALIZER;
- (NSURLRequest *)generateRequest;

@end

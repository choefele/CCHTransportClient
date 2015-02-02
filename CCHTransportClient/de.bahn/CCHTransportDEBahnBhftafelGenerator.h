//
//  CCHTransportDEBahnBhftafelGenerator.h
//  Departures
//
//  Created by Claus Höfele on 12.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCHTransportGenerator.h"

@interface CCHTransportDEBahnBhftafelGenerator : NSObject<CCHTransportGenerator>

- (instancetype)initWithDate:(NSDate *)date stationID:(NSString *)stationID maxNumberOfResults:(NSUInteger)maxNumberOfResults NS_DESIGNATED_INITIALIZER;
- (NSURLRequest *)generateRequest;

@end

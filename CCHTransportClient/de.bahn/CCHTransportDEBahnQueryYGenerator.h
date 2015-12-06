//
//  CCHTransportDEBahnQueryYGenerator.h
//  Departures
//
//  Created by Claus Höfele on 18.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "CCHTransportGenerator.h"

@interface CCHTransportDEBahnQueryYGenerator : NSObject<CCHTransportGenerator>

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate maxDistance:(CLLocationDistance)maxDistance maxNumberOfResults:(NSUInteger)maxNumberOfResults NS_DESIGNATED_INITIALIZER;
- (NSURLRequest *)generateRequest;

@end

//
//  CCHTransportStation.h
//  Departures
//
//  Created by Hoefele, Claus on 09.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "CCHTransportLocation.h"

@interface CCHTransportStation : CCHTransportLocation

@property (nonatomic, copy, readonly) NSString *stationID;

- (instancetype)initWithStationID:(NSString *)stationID
                             name:(NSString *)name
                       coordinate:(CLLocationCoordinate2D)coordinate NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

@end

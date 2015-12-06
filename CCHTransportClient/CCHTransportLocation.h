//
//  CCHTransportLocation.h
//  Departures
//
//  Created by Claus Höfele on 03.08.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CCHTransportLocation : NSObject<NSSecureCoding, NSCopying>

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithName:(NSString *)name
                  coordinate:(CLLocationCoordinate2D)coordinate NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

@end

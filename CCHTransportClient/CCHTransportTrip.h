//
//  CCHTransportTrip.h
//  Departures
//
//  Created by Claus Höfele on 26.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCHTransportTrip : NSObject<NSSecureCoding, NSCopying>

@property (nonatomic, copy, readonly) NSArray *legs;    // CCHTransportTripLeg
@property (nonatomic, readonly) NSUInteger numberOfChanges;

- (instancetype)initWithLegs:(NSArray *)legs NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

@end
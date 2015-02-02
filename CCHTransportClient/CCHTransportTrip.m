//
//  CCHTransportTrip.m
//  Departures
//
//  Created by Claus Höfele on 26.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportTrip.h"

#import "CCHTransportTripLeg.h"
#import "CCHTransportService.h"
#import "CCHTransportEvent.h"
#import "CCHTransportService.h"
#import "CCHTransportLocation.h"
#import "CCHTransportStation.h"

@implementation CCHTransportTrip

- (instancetype)initWithLegs:(NSArray *)legs
{
    self = [super init];
    if (self) {
        _legs = legs;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _legs = [coder decodeObjectOfClass:NSArray.class forKey:@"legs"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.legs forKey:@"legs"];
}

- (NSUInteger)numberOfChanges
{
    NSInteger numberOfChanges = -1;
    for (CCHTransportTripLeg *leg in self.legs) {
        // Walks don't count towards changes
        if (leg.service.transportMode != CCHTransportServiceModePedestrian) {
            numberOfChanges++;
        }
    }

    return MAX(0, numberOfChanges);
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return self;    // immutable
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<Trip: "];
    for (CCHTransportTripLeg *leg in self.legs) {
        [description appendFormat:@"%@", leg];
    }
    [description appendString:@">"];

    return description;
}

@end
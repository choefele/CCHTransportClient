//
//  CCHtransportTripLeg.m
//  Departures
//
//  Created by Claus Höfele on 26.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportTripLeg.h"

#import "CCHTransportLocation.h"
#import "CCHTransportEvent.h"
#import "CCHTransportService.h"

@implementation CCHTransportTripLeg

- (instancetype)initWithDeparture:(CCHTransportEvent *)departure arrival:(CCHTransportEvent *)arrival service:(CCHTransportService *)service stops:(NSArray *)stops
{
    self = [super init];
    if (self) {
        _departure = departure;
        _arrival = arrival;
        _service = service;
        _stops = stops;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _departure = [coder decodeObjectOfClass:CCHTransportEvent.class forKey:@"departure"];
        _arrival = [coder decodeObjectOfClass:CCHTransportEvent.class forKey:@"arrival"];
        _service = [coder decodeObjectOfClass:CCHTransportService.class forKey:@"service"];
        _stops = [coder decodeObjectOfClass:NSArray.class forKey:@"stops"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.departure forKey:@"departure"];
    [coder encodeObject:self.arrival forKey:@"arrival"];
    [coder encodeObject:self.service forKey:@"service"];
    [coder encodeObject:self.stops forKey:@"stops"];
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return self;    // immutable
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithString:@"<Trip leg: "];
    
    [description appendFormat:@"<Departure: %@>", self.departure];
    [description appendFormat:@"<Arrival: %@>", self.arrival];
    [description appendFormat:@"%@", self.service];
    for (CCHTransportLocation *stop in self.stops) {
        [description appendFormat:@"%@", stop];
    }
    [description appendString:@">"];

    return description;
}

@end

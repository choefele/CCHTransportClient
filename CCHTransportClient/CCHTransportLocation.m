//
//  CCHTransportLocation.m
//  Departures
//
//  Created by Claus Höfele on 03.08.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportLocation.h"

@implementation CCHTransportLocation

- (instancetype)initWithName:(NSString *)name coordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if (self) {
        _name = name;
        _coordinate = coordinate;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _name = [coder decodeObjectOfClass:NSString.class forKey:@"name"];
        double latitude = [coder decodeDoubleForKey:@"coordinate.latitude"];
        double longitude = [coder decodeDoubleForKey:@"coordinate.longitude"];
        _coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    }
    return self;
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeDouble:self.coordinate.latitude forKey:@"coordinate.latitude"];
    [coder encodeDouble:self.coordinate.longitude forKey:@"coordinate.longitude"];
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return self;    // immutable
}

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"<Location name: %@, coordinate: (%f, %f)>", self.name, self.coordinate.latitude, self.coordinate.longitude];
    return description;
}

@end

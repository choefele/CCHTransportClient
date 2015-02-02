//
//  CCHTransportService.m
//  Departures
//
//  Created by Claus Höfele on 05.08.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportService.h"

@implementation CCHTransportService

- (instancetype)initWithName:(NSString *)name transportMode:(CCHTransportServiceMode)transportMode directionName:(NSString *)directionName direction:(CCHTransportServiceDirection)direction
{
    self = [super init];
    if (self) {
        _name = name;
        _transportMode = transportMode;
        _directionName = directionName;
        _direction = direction;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _name = [coder decodeObjectOfClass:NSString.class forKey:@"name"];
        _transportMode = [coder decodeIntegerForKey:@"category"];
        _directionName = [coder decodeObjectOfClass:NSString.class forKey:@"directionName"];
        _direction = [coder decodeIntegerForKey:@"direction"];
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
    [coder encodeInteger:self.transportMode forKey:@"category"];
    [coder encodeObject:self.directionName forKey:@"directionName"];
    [coder encodeInteger:self.direction forKey:@"direction"];
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return self;    // immutable
}

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"<Service name: %@, category: %tu, direction: %@ (%tu)>", self.name, self.transportMode, self.directionName, self.direction];
    return description;
}

@end

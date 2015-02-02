//
//  CCHTransportStation.m
//  Departures
//
//  Created by Hoefele, Claus on 09.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportStation.h"

@implementation CCHTransportStation

- (instancetype)initWithName:(NSString *)name coordinate:(CLLocationCoordinate2D)coordinate
{
    return [self initWithStationID:nil name:name coordinate:coordinate];
}

- (instancetype)initWithStationID:(NSString *)stationID name:(NSString *)name coordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super initWithName:name coordinate:coordinate];
    if (self) {
        _stationID = stationID;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _stationID = [coder decodeObjectOfClass:NSString.class forKey:@"stationID"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [super encodeWithCoder:coder];
    [coder encodeObject:self.stationID forKey:@"stationID"];
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return self;    // immutable
}

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"<Station name: %@, ID: %@, coordinate: (%f, %f)>", self.name, self.stationID, self.coordinate.latitude, self.coordinate.longitude];
    return description;
}

@end

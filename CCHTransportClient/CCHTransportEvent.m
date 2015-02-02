//
//  CCHTransportEvent.m
//  Departures
//
//  Created by Hoefele, Claus on 06.08.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportEvent.h"

@implementation CCHTransportEvent

- (instancetype)initWithDate:(NSDate *)date platform:(NSString *)platform delay:(NSTimeInterval)delay delayPlatform:(NSString *)delayPlatform
{
    self = [super init];
    if (self) {
        _date = date;
        _platform = platform;
        _delay = delay;
        _delayPlatform = delayPlatform;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _date = [coder decodeObjectOfClass:NSDate.class forKey:@"date"];
        _platform = [coder decodeObjectOfClass:NSString.class forKey:@"platform"];
        _delay = [coder decodeDoubleForKey:@"delay"];
        _delayPlatform = [coder decodeObjectOfClass:NSString.class forKey:@"delayPlatform"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.date forKey:@"date"];
    [coder encodeObject:self.platform forKey:@"platform"];
    [coder encodeDouble:self.delay forKey:@"delay"];
    [coder encodeObject:self.delayPlatform forKey:@"delayPlatform"];
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return self;    // immutable
}

- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"<Event date: %@, platform: %@, delay: %f, delay platform: %@>", self.date, self.platform, self.delay, self.delayPlatform];
    return description;
}

@end

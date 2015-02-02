//
//  CCHTransportDeparture.m
//  Abfahrt Berlin
//
//  Created by Hoefele, Claus on 26.06.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportDeparture.h"

#import "CCHTransportService.h"
#import "CCHTransportEvent.h"

@implementation CCHTransportDeparture

- (instancetype)initWithMessage:(NSString *)message event:(CCHTransportEvent *)event service:(CCHTransportService *)service
{
    self = [super init];
    if (self) {
        _message = message;
        _event = event;
        _service = service;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _message = [coder decodeObjectOfClass:NSString.class forKey:@"message"];
        _event = [coder decodeObjectOfClass:CCHTransportEvent.class forKey:@"event"];
        _service = [coder decodeObjectOfClass:CCHTransportService.class forKey:@"service"];
    }
    return self;
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:self.message forKey:@"message"];
    [coder encodeObject:self.event forKey:@"event"];
    [coder encodeObject:self.service forKey:@"service"];
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    return self;    // immutable
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithString:@"<Departure: "];
    
    [description appendFormat:@"<Message: %@>", self.message];
    [description appendFormat:@"<Event: %@>", self.event];
    [description appendFormat:@"<Service: %@>", self.service];
    [description appendString:@">"];
    
    return description;
}

@end

//
//  CCHTransportDeparture.m
//  CCHTransportClient
//
//  Copyright (C) 2015 Claus Höfele
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
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

//
//  CCHTransportTripLeg.m
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

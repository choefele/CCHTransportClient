//
//  CCHTransportTrip.m
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
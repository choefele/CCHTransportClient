//
//  CCHTransportEvent.m
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

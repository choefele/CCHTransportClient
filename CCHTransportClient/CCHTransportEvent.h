//
//  CCHTransportEvent.h
//  Departures
//
//  Created by Hoefele, Claus on 06.08.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCHTransportEvent : NSObject<NSSecureCoding, NSCopying>

@property (nonatomic, copy, readonly) NSDate *date;
@property (nonatomic, copy, readonly) NSString *platform;
@property (nonatomic, readonly) NSTimeInterval delay;
@property (nonatomic, copy, readonly) NSString *delayPlatform;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDate:(NSDate *)date
                    platform:(NSString *)platform
                       delay:(NSTimeInterval)delay
               delayPlatform:(NSString *)delayPlatform NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

@end

//
//  CCHTransportDeparture.h
//  Abfahrt Berlin
//
//  Created by Hoefele, Claus on 26.06.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCHTransportService;
@class CCHTransportEvent;

@interface CCHTransportDeparture : NSObject<NSSecureCoding, NSCopying>

@property (nonatomic, copy, readonly) NSString *message;
@property (nonatomic, readonly) CCHTransportEvent *event;
@property (nonatomic, readonly) CCHTransportService *service;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMessage:(NSString *)message
                          event:(CCHTransportEvent *)event
                        service:(CCHTransportService *)service NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

@end
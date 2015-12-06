//
//  CCHtransportTripLeg.h
//  Departures
//
//  Created by Claus Höfele on 26.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCHTransportService;
@class CCHTransportEvent;

@interface CCHTransportTripLeg : NSObject<NSSecureCoding, NSCopying>

@property (nonatomic, readonly) CCHTransportEvent *departure;
@property (nonatomic, readonly) CCHTransportEvent *arrival;
@property (nonatomic, readonly) CCHTransportService *service;
@property (nonatomic, copy, readonly) NSArray *stops; // CCHTransportLocation

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDeparture:(CCHTransportEvent *)departure arrival:(CCHTransportEvent *)arrival service:(CCHTransportService *)service stops:(NSArray *)stops NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

@end

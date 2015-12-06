//
//  CCHTransportService.h
//  Departures
//
//  Created by Claus Höfele on 05.08.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CCHTransportServiceMode) {
    CCHTransportServiceModeUnknown,
    CCHTransportServiceModeSuburbanTrain,
    CCHTransportServiceModeSubway,
    CCHTransportServiceModeBus,
    CCHTransportServiceModeStreetCar,
    CCHTransportServiceModeRegionalTrain,
    CCHTransportServiceModeLongDistanceTrain,
    CCHTransportServiceModeFerry,
    CCHTransportServiceModePedestrian,
    CCHTransportServiceModeOnDemandService
};

typedef NS_ENUM(NSInteger, CCHTransportServiceDirection) {
    CCHTransportServiceDirectionUnknown,
    CCHTransportServiceDirectionForward,
    CCHTransportServiceDirectionBackward
};

@interface CCHTransportService : NSObject<NSSecureCoding, NSCopying>

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, readonly) CCHTransportServiceMode transportMode;
@property (nonatomic, copy, readonly) NSString *directionName;
@property (nonatomic, readonly) CCHTransportServiceDirection direction;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithName:(NSString *)name transportMode:(CCHTransportServiceMode)transportMode directionName:(NSString *)directionName direction:(CCHTransportServiceDirection)direction NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

@end

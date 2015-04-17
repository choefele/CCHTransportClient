//
//  CCHTransportClient.h
//  Abfahrt Berlin
//
//  Created by Claus Höfele on 28.06.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CCHTransportLocation;
@protocol CCHTransportClientDelegate;

typedef NS_OPTIONS(NSInteger, CCHTransportClientMode) {
    CCHTransportClientModeNone              = 0,
    CCHTransportClientModeSuburbanTrain     = 1 << 0,
    CCHTransportClientModeSubway            = 1 << 1,
    CCHTransportClientModeBus               = 1 << 2,
    CCHTransportClientModeStreetCar         = 1 << 3,
    CCHTransportClientModeRegionalTrain     = 1 << 4,
    CCHTransportClientModeLongDistanceTrain = 1 << 5,
    CCHTransportClientModeFerry             = 1 << 6,
    CCHTransportClientModeOnDemandService   = 1 << 7,
    CCHTransportClientModeAll               = ~0
};

@protocol CCHTransportClient <NSObject>

@property (nonatomic, weak) NSObject<CCHTransportClientDelegate> *delegate;

@optional
- (NSURLSessionTask *)retrieveDeparturesForDate:(nullable NSDate *)date stationID:(NSString *)stationID maxNumberOfResults:(NSUInteger)maxNumberOfResults completionHandler:(void (^)(NSArray *departures, NSError * __nullable error))completionHandler;
- (NSURLSessionTask *)retrieveStationsNearCoordinate:(CLLocationCoordinate2D)coordinate maxDistance:(CLLocationDistance)maxDistance maxNumberOfResults:(NSUInteger)maxNumberOfResults completionHandler:(void (^)(NSArray *stations, NSError * __nullable error))completionHandler;
- (NSURLSessionTask *)retrieveStationsForSearchString:(NSString *)searchString maxNumberOfResults:(NSUInteger)maxNumberOfResults completionHandler:(void (^)(NSArray *stations, NSError * __nullable error))completionHandler;
- (NSURLSessionTask *)retrieveTripsForDate:(nullable NSDate *)date fromLocation:(CCHTransportLocation *)fromLocation toLocation:(CCHTransportLocation *)toLocation transportModeMask:(CCHTransportClientMode)transportModeMask maxNumberOfResults:(NSUInteger)maxNumberOfResults completionHandler:(void (^)(NSArray *trips,  __nullable id context, NSError * __nullable error))completionHandler;
- (NSURLSessionTask *)retrieveMoreTripsWithContext:(id)context forward:(BOOL)forward maxNumberOfResults:(NSUInteger)maxNumberOfResults completionHandler:(void (^)(NSArray *trips, __nullable id context, NSError * __nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
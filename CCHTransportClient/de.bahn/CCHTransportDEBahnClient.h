//
//  CCHTransportDEBahnClient.h
//  Abfahrt Berlin
//
//  Created by Claus Höfele on 04.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "CCHTransportClient.h"

extern NSString * const CCHTransportDEBahnClientErrorDomain;

@interface CCHTransportDEBahnClient : NSObject<CCHTransportClient>

- (instancetype)init NS_DESIGNATED_INITIALIZER;

- (NSURLSessionTask *)retrieveDeparturesForDate:(NSDate *)date stationID:(NSString *)stationID maxNumberOfResults:(NSUInteger)maxNumberOfResults completionHandler:(void (^)(NSArray *departures, NSError *error))completionHandler;
- (NSURLSessionTask *)retrieveStationsNearCoordinate:(CLLocationCoordinate2D)coordinate maxDistance:(CLLocationDistance)maxDistance maxNumberOfResults:(NSUInteger)maxNumberOfResults completionHandler:(void (^)(NSArray *stations, NSError *error))completionHandler;
- (NSURLSessionTask *)retrieveStationsForSearchString:(NSString *)searchString maxNumberOfResults:(NSUInteger)maxNumberOfResults completionHandler:(void (^)(NSArray *stations, NSError *error))completionHandler;
- (NSURLSessionTask *)retrieveTripsForDate:(NSDate *)date fromLocation:(CCHTransportLocation *)fromLocation toLocation:(CCHTransportLocation *)toLocation transportModeMask:(CCHTransportClientMode)transportModeMask maxNumberOfResults:(NSUInteger)maxNumberOfResults completionHandler:(void (^)(NSArray *trips, id context, NSError *error))completionHandler;
- (NSURLSessionTask *)retrieveMoreTripsWithContext:(id)context forward:(BOOL)forward maxNumberOfResults:(NSUInteger)maxNumberOfResults completionHandler:(void (^)(NSArray *trips, id context, NSError *error))completionHandler;

@end

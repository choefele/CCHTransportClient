//
//  CCHTransportDEVBBClient.h
//  Abfahrt Berlin
//
//  Created by Hoefele, Claus on 19.06.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCHTransportClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCHTransportDEVBBClient : NSObject<CCHTransportClient>

- (instancetype)initWithAccessID:(NSString *)accessID NS_DESIGNATED_INITIALIZER;

- (NSURLSessionTask *)retrieveDeparturesForDate:(nullable NSDate *)date stationID:(NSString *)stationID maxNumberOfResults:(NSUInteger)maxNumberOfResults completionHandler:(void (^)(NSArray * __nullable departures, NSError * __nullable error))completionHandler;
- (NSURLSessionTask *)retrieveTripsForDate:(nullable NSDate *)date fromLocation:(CCHTransportLocation *)fromLocation toLocation:(CCHTransportLocation *)toLocation maxNumberOfResults:(NSUInteger)maxNumberOfResults completionHandler:(void (^)(NSArray * __nullable trips,  __nullable id context, NSError * __nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
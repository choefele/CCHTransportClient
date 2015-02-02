//
//  CCHTransportDEVBBClient.h
//  Abfahrt Berlin
//
//  Created by Hoefele, Claus on 19.06.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCHTransportClient.h"

@interface CCHTransportDEVBBClient : NSObject<CCHTransportClient>

- (instancetype)initWithAccessID:(NSString *)accessID NS_DESIGNATED_INITIALIZER;

- (NSURLSessionTask *)retrieveDeparturesForDate:(NSDate *)date stationID:(NSString *)stationID maxNumberOfResults:(NSUInteger)maxNumberOfResults completionHandler:(void (^)(NSArray *departures, NSError *error))completionHandler;
- (NSURLSessionTask *)retrieveTripsForDate:(NSDate *)date fromLocation:(CCHTransportLocation *)fromLocation toLocation:(CCHTransportLocation *)toLocation maxNumberOfResults:(NSUInteger)maxNumberOfResults completionHandler:(void (^)(NSArray *trips, id context, NSError *error))completionHandler;

@end

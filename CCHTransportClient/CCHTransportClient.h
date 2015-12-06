//
//  CCHTransportClient.h
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

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

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
- (NSURLSessionTask *)retrieveDeparturesForDate:(nullable NSDate *)date stationID:(NSString *)stationID maxNumberOfResults:(NSUInteger)maxNumberOfResults completionHandler:(void (^)(NSArray * __nullable departures, NSError * __nullable error))completionHandler;
- (NSURLSessionTask *)retrieveStationsNearCoordinate:(CLLocationCoordinate2D)coordinate maxDistance:(CLLocationDistance)maxDistance maxNumberOfResults:(NSUInteger)maxNumberOfResults completionHandler:(void (^)(NSArray * __nullable stations, NSError * __nullable error))completionHandler;
- (NSURLSessionTask *)retrieveStationsForSearchString:(NSString *)searchString maxNumberOfResults:(NSUInteger)maxNumberOfResults completionHandler:(void (^)(NSArray * __nullable stations, NSError * __nullable error))completionHandler;
- (NSURLSessionTask *)retrieveTripsForDate:(nullable NSDate *)date fromLocation:(CCHTransportLocation *)fromLocation toLocation:(CCHTransportLocation *)toLocation transportModeMask:(CCHTransportClientMode)transportModeMask maxNumberOfResults:(NSUInteger)maxNumberOfResults completionHandler:(void (^)(NSArray * __nullable trips,  __nullable id context, NSError * __nullable error))completionHandler;
- (NSURLSessionTask *)retrieveMoreTripsWithContext:(id)context forward:(BOOL)forward maxNumberOfResults:(NSUInteger)maxNumberOfResults completionHandler:(void (^)(NSArray * __nullable trips, __nullable id context, NSError * __nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
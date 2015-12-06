//
//  CCHTransportDEBahnClient.m
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

#import "CCHTransportDEBahnClient.h"

#import "CCHTransportClientController.h"

#import "CCHTransportDEBahnBhftafelGenerator.h"
#import "CCHTransportDEBahnBhftafelParser.h"
#import "CCHTransportDEBahnQueryYGenerator.h"
#import "CCHTransportDEBahnQueryYParser.h"
#import "CCHTransportDEBahnAjaxGetstopGenerator.h"
#import "CCHTransportDEBahnAjaxGetstopParser.h"
#import "CCHTransportDEBahnQueryGenerator.h"
#import "CCHTransportDEBahnQueryNextGenerator.h"
#import "CCHTransportDEBahnQueryParser.h"

// Formats see https://github.com/schildbach/public-transport-enabler

NSString * const CCHTransportDEBahnClientErrorDomain = @"CCHTransportDEBahnClientErrorDomain";

static NSString * const USER_AGENT = @"Mozilla/5.0 (Linux; Android 4.3; Galaxy Nexus Build/JWR66Y) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.117 Mobile Safari/537.36";

@interface CCHTransportDEBahnClient()

@property (nonatomic) CCHTransportClientController *clientController;

@end

@implementation CCHTransportDEBahnClient

- (instancetype)init
{
    self = [super init];
    if (self) {
        _clientController = [[CCHTransportClientController alloc] init];
        _clientController.session.configuration.HTTPAdditionalHeaders = @{@"User-Agent": USER_AGENT};
    }
    
    return self;
}

- (NSObject<CCHTransportClientDelegate> *)delegate
{
    return self.clientController.delegate;
}

- (void)setDelegate:(NSObject<CCHTransportClientDelegate> *)delegate
{
    self.clientController.delegate = delegate;
}

- (NSURLSessionTask *)retrieveDeparturesForDate:(NSDate *)date stationID:(NSString *)stationID maxNumberOfResults:(NSUInteger)maxNumberOfResults completionHandler:(void (^)(NSArray *departures, NSError *error))completionHandler
{
    NSParameterAssert(stationID);
    
    NSURLSessionTask *task;
    
    if (completionHandler) {
        date = date ?: [NSDate date];
        
        CCHTransportDEBahnBhftafelGenerator *generator = [[CCHTransportDEBahnBhftafelGenerator alloc] initWithDate:date stationID:stationID maxNumberOfResults:maxNumberOfResults];
        CCHTransportDEBahnBhftafelParser *parser = [[CCHTransportDEBahnBhftafelParser alloc] init];
        task = [self.clientController executeDataTaskWithGenerator:generator parser:parser client:self completionHandler:completionHandler];
    }
    
    return task;
}

- (NSURLSessionTask *)retrieveStationsNearCoordinate:(CLLocationCoordinate2D)coordinate maxDistance:(CLLocationDistance)maxDistance maxNumberOfResults:(NSUInteger)maxNumberOfResults completionHandler:(void (^)(NSArray *stations, NSError *error))completionHandler
{
    NSURLSessionTask *task;

    if (completionHandler) {
        CCHTransportDEBahnQueryYGenerator *generator = [[CCHTransportDEBahnQueryYGenerator alloc] initWithCoordinate:coordinate maxDistance:maxDistance maxNumberOfResults:maxNumberOfResults];
        CCHTransportDEBahnQueryYParser *parser = [[CCHTransportDEBahnQueryYParser alloc] init];
        task = [self.clientController executeDataTaskWithGenerator:generator parser:parser client:self completionHandler:completionHandler];
    }
    
    return task;
}

- (NSURLSessionTask *)retrieveStationsForSearchString:(NSString *)searchString maxNumberOfResults:(NSUInteger)maxNumberOfResults completionHandler:(void (^)(NSArray *stations, NSError *error))completionHandler
{
    NSURLSessionTask *task;

    if (completionHandler) {
        CCHTransportDEBahnAjaxGetstopGenerator *generator = [[CCHTransportDEBahnAjaxGetstopGenerator alloc] initWithSearchString:searchString maxNumberOfResults:maxNumberOfResults];
        CCHTransportDEBahnAjaxGetstopParser *parser = [[CCHTransportDEBahnAjaxGetstopParser alloc] init];
        task = [self.clientController executeDataTaskWithGenerator:generator parser:parser client:self completionHandler:completionHandler];
    }

    return task;
}

- (NSURLSessionTask *)retrieveTripsForDate:(NSDate *)date fromLocation:(CCHTransportLocation *)fromLocation toLocation:(CCHTransportLocation *)toLocation transportModeMask:(CCHTransportClientMode)transportModeMask maxNumberOfResults:(NSUInteger)maxNumberOfResults completionHandler:(void (^)(NSArray *trips, id context, NSError *error))completionHandler
{
    NSParameterAssert(fromLocation);
    NSParameterAssert(toLocation);

    NSURLSessionTask *task;

    if (completionHandler) {
        date = date ?: [NSDate date];
        
        CCHTransportDEBahnQueryGenerator *generator = [[CCHTransportDEBahnQueryGenerator alloc] initWithDate:date fromLocation:fromLocation toLocation:toLocation transportModeMask:transportModeMask];
        CCHTransportDEBahnQueryParser *parser = [[CCHTransportDEBahnQueryParser alloc] init];
        task = [self.clientController executeDataTaskWithGenerator:generator parser:parser client:self completionHandler:^(NSDictionary *result, NSError *error) {
            NSArray *trips = result[CCHTransportDEBahnQueryParserResultTripsKey];
            NSString *context = result[CCHTransportDEBahnQueryParserResultContextKey];
            if (error == nil) {
                error = result[CCHTransportDEBahnQueryParserResultErrorKey];
            }
            completionHandler(trips, context, error);
        }];
    }    

    return task;
}

- (NSURLSessionTask *)retrieveMoreTripsWithContext:(id)context forward:(BOOL)forward maxNumberOfResults:(NSUInteger)maxNumberOfResults completionHandler:(void (^)(NSArray *trips, id context, NSError *error))completionHandler
{
    NSParameterAssert(context);
    
    NSURLSessionTask *task;

    if (completionHandler) {
        CCHTransportDEBahnQueryNextGenerator *generator = [[CCHTransportDEBahnQueryNextGenerator alloc] initWithContext:context laterTrips:forward];
        CCHTransportDEBahnQueryParser *parser = [[CCHTransportDEBahnQueryParser alloc] init];
        task = [self.clientController executeDataTaskWithGenerator:generator parser:parser client:self completionHandler:^(NSDictionary *result, NSError *error) {
            NSArray *trips = result[CCHTransportDEBahnQueryParserResultTripsKey];
            NSString *context = result[CCHTransportDEBahnQueryParserResultContextKey];
            if (error == nil) {
                error = result[CCHTransportDEBahnQueryParserResultErrorKey];
            }
            completionHandler(trips, context, error);
        }];
    }

    return task;
}

@end

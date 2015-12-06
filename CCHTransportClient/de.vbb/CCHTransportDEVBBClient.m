//
//  CCHTransportDEVBBClient.m
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

#import "CCHTransportDEVBBClient.h"

#import "CCHTransportClientController.h"

#import "CCHTransportDEVBBSTBResParser.h"
#import "CCHTransportDEVBBSTBReqGenerator.h"
#import "CCHTransportDEVBBConReqGenerator.h"
#import "CCHTransportDEVBBConResParser.h"

// http://www.vbb.de/de/article/webservices/schnittstellen-fuer-webentwickler/5070.html#dokumentation
// https://github.com/mphasize/vbb-hafas-docs
// http://www.administrator.de/wissen/HAFAS-Fahrplanauskunft-API-Sammlung-177145.html
// http://demo.hafas.de/xml/vbb/se/hafasXMLInterface.xsd

@interface CCHTransportDEVBBClient() <NSURLSessionTaskDelegate>

@property (nonatomic) CCHTransportClientController *clientController;
@property (nonatomic, copy) NSString *accessID;

@end

@implementation CCHTransportDEVBBClient

- (instancetype)initWithAccessID:(NSString *)accessID
{
    NSParameterAssert(accessID);
    
    self = [super init];
    if (self) {
        _clientController = [[CCHTransportClientController alloc] init];
        _accessID = accessID;
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
        date = date ?:[NSDate date];
        
        CCHTransportDEVBBSTBReqGenerator *generator = [[CCHTransportDEVBBSTBReqGenerator alloc] initWithAccessID:self.accessID date:date stationID:stationID maxNumberOfResults:maxNumberOfResults];
        CCHTransportDEVBBSTBResParser *parser = [[CCHTransportDEVBBSTBResParser alloc] init];
        task = [self.clientController executeDataTaskWithGenerator:generator parser:parser client:self completionHandler:completionHandler];
    }
    
    return task;
}

- (NSURLSessionTask *)retrieveTripsForDate:(NSDate *)date fromLocation:(CCHTransportLocation *)fromLocation toLocation:(CCHTransportLocation *)toLocation maxNumberOfResults:(NSUInteger)maxNumberOfResults completionHandler:(void (^)(NSArray *trips, id context, NSError *error))completionHandler
{
    NSParameterAssert(fromLocation);
    NSParameterAssert(toLocation);
    
    NSURLSessionTask *task;
    
    if (completionHandler) {
        date = date ?:[NSDate date];
        
        CCHTransportDEVBBConReqGenerator *generator = [[CCHTransportDEVBBConReqGenerator alloc] initWithAccessID:self.accessID date:date fromLocation:fromLocation toLocation:toLocation maxNumberOfResults:maxNumberOfResults];
        CCHTransportDEVBBConResParser *parser = [[CCHTransportDEVBBConResParser alloc] init];
        task = [self.clientController executeDataTaskWithGenerator:generator parser:parser client:self completionHandler:^(id result, NSError *error) {
            completionHandler(result, nil, error);
        }];
    }
    
    return task;
}

@end

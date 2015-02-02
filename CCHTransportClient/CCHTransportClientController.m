//
//  CCHTransportClientController.m
//  Departures
//
//  Created by Hoefele, Claus on 07.08.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportClientController.h"

#import "CCHTransportGenerator.h"
#import "CCHTransportParser.h"
#import "CCHTransportClientDelegate.h"

@interface CCHTransportClientController()

@property (nonatomic) NSURLSession *session;

@end

@implementation CCHTransportClientController

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    }
    
    return self;
}

- (void)dealloc
{
    [self.session invalidateAndCancel];
}

- (NSURLSessionDataTask *)executeDataTaskWithGenerator:(id<CCHTransportGenerator>)generator parser:(id<CCHTransportParser>)parser client:(NSObject<CCHTransportClient> *)client completionHandler:(void (^)(id result, NSError *error))completionHandler
{
    NSParameterAssert(completionHandler);
    
    if ([self.delegate respondsToSelector:@selector(transportClientWillStartRequest:)]) {
        [self.delegate transportClientWillStartRequest:client];
    }
    
    NSURLRequest *request = [generator generateRequest];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        id result = error ? nil : [parser parseResponseWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(transportClientDidFinishRequest:)]) {
                [self.delegate transportClientDidFinishRequest:client];
            }

            completionHandler(result, error);
        });
    }];
    [task resume];

    return task;
}

@end

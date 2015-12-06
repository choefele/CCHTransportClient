//
//  CCHTransportClientController.m
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

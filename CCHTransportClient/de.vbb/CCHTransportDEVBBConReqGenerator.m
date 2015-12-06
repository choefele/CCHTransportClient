//
//  CCHTransportDEVBBConReqGenerator.m
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

#import "CCHTransportDEVBBConReqGenerator.h"

#import "CCHTransportLocation.h"
#import "CCHTransportStation.h"
#import "CCHTransportDEVBBClientUtils.h"

@interface CCHTransportDEVBBConReqGenerator()

@property (nonatomic, copy) NSString *accessID;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic) CCHTransportLocation *fromLocation;
@property (nonatomic) CCHTransportLocation *toLocation;
@property (nonatomic) NSUInteger maxNumberOfResults;

@end

@implementation CCHTransportDEVBBConReqGenerator

- (instancetype)initWithAccessID:(NSString *)accessID date:(NSDate *)date fromLocation:(CCHTransportLocation *)fromLocation toLocation:(CCHTransportLocation *)toLocation maxNumberOfResults:(NSUInteger)maxNumberOfResults
{
    self = [super init];
    if (self) {
        _accessID = accessID;
        _date = date;
        _fromLocation = fromLocation;
        _toLocation = toLocation;
        _maxNumberOfResults = maxNumberOfResults;
    }
    
    return self;
}

- (NSURLRequest *)generateRequest
{
    NSString *payloadFormat = @"<ConReq><Start><Station externalId='%@' /><Prod prod='1111111111111111' direct='0' /></Start><Dest><Station externalId='%@' /></Dest><ReqT a='0' date='%@' time='%@' /><RFlags b='0' f='%tu' sMode='N' /></ConReq>";

    NSString *timeString = [CCHTransportDEVBBClientUtils timeStringFromDate:self.date];
    NSString *dateString = [CCHTransportDEVBBClientUtils dateStringFromDate:self.date];
    NSUInteger maxNumberOfResults = MIN(6, self.maxNumberOfResults);
    
    NSString *payLoad;
    if ([self.fromLocation isKindOfClass:CCHTransportStation.class]) {
        CCHTransportStation *fromStation = (CCHTransportStation *)self.fromLocation;
        CCHTransportStation *toStation = (CCHTransportStation *)self.toLocation;
        payLoad = [NSString stringWithFormat:payloadFormat, fromStation.stationID, toStation.stationID, dateString, timeString, maxNumberOfResults];
    }
    
    return [CCHTransportDEVBBClientUtils URLRequestWithData:payLoad accessID:self.accessID];
}

@end

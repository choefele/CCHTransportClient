//
//  CCHTransportDEVBBReqCGenerator.m
//  Departures
//
//  Created by Claus Höfele on 08.08.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
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

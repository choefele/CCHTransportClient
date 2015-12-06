//
//  CCHTransportService.h
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

typedef NS_ENUM(NSInteger, CCHTransportServiceMode) {
    CCHTransportServiceModeUnknown,
    CCHTransportServiceModeSuburbanTrain,
    CCHTransportServiceModeSubway,
    CCHTransportServiceModeBus,
    CCHTransportServiceModeStreetCar,
    CCHTransportServiceModeRegionalTrain,
    CCHTransportServiceModeLongDistanceTrain,
    CCHTransportServiceModeFerry,
    CCHTransportServiceModePedestrian,
    CCHTransportServiceModeOnDemandService
};

typedef NS_ENUM(NSInteger, CCHTransportServiceDirection) {
    CCHTransportServiceDirectionUnknown,
    CCHTransportServiceDirectionForward,
    CCHTransportServiceDirectionBackward
};

@interface CCHTransportService : NSObject<NSSecureCoding, NSCopying>

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, readonly) CCHTransportServiceMode transportMode;
@property (nonatomic, copy, readonly) NSString *directionName;
@property (nonatomic, readonly) CCHTransportServiceDirection direction;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithName:(NSString *)name transportMode:(CCHTransportServiceMode)transportMode directionName:(NSString *)directionName direction:(CCHTransportServiceDirection)direction NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

@end

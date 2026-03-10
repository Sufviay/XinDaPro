//
//  DeviceID.h
//  hongbao
//
//  Created by 肖扬 on 2021/8/23.
//  Copyright © 2021 apple. All rights reserved.
//

#import <Foundation/Foundation.h>


 
@interface MYKeyChainTool : NSObject
 
 
+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)deleteKeyData:(NSString *)service;
 

@end




#import <UIKit/UIKit.h>

@interface MYVendorToll : NSObject

+ (NSString *)getIDFV;

@end

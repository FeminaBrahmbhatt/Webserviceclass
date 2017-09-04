//
//  WebServicesClass.m
//
//  Created by Femina Rajesh Brahmbhatt .
//  Copyright © 2016 Femina Rajesh Brahmbhatt. All rights reserved.
//

#define urlBase @"your url"    // Local API Baseurl

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface WebServicesClass : NSObject<NSURLSessionTaskDelegate>

@property (nonatomic, strong) MBProgressHUD *HUD;

+ (WebServicesClass *) sharedWebServiceClass;

// API calling POST method
-(void)JsonCall:(NSDictionary *)dicData inview:(UIView*)view WitCompilation:(void (^)(NSMutableDictionary *Dictionary,NSError *error))completion;

// API calling GET method
-(void)JsonCallGET:(NSString *)urlString inview:(UIView*)view WitCompilation:(void (^)(NSMutableDictionary *Dictionary))completion;

// API calling Image uplaoding "FormData" request POST
-(void)JsonCallWithImage:(NSData *)imageData inview:(UIView*)view withfieldName:(NSString *)strfieldName andParameters:(NSDictionary *)param WitCompilation :(void (^)(NSMutableDictionary *, NSError *))completion;

// Indicator
-(void)HideProgressHUD;
-(void)ShowProgressHUD:(UIView*)view;
@end

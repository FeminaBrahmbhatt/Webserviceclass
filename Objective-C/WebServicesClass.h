//
//  WebServicesClass.m
//
//  Created by Femina Rajesh Brahmbhatt .
//  Copyright © 2016 Femina Rajesh Brahmbhatt. All rights reserved.
//

#define urlBase @"http://192.168.0.128/i_gotcha/"    // Local API Baseurl

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface WebServicesClass : NSObject<NSURLSessionTaskDelegate>

@property (nonatomic, strong) MBProgressHUD *HUD;

+ (WebServicesClass *) sharedWebServiceClass;

// API calling POST method
-(void)JsonCall:(NSDictionary *)dicData ClassURL:(NSString *)urlClass WitCompilation:(void (^)(NSMutableDictionary *Dictionary,NSError *error))completion;

// API calling GET method
-(void)JsonCallGET:(NSString *)urlString WitCompilation:(void (^)(NSMutableDictionary *Dictionary))completion;

// API calling Image uplaoding "FormData" request POST
-(void)JsonCallWithImage:(NSData *)imageData withfieldName:(NSString *)strfieldName ClassURL:(NSString *)urlClass WitCompilation:(void (^)(NSMutableDictionary *Dictionary,NSError *error))completion;

// Indicator
-(void)HideProgressHUD;
-(void)ShowProgressHUD;
@end

//
//  WebServicesClass.m
//
//  Created by Femina Rajesh Brahmbhatt .
//  Copyright © 2016 Femina Rajesh Brahmbhatt. All rights reserved.
//

#import "WebServicesClass.h"
#import "AppDelegate.h"
#import "Reachability.h"
@implementation WebServicesClass

static WebServicesClass* _sharedWebServiceCom = nil;

+ (WebServicesClass *) sharedWebServiceClass
{
    @synchronized([WebServicesClass class])
    {
        if (!_sharedWebServiceCom)
            _sharedWebServiceCom = [[self alloc] init];
        
        return _sharedWebServiceCom;
    }
    return nil;
}

- (id)init {
    self = [super init];
    if (self != nil) {
        
        // initialize stuff here
        _HUD = [[MBProgressHUD alloc]initWithWindow:[SHARED_APPDELEGATE window]];
        
        [[SHARED_APPDELEGATE window] addSubview:_HUD];
        _HUD.label.text = @"Please wait";
    }
    return self;
}

#pragma mark - POST method

-(void)JsonCallWithImage:(NSData *)imageData withfieldName:(NSString *)strfieldName andParameters:(NSDictionary *)param WitCompilation :(void (^)(NSMutableDictionary *, NSError *))completion
{
    if (connected) {
        //NSError *error;
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
        
        // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
        NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
        
        
        // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
        NSString* FileParamConstant = strfieldName;
        
        // the server url to which the image (or the media) is uploaded. Use your server url here
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urlBase]];
        
        // create request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [request setHTTPShouldHandleCookies:NO];
        [request setHTTPMethod:@"POST"];
        
        // set Content-Type in HTTP header
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        // post body
        NSMutableData *body = [NSMutableData data];
        
        //add param (all params are strings)
        [param enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
        }];
        
        // add image data
        if (imageData) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.png\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // setting the body of the post to the reqeust
        [request setHTTPBody:body];
        
        // set the content-length
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        
        // set URL
        [request setURL:url];
        
        //_HUD.label.text =@"Uploading Image";
        
        [self ShowProgressHUD];
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                              {
                                                  
                                                  if (!error)
                                                  {
                                                      [self HideProgressHUD];
                                                      
                                                      NSMutableDictionary *dicjson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                                      NSLog(@"%@",dicjson);
                                                      
                                                      if (completion)
                                                          completion(dicjson,error);
                                                  }
                                                  else
                                                  {
                                                      if (completion)
                                                          completion(nil,error);
                                                      
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [self HideProgressHUD];
                                                          [self showalertwithmessage:error.description];
                                                      });
                                                  }
                                                  
                                              }];
        [postDataTask resume];
    }
    else{
        [self showalertwithmessage:@"Please check connection and try again"];
        
    }
}
-(void)JsonCall:(NSDictionary *)dicData WitCompilation:(void (^)(NSMutableDictionary *Dictionary,NSError *error))completion
{
    if (connected) {
        NSError *error;
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urlBase]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        //    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:myDictionary];
        //    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
        //
        //    NSString *authValue = [NSString stringWithFormat: @"Basic %@",[authData base64EncodedStringWithOptions:0]];
        
        //    if ([userDefaults objectForKey:userdefaultAuthHeader]) {
        //        [request setValue:[userDefaults objectForKey:userdefaultAuthHeader] forHTTPHeaderField:@"Authorization"];
        //    }
        
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPMethod:@"POST"];
        NSDictionary *mapData = [[NSDictionary alloc] initWithDictionary:dicData];
        NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
        [request setHTTPBody:postData];
        
        [self ShowProgressHUD];      // Show MBProgressHUD
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                              {
                                                  if (!error)
                                                  {
                                                      [self HideProgressHUD];  // Hide MBProgressHUD
                                                      
                                                      NSMutableDictionary *dicjson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                                      NSLog(@"%@",dicjson);
                                                      
                                                      if (completion)
                                                          completion(dicjson,error);
                                                  }
                                                  else
                                                  {
                                                      if (completion)
                                                          completion(nil,error);
                                                      
                                                      //[self HideProgressHUD];
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [self HideProgressHUD];
                                                          [self showalertwithmessage:error.description];
                                                      });
                                                      
                                                      
                                                  }
                                              }];
        [postDataTask resume];
    }
    else{
        [self showalertwithmessage:@"Please check connection and try again"];
        
    }
}

#pragma mark - GET method

-(void)JsonCallGET:(NSString *)urlString WitCompilation:(void (^)(NSMutableDictionary *Dictionary))completion
{
    if (connected) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
        
        NSURL *url = [NSURL URLWithString:urlBase];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        [request setHTTPMethod:@"GET"];
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                              {
                                                  if (!error)
                                                  {
                                                      NSMutableDictionary *dicjson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                                      NSLog(@"%@",dicjson);
                                                      
                                                      if (completion)
                                                          completion(dicjson);
                                                  }
                                                  else
                                                  {
                                                      NSMutableDictionary *dicjson = [[NSMutableDictionary alloc]init];
                                                      if (completion)
                                                          completion(dicjson);
                                                  }
                                              }];
        [postDataTask resume];
    }
    else{
        [self showalertwithmessage:@"Please check connection and try again"];
        
    }
}

#pragma mark - MBprogressHUD

-(void)HideProgressHUD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_HUD hideAnimated:YES];
    });
}
-(void)ShowProgressHUD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_HUD showAnimated:YES];
    });
}

-(void)showalertwithmessage:(NSString*)message{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Error"
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   //Handel your yes please button action here
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   
                               }];
    
    [alert addAction:okButton];

    
    UIWindow *keyWindow = [[UIApplication sharedApplication]keyWindow];
    UIViewController *mainController = [keyWindow rootViewController];
    [mainController presentViewController:alert animated:YES completion:nil];
}

- (BOOL)connected
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    
    if ([reach isReachable]) {
        NSLog(@"Device is connected to the internet");
        return TRUE;
    }
    else {
        NSLog(@"Device is not connected to the internet");
        return FALSE;
    }
}
@end

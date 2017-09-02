
How to implement api in:

#swfit

 webserviceclassswift.sharedinstance.JsonCallPOST(view: view, dicData: ["username":"test","password":"123"], completionHandler: { (dictionary,errorstr) -> Void in

            print(dictionary ?? "no value")

        })
        
        
#Objective-C

[[WebServicesClass sharedWebServiceClass] JsonCall:userdict WitCompilation:^(NSMutableDictionary *Dictionary, NSError *error) {
            
            NSLog(@"%@",Dictionary);
            
        }];

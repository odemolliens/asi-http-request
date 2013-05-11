//
//  HTTPImageView.h
//  ostalgo
//
//  Created by Olivier Demolliens on 03/04/12.
//  Copyright (c) 2012 Olivier Demolliens. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "ASIHTTPRequest.h"

@protocol HTTPImageViewDelegate  <NSObject>

@optional
-(void)endLoading;
-(void)endLoading:(ASIHTTPRequest*) request;
-(void)requestFailed:(ASIHTTPRequest *)req;

@end

@interface HTTPImageView : UIImageView {
   ASIHTTPRequest *request;
   id <HTTPImageViewDelegate> delegate;
}

@property(readonly)ASIHTTPRequest *request;

- (void)setImageWithURL:(NSURL *)url andDelegate:(id <HTTPImageViewDelegate>) del;

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder andDelegate:(id <HTTPImageViewDelegate>) del;

@end
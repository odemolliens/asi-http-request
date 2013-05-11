//
//  HTTPImageView.m
//  ostalgo
//
//  Created by Olivier Demolliens on 03/04/12.
//  Copyright (c) 2012 Olivier Demolliens. All rights reserved.
//

#import "HTTPImageView.h"
#import "ASIDownloadCache.h"


@implementation HTTPImageView

@synthesize request;

- (void)setImageWithURL:(NSURL *)url andDelegate:(id <HTTPImageViewDelegate>) del
{
   
   if (del) {
      delegate = del;
   }
   
   [request setDelegate:nil];
   [request cancel];
   [request release];
   
   request = [[ASIHTTPRequest requestWithURL:url] retain];
   [request setDownloadCache:[ASIDownloadCache sharedCache]];
   [request setCacheStoragePolicy:ASIAskServerIfModifiedCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
   
   [request setDelegate:self];
   [request startAsynchronous];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder andDelegate:(id <HTTPImageViewDelegate>) del
{
   if (del) {
      delegate = del;
   }
   
   if (placeholder){
      [self setImage:placeholder];
   }
   
   if (![[url absoluteString]isEqualToString:@""]) {
      [request setDelegate:nil];
      [request cancel];
      [request release];
      
      request = [[ASIHTTPRequest requestWithURL:url] retain];
      [request setDownloadCache:[ASIDownloadCache sharedCache]];
      [request setCacheStoragePolicy:ASIAskServerIfModifiedCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
      [request setDelegate:self];
      
      [request startAsynchronous];
      
   }
   
}

- (void)dealloc
{
   [request setDelegate:nil];
   [request cancel];
   [request release];
   
   delegate = nil;
   
   [super dealloc];
}

- (void)requestFailed:(ASIHTTPRequest *)req
{
   if (delegate) {
      if ([delegate respondsToSelector:@selector(requestFailed:)]) {
         [delegate requestFailed:req];
      }
   }

}

- (void)requestFinished:(ASIHTTPRequest *)req
{
   
   if (request.responseStatusCode != 200)
      return;
   
   self.image = [UIImage imageWithData:request.responseData];
   
   if (delegate) {
      if ([delegate respondsToSelector:@selector(endLoading)]) {
         [delegate endLoading];
      }
      if ([delegate respondsToSelector:@selector(endLoading:)]) {
         [delegate endLoading:req];
      }
   }
}

@end

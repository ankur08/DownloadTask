//
//  ViewController.m
//  DownloadTask
//
//  Created by ankur on 22/08/16.
//  Copyright © 2016 ankur. All rights reserved.
//

#import "ViewController.h"
//<NSURLSessionDownloadDelegate>
@interface ViewController (){
    NSURLSession *session;
    NSURLSessionDownloadTask *downloadTask;
    
    }
- (IBAction)playAction:(id)sender;
- (IBAction)pauseAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    [self.progressView setProgress:0 animated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    NSLog(@"%@",location);
    
    NSString *videoPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *url = [NSURL URLWithString:[videoPath stringByAppendingPathComponent: @"video.mp4"]];
    
    if ([fileManager fileExistsAtPath:[location path]])
    {
        [fileManager replaceItemAtURL:url withItemAtURL:location backupItemName:nil options:NSFileManagerItemReplacementUsingNewMetadataOnly resultingItemURL:nil error:nil];
        UISaveVideoAtPathToSavedPhotosAlbum([url path], nil, nil, nil);
    }
    
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
    [self.progressView setProgress:totalBytesWritten/totalBytesExpectedToWrite animated:YES];
    
    
}

- (IBAction)playAction:(id)sender {
    if (downloadTask == nil) {
        NSURL *url = [NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
        downloadTask = [session downloadTaskWithURL:url];
        [downloadTask resume];
    }else [downloadTask resume];
    
}

- (IBAction)pauseAction:(id)sender {
    [downloadTask suspend];
}

- (IBAction)cancelAction:(id)sender {
    [downloadTask cancel];
}
@end

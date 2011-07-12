//
//  WibbleQuest.m
//  MyBoots
//
//  Created by orta therox on 09/07/2011.
//  Copyright 2011 http://ortatherox.com. All rights reserved.
//

static WibbleQuest *sharedWibble;

#import "CommandInterpreter.h"

//private methods
@interface WibbleQuest()
-(void) checkForNibConnections;
-(void) loadPageForShowingGame;
-(void) describeSurroundings;
@end

@implementation WibbleQuest

@synthesize view, rooms, currentRoom, game, inventory;

+ (WibbleQuest *)sharedWibble {
  return sharedWibble;
}

-(void)awakeFromNib {
  // setup wibble for allowing any game actions
  // before allowing the game to start adding
  // rooms and other data
  
  sharedWibble = self;
  
  [self checkForNibConnections];
  _commandInterpreter = [[CommandInterpreter alloc] init];
  _commandInterpreter.wq = self;
  
  // we do this last, as it has a delegate method when it's ready
  [self loadPageForShowingGame];
  _textField.clearsOnBeginEditing = YES;
  self.inventory = [[[PlayerInventory alloc] init] retain];
}

- (void)webViewDidFinishLoad:(UIWebView *) delagateWebView {
  [game ready];
}

-(void) start {
  [self heading:[game gameName]];
  [self print:[game gameDescription]];
  // just a neat gap
  [self heading:@""];
  
  [self describeSurroundings];
  
}

// think about moving this into Room
-(void) describeSurroundings {
  [self title:currentRoom.name];
  [self print:currentRoom.description];
  [self.currentRoom describeInventory];
  
  if(currentRoom.encounter){
    //TODO
  }
}

-(void)addRoom:(Room*)room {
  // custom adding room, this allows some error handling
  if(!room.north && !room.south && !room.west && !room.east){
    NSLog(@"The Room %@ has no connections", room.name);
  }
  [room retain];
  if (self.rooms == nil) {
    self.rooms = [NSMutableArray arrayWithObject:room];
  }else{
    [self.rooms addObject:room];  
  }
}

- (BOOL)textFieldShouldReturn:(UITextField *)inTextField {
	[inTextField resignFirstResponder];
  [self command:[@"> " stringByAppendingString: inTextField.text]];
  [_commandInterpreter parse:inTextField.text];
  
  inTextField.text = @"";
  return YES;
}

#pragma error handling and loading

-(void) loadPageForShowingGame {
  NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
  NSURL *url = [NSURL fileURLWithPath:path];
  NSURLRequest * request = [NSURLRequest requestWithURL:url];
  [_webView loadRequest:request];
}

-(void) checkForNibConnections {
  if(_webView == nil){
    [NSException raise:@"Web View is not hooked up to WibbleQuest Object in Nib" format:@"Web View is not hooked up to WibbleQuest Object in Nib"];
  }
  
  if(_webView.delegate != self){
    [NSException raise:@"Web View delegate is not hooked up to WibbleQuest Object" format:@"Web View delegate is not hooked up to WibbleQuest Object"];
  }

  if(_textField == nil){
    [NSException raise:@"Text Field not hooked up to WibbleQuest Object" format:@"Text Field not hooked up to WibbleQuest Object"];
  }
  if(_textField.delegate != self){
    [NSException raise:@"Text Field delegate not hooked up to WibbleQuest Object" format:@"Text Field delegate not hooked up to WibbleQuest Object"];
  }
  if(view == nil){
    [NSException raise:@"Web View not hooked up to WibbleQuest Object in Nib" format:@"Web View not hooked up to WibbleQuest Object in Nib"];
  }
}

-(void)dealloc{
  [super release];
  [inventory release];
  [currentRoom release];
}

@end
//
//  MUSConstantsForSocialNetworks.h
//  UniversalSharing
//
//  Created by U 2 on 15.10.15.
//  Copyright © 2015 Mobindustry. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark Facebook Constants

FOUNDATION_EXPORT NSString *const MUSFacebookTitle;
FOUNDATION_EXPORT NSString *const MUSFacebookIconName;
FOUNDATION_EXPORT NSString *const MUSFacebookName;

FOUNDATION_EXPORT NSString *const MUSFacebookPermission_Email;
FOUNDATION_EXPORT NSString *const MUSFacebookPermission_Publish_Actions;

FOUNDATION_EXPORT NSString *const MUSFacebookGraphPath_Me;
FOUNDATION_EXPORT NSString *const MUSFacebookGraphPath_Me_Feed;
FOUNDATION_EXPORT NSString *const MUSFacebookGraphPath_Me_Photos;
FOUNDATION_EXPORT NSString *const MUSFacebookGraphPath_Search;

FOUNDATION_EXPORT NSString *const MUSFacebookParametrsRequest;
FOUNDATION_EXPORT NSString *const MUSFacebookParameter_Fields;
FOUNDATION_EXPORT NSString *const MUSFacebookParameter_Message;
FOUNDATION_EXPORT NSString *const MUSFacebookParameter_Place;
FOUNDATION_EXPORT NSString *const MUSFacebookParameter_Picture;

FOUNDATION_EXPORT NSString *const MUSFacebookLocationParameter_Q;
FOUNDATION_EXPORT NSString *const MUSFacebookLocationParameter_Type;
FOUNDATION_EXPORT NSString *const MUSFacebookLocationParameter_Center;
FOUNDATION_EXPORT NSString *const MUSFacebookLocationParameter_Distance;

FOUNDATION_EXPORT NSString *const MUSFacebookKeyOfPlaceDictionary;

FOUNDATION_EXPORT NSString *const MUSFacebookError;
FOUNDATION_EXPORT NSInteger const MUSFacebookErrorCode;

FOUNDATION_EXPORT NSString *const MUSFacebookSuccessUpdateNetworkPost;

FOUNDATION_EXPORT NSString* const MUSFacebookParameter_ObjectId;
FOUNDATION_EXPORT NSString* const MUSFacebookParameter_True;
FOUNDATION_EXPORT NSString* const MUSFacebookParameter_Summary;
FOUNDATION_EXPORT NSString* const MUSFacebookParameter_Likes;
FOUNDATION_EXPORT NSString* const MUSFacebookParameter_Total_Count;
FOUNDATION_EXPORT NSString* const MUSFacebookParameter_Comments;

FOUNDATION_EXPORT NSString *const MUSFacebookLocation_Parameter_Type_Place;
FOUNDATION_EXPORT NSString *const MUSFacebookLocation_Parameter_Type_Distance;

#pragma mark Vkontakte Constants

FOUNDATION_EXPORT NSString *const MUSVKAppID;
FOUNDATION_EXPORT NSString *const MUSVKAllUserFields;
FOUNDATION_EXPORT NSString *const MUSVKTitle;
FOUNDATION_EXPORT NSString *const MUSVKIconName;
FOUNDATION_EXPORT NSString *const MUSVKName;

FOUNDATION_EXPORT NSString *const MUSVKMethodPlacesSearch;
FOUNDATION_EXPORT NSString *const MUSVKMethodWallGetById;

FOUNDATION_EXPORT NSString *const MUSVKParameter_Photo;
FOUNDATION_EXPORT NSString *const MUSVKParameter_Posts;

FOUNDATION_EXPORT NSString *const MUSVKLocationParameter_Q;
FOUNDATION_EXPORT NSString *const MUSVKLocationParameter_Latitude;
FOUNDATION_EXPORT NSString *const MUSVKLocationParameter_Longitude;
FOUNDATION_EXPORT NSString *const MUSVKLocationParameter_Radius;

FOUNDATION_EXPORT NSString *const MUSVKKeyOfPlaceDictionary;

FOUNDATION_EXPORT NSInteger const MUSVKDistanceEqual300;
FOUNDATION_EXPORT NSInteger const MUSVKDistanceEqual2400;
FOUNDATION_EXPORT NSInteger const MUSVKDistanceEqual18000;

FOUNDATION_EXPORT NSString *const MUSVKSuccessUpdateNetworkPost;

FOUNDATION_EXPORT NSString *const MUSVKError;
FOUNDATION_EXPORT NSInteger const MUSVKErrorCode;

#pragma mark Twitter Constants

FOUNDATION_EXPORT NSString *const MUSTwitterConsumerSecret;
FOUNDATION_EXPORT NSString *const MUSTwitterConsumerKey;

FOUNDATION_EXPORT NSString *const MUSTwitterTitle;
FOUNDATION_EXPORT NSString *const MUSTwitterIconName;
FOUNDATION_EXPORT NSString *const MUSTwitterName;

FOUNDATION_EXPORT NSString *const MUSTwitterError;
FOUNDATION_EXPORT NSInteger const MUSTwitterErrorCode;

FOUNDATION_EXPORT NSString *const MUSTwitterLocationParameter_Latitude;
FOUNDATION_EXPORT NSString *const MUSTwitterLocationParameter_Longituge;

FOUNDATION_EXPORT NSString *const MUSTwitterURL_Statuses_Show;
FOUNDATION_EXPORT NSString *const MUSTwitterURL_Api_Url;
FOUNDATION_EXPORT NSString *const MUSTwitterURL_Geo_Search;
FOUNDATION_EXPORT NSString *const MUSTwitterURL_Statuses_Update;
FOUNDATION_EXPORT NSString *const MUSTwitterURL_Media_Upload;

FOUNDATION_EXPORT NSString *const MUSTwitterParameter_Status;
//FOUNDATION_EXPORT NSString *const MUSTwitterParameter_PlaceID;
FOUNDATION_EXPORT NSString *const MUSTwitterParameter_MediaID;
FOUNDATION_EXPORT NSString *const MUSTwitterParameter_Media;

FOUNDATION_EXPORT NSString* const MUSTwitterParameter_ID;
FOUNDATION_EXPORT NSString* const MUSTwitterParameter_True;
FOUNDATION_EXPORT NSString* const MUSTwitterParameter_Include_My_Retweet;
FOUNDATION_EXPORT NSString* const MUSTwitterParameter_Favorite_Count;
FOUNDATION_EXPORT NSString* const MUSTwitterParameter_Retweet_Count;


FOUNDATION_EXPORT NSString *const MUSTwitterJSONParameterForMediaID;
FOUNDATION_EXPORT NSString *const MUSTwitterSuccessUpdateNetworkPost;

#pragma mark General Constants

FOUNDATION_EXPORT NSString *const MUSGET;
FOUNDATION_EXPORT NSString *const MUSPOST;
FOUNDATION_EXPORT NSString *const MUSPostSuccess;

#pragma mark Error Constants

FOUNDATION_EXPORT NSString *const MUSLocationDistanceError;
FOUNDATION_EXPORT NSInteger const MUSLocationDistanceErrorCode;

FOUNDATION_EXPORT NSString *const MUSLocationPropertiesError;
FOUNDATION_EXPORT NSInteger const MUSLocationPropertiesErrorCode;

FOUNDATION_EXPORT NSString *const MUSAccessError;
FOUNDATION_EXPORT NSInteger const MUSAccessErrorCode;



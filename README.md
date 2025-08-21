
# Iteeha Coffee

Iteeha is a premium coffee store like starbucks who want to onboard many customers via application.

The concept of this application is for the loyal users of Iteeha Coffee. Users can install the application to track their Loaylty status, get & avail rewards and add money to their virtual wallet to pay for the orders at the Iteeha store.

The Iteeha stores use the "PetPooja" POS software for creating orders at the store. So we have integrated multiple APIs that are needed to interact with the third-party Petpooja.

The loyalty feature of the app defines how and what rewards a user will get.
There are 3 loyalty levels for any user:-
    1. Bean Explorer
    2. Brew Entusiast
    3. Master Barista

App users(roles):\
    This app does not have any spcific role. Any one can singup on the application and use it for their daily coffee needs.
    

# Project Design

Below is the link for FIGMA design file of Iteeha.

Desgin Link - https://www.figma.com/file/Me1DpoFVzT9znCX7C8tK3i/%E2%98%95%EF%B8%8F-Coffee?type=design&mode=design&t=5rFSROigw87DgJg3-0


# System Architecture

Components:

    1. Database - MongoDB 
    2. Server - NodeJs in Typescript
    3. Application - Flutter Framework
    4. PetPooja POS Software

# Application Structure & Modules:
     1. All locally used images and svg icons used are kept in the assets folder.
        a. project/assets
        b. Images in project/assets/images
        c. Svg Icons in project/assets/svgIcons
        d. Placeholders in project/assets/placeholders
        e. App logo path: assets/images/rrIcon.png
        f. The fonts used in the application are stored in the project/assets/fonts folder.
        
The application is split into the following Modules:
All source code files are kept inside the "lib" folder on the main level in their respective module folder.

    1. Auth Module - Auth module handles all the authentication/credentials and stores all the user's data.
    2. Home Module - This module contains all the screens, widgets, provider and models of the home module i.e. Cafes, Notifications.
    3. Wallet Module - This module contains the files and folders for the wallet module which contains the savings data, transaction data current balance data and the unique wallet id and the payment gateway data.
    4. Rewards Module - This module shows all the possible rewards user can get and all defines the loyalty levels and what is needed to achieve any loyalty level.
    5. More Module - Contains edit profile, more screen, FaQs and Permissions.
    

There are more single files handling the configurations in the application.

    1. api.dart - Holds the Server IP/domains and all the "apis" used to make http requests to the server.
    2. colors.dart - Some repeatedly used colors used thoughout the application are stored in this files and used everywhere needed.
    3. common_functions.dart - Some repeatedly used functions used thoughout the application are stored in this files and used everywhere needed.
    4. local_notification_service.dart - The code used to handle the local sent notifications.
    5. theme_mamager.dart - Holds the theme data of the entire application.
    5. storage_manager.dart - used to store and retrieve the theme data of the app stored in local storage.
    6. http_helper.dart - This files has all the custom boiler plate code needed to make http requests. All http requests are to be made by importing this file and using these functions.
        a. httprequest() - used for Normal http request that do not contain any files.
        b. formDataRequest() - Used for sending file data request.

There are some third party files in the application: 

    1. Firebase "google-services.json" in the android/app/ folder downloaded from firebase.
    2. Firebase "GoogleService-Info.plist" in the ios/runner folder downloaded from firebase.


# Server structure & Modules
    
    1. Authentication module (src/utils/generic/auth/) - 
        a. The send, verify and resend otp APIs are written in auth.controller.ts in the auth folder.
        b. The middleware folder has the createAccessToken method to assign auth_tokens to users.
    2. App Module (src/appModule) - 
        All module folders in here are used for the integration with the app.
    3. Cafe Module - Contains all Cafe related API integration files.
    4. Like module - There is a like module that has all the required files for like integration. The like module handles likes for all the the content in the application.
    5. FaQ Module.
    6. Item Module - All the items that the Iteeha store offers as products at their stores can be stored in the Items table.
    7. Loyalty Module - Files for integration with the loyalty levels with the app are kept here.
    8. Offers Module - Contains all files required for API integration of offers.
    9. Petpooja Module - This module is for integration with the third party (i.e. Virtual Wallet and Order syncing for Loyalty level).
        
    
# PetPooja POS 
    Since Iteeha stores use PetPooja POS for handling their restaurant and orders management, we have integration with the Petpooja POS for the best functioning of the app.
    
    Loyalty APIs:-
        1. There are 4 APIs required to be integrated with Petpooja for loyalty management.
        2. These APIs work as webhooks for Petpooja POS.
            These endpoints are hit when the POS fires certain events namely:
            a. Sending Order - When an order is created from the POS. We will receive the order and customer details in this APIs body and we process it to assign certain loyalty rewards to the customer.
            b. Get Rewards - When the seller on the POS at the store enters the customers phone and clicks on loyalty button, this webhook is hit and we send a response containing all the available rewards of that particular customer.
            c. Redeem Reward / Send OTP - When user has opted to use a certain reward, this API will be hit:
                i. If we have set the otp-verification to true, this endpoint will be used to send otp to the customer as a verification to redeem the reward.
                ii. If we have set the otp-verification to false, this endpoint will simply send the response as success for the reward to be redeemed with the said reward.
            d. Redeem Reward / Verify OTP - If we have set the otp-verification to true, this endpoint will verify the sent otp via the send otp endpoint and on successful verification will send the reward data.
        
    Virtual Wallet APIs:-
        1. There are 2 main APIs to be integrated for wallet management.
        2. These APIs are straight endpoints that are served by the petpooja themselves.
        Following are the endpoints:- 
            a. Add wallet balance - When user adds money from wallet using the payment gateway provided in app, we call this API to add credits to the user's account in the Petpooja system.
            b. Get Wallet Balance - Whenever we want to get the user's latest wallet balance in the petpooja we hit this API to get the updated balance.
    You can find the integration for virtual wallet in the Apiary documentation, link below.
        https://virtualwallet.docs.apiary.io/#/reference/virtual-wallet-ap-is/get-wallet-balance/get-virtual-wallet-points-api/200?mc=reference%2Fvirtual-wallet-ap-is%2Fget-wallet-balance%2Fget-virtual-wallet-points-api%2F200
    


# Packages

Packages used in pubspec.yaml

    1. http
    2. pin_code_fields
    3. flutter_svg
    4. localstorage
    5. shared_preferences
    6. provider
    7. carousel_slider
    8. intl
    9. firebase_messaging
    10. flutter_local_notifications
    11. firebase_core
    12. image_picker
    13. email_validator
    14. url_launcher
    15. flutter_html
    16. google_maps_flutter
    17. geolocator
    18. permission_handler
    19. razorpay_flutter
    20. otp_autofill
    21. cached_network_image
    22. firebase_dynamic_links
    23. barcode_widget
    24. share_plus
    25. animated_size_and_fade
    26. app_settings
    27. shimmer
    28. flutter_webview_pro
    29. device_info_plus

    
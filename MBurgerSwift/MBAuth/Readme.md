# MBAuth

All the authentication apis are contained in `MBAuth`. You can register a user to MBurger, authenticate that user, and retrieve its informations.

# Register a user

To register a user you call `MBAuth.registerUser(withName:...)`. The fields, `name`, `surname`, `email` and `password` are required, others are optional. The field `data` is a dictionary representing additional data that you want to pass when registering the user. It will be returned when retrieving the profile.

```swift
MBAuth.registerUser(withName: "name",
                    surname: "surname",
                    email: "email",
                    password: "password",
                    phone: "1234567890",
                    image: nil,
                    data: nil, success: {
}, failure: { (error) in
            
})
```

# Authenticate a user

### Email and password
After registeering the user you can authenticate it with its email and password. All the communication with the server are made in https so all the data are encrypted. If the authentication is correct the api will return the access token. This token will be put in the `Authorization` header for all the subsequent call to all the MBurger apis.

```swift
MBAuth.authenticateUser(withEmail: "email", password: "password", success: { (accessToken) in
           
}, failure: { (error) in

})
```

### Social
`MBurger` offers the possibility to authenticate a user with social networks too.

Socials currently supported:

* Google
* Facebook

```swift
MBAuth.authenticateUser(withSocialToken: "socialToken", 
                        tokenType: Social_Token_Type, 
                        success: { (accessToken) in
}, failure: { (error) in
})
```     

### Apple ID

> @TODO: 

You can see if a user is currently authenticated with `MBAuth.userIsLoggedIn`.

If a user is authenticated you can retrieve its access token with `MBAuth.authToken` else this will return `nil`.

To logout the current user:

```swift
MBAuth.logoutCurrentUser({ 
}, failure: { (error) in
})
```

MBAuth saves the user information in a Keychain using `SAMKeychain`.
If you are having issues when authenticating a user with the message *`Couldn't add the Keychain Item.`* turn on Keychain sharing in your app capabilities section for your app and add `com.mumble.mburger`. This should fix it.

![Keychain](Images/Keychain.png)

# Retrieve user informations

You can retrieve the informations of the current user with `MBAuth.getUserProfile`. In case of success it returns a `MBUser` as a parameter of the success block.

```swift
MBAuth.getUserProfile(success: { (user) in
            
}, failure: { (error) in
            
})
```

# Update user profile

You can update some data of the profile of the current `MBUser`. In case of success it returns an updated `MBUser` as a parameter of the success block.


```swift
MBAuth.updateProfile(withName: "name", 
                     surname: "surname", 
                     phone: "1234567890", 
                     image: nil, 
                     data: nil, 
                     success: { (user) in
}, failure: { (error) in      
})
```
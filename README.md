# trending-repositories

An iOS app to get the most recent repositories

## Architectural considerations

The general architecture of the app is MVP. 

There is a hierarchy of coordinators that hold the state of the app. Every time the state gets updated, the view controllers get notified. 

The coordinators hold references to the objects that manage the persistence and the communication with the server. As they work as mediators between the UI layer and the persistence layer.

The persistence layer is built using a combination of URLSession and Core Data. All data retrieved from the server is stored in an Sqlite database, that way the app can still be used offline.

The images downloaded from the internet are cached in memory with NSCache, so they don't need to be downloaded every time.

## Technical choices

The whole app was build using first party libraries or frameworks. This decision was made not only as a proof of knowledge, but also for maintenance reasons. So any person that knows iOS development, also knows how to continue extending this app. No requirement to learn an external tool.  

## Future improvements

There is plenty of room for improvements in this project. For example, the pagination of the list of repositories is managed by the `RepositoriesListCoordinator`. This functionality, could be abstracted into a protocol.

The classes in the data layer could make use of generics, that way they could work with other types. At the moment is only uses `Repository` since this is the only object that was retrieved from the server.

The string literals in the code could be extracted into a separate structure. Having string literals centralized, reduces the room for error when localizing the app.



import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
//    -----------------------------------------------------------------------------------
//    This piece of code has been added after the deployment of the app. Since we get a dynamic Database URL from Heroku
//    it is fundamental to don't hard code each database access parameter. This is why the following urlString and postgresConfig
//    variable are structured in order to get the information regarding the database. Remember that this app is running on your cloud!
//    -----------------------------------------------------------------------------------
    if let urlString = Environment.get("DATABASE_URL"),
       var postgresConfig = PostgresConfiguration(url: urlString){
        
        var tlsConfig = TLSConfiguration.makeClientConfiguration()
        tlsConfig.certificateVerification = .none
        postgresConfig.tlsConfiguration = tlsConfig
        app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
    }
//    -----------------------------------------------------------------------------------
    else{
    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ), as: .psql)
    }
    
    app.migrations.add(CreateSongs())
//    -----------------------------------------------------------------------------------
//    This condition verifies if we are in a development enviroment. Practically if we are running our server app on a local host
//    for testing purposes.
    if app.environment == .development{
    try app.autoMigrate().wait()
        
    }
    // register routes
    try routes(app)
}

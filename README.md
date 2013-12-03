Driveline
=========

Copyright (c) Simon Kaluza

Prerequisites
------------------
1.	Java build automation and dependency resolution scripting tool “Maven 3” or higher installed on the environment’s path (for Driveline Server only).
2.	MySQL installed and correctly configured on the Driveline server’s machine.
3.	XCode 5 or greater installed (for Driveline iOS Client only).

Generating the MySQL Database
---------------------------------------------
1.	Check out the server source code from the GitHub source control repository using the command “git clone https://github.com/SimonKaluza/driveline.git”
2.	  Use MySQL command-line tools to import the DDL/DML script “create-driveline-database-mysql.sql” saved in the “driveline-database” folder to a new schema titled “driveline”.

Compiling and Running the Driveline JAX-RS Server
-----------------------------------------------------------------------

1.	Check out the server source code from the GitHub source control repository using the command “git clone https://github.com/SimonKaluza/driveline.git” (if not yet completed in the prior step).
2.	Run the maven goal “jetty:run” in the “driveline-server-jaxrs” project folder with the command “mvn jetty:run”.  This will start the lightweight, embeddable Java Jetty Servlet container.  Maven will also attempt to download and install all the necessary Java library dependencies such as Jetty, JAX-RS, the JDBC MySQL connector and many others from the central repository.
3.	(optional) By replacing the host and port numbers in the customized Maven “pom.xml”, one can also run the “mvn antrun:run” to trigger an autodeployment script if one has already configured a production server for final deployment. 

Compiling and Running the iOS Mobile Client
--------------------------------------------------------------
1.	Check out the iOS client source code from the GitHub source control repository using the command “git clone https://github.com/SimonKaluza/driveline.git”
2.	Open the “driveline-ios.xcworkspace” file in Xcode and run the “Driveline” scheme after selecting either the iOS Simulator or a particular device.  One can also run the unit tests in the DrivelineRestClient static library project which uses the Swagger Codegen library to autogenerate classes from the JAX-RS server to verify that all is functioning correctly.

Simon Kaluza
December 2013
UNH Master's Project for Computer Science -- Driveline

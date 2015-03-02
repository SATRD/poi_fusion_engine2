Fusion Engine
==============

This documentation provides information on how to setup one instance of the Fusion Engine (FE) service. Once setup and executed an OCD (Open City Database) will be available in a database. The service focuses more on the fusion (merging of POIS) than the access, however there is a complementary service able to expose a REST JSON API to access (read access) the OCD. For the moment the FE does not provide means to input user generated content (UCG), though it may be possible. 
The FE provides a selected list of POIs (Points of Interests) from a certain city.
Currently the FE only supports CitySDK (http://www.citysdk.eu/developers/) interfaces for accessing data sources and providing data access.
However some integration has been done to import FE POI data from the OCDB SE (https://github.com/fraunhoferfokus/OCDB), and some work is expected to be done to integrate with enablers in the FIWARE project. 

The development carried out in this project has been carried out within the FICONTENT2 project (http://mediafi.org/)
The first version can be found at https://github.com/satrd/poi_fusion_engine. Most of the Java classes have been rewritten for better support and entensibility.


Installation
------------
This installation guide is described for Ubuntu 14.10. For other versions or operating systems, please take care of the corresponding differences.

Required software components for a successful installation and operation:  

* JDK v.1.7.x or higher (the FE is developed in Java. You can use either OpenJDK or the official JDK provided by Oracle)
```
$ sudo apt-get install openjdk-8-jdk
```

* POSTGIS 2.1.2 or higher with POSTGRESQL 9.1 or higher (there is also Oracle support in FE v1.0, but has not been entirely tested in v2.0)
```
$ sudo apt-get install postgis
```
If required, remember to grant user access at /etc/postgresql/9.X/main/pg_hba.conf


* Tomcat v6.0 or higher (if you plan to deploy the complementary service to expose the data in the OCD). Recommended for testing purposes
```
$ sudo apt-get install tomcat8
```
Remember to assign a manager user in  /var/lib/tomcatX/conf/tomcat-users.xml 


* Apache Ant 1.9.3 or higher (to execute the FE). Make sure ANT is in your PATH if you install it on Windows
```
$ sudo apt-get install ant
```


Optional compoments (for developers)

* pgAdminIII (this will help you accessing the POSTGIS database)
```
$ sudo apt-get install pgadmin3
```

* Eclipse Luna (with this Java IDE developers may change the code to adapt it you their application needs) 
Download the latest version (Eclipse Luna EE) at www.eclipse.org


* git (if you want to download easily the code)
```
$ sudo apt-get install git
```

Execute the following steps to install a OCDB instance on your machine / server.

1) Download the code from this site. You can click on 'Download ZIP' or just open a console in your desired folder and type

```
$ git clone https://github.com/fraunhoferfokus/ocdb
```
Developers can also download the code with Eclipse (see http://wiki.eclipse.org/EGit/User_Guide#Starting_from_existing_Git_Repositories for more info) or import it later from Eclipse



Configuration
-------------

This is probably the most difficult part, as there are various things you need to pay attention to the flow.

1) Create a new database in POSTGIS (e.g. through pgAdminIII) 
Be sure that the new database has POSTGIS support. Once created in pgAdminIII, connect via SQL and execute the following query:
CREATE EXTENSION postgis;

2) Open the file in conf/config.xml
Edit the credentials to connect to your database (database name, user, password) in the DB element. You can skip the other parameters as they are not being used yet.

3) Open the build.xml
Here you can see (<target name="run"..</target>) that the main class is org.upv.satrd.main.FE_sample_valencia. There is also a sample for Tenerife you might use, but we will take the Valencia example. Later on, you can build your own OCD.

4) Open the main class (FE_sample_Valencia) . Here you can see
	a) The config.xml is being loaded at first
	b) Several lines below there is another configuration file, called FusionRules_Valencia.xml under the 'conf' directory.

5) Open the fusion file. This file describes how the fusion will be performed. 
	a) Each 'fusion_rule' element corresponds to a category. It includes:
		a.1) General settings
			a.1.1) location: indicates the location (by priority) to be considered when locating the merging POI 
			a.1.2) name: indicates the name (by priority) to be considered when naming the merging POI 
			a.1.3) description: indicates the description (by priority) to be considered when describing the merging POI
			a.1.4) image: indicates whether this POI will include images to be search in different sources (element 'source')
		a.2) Specific settings 
			a.2.1) max_distance: represents the maximum distance to consider that two nearby POIs can represent the same POI
			a.2.2) similarity_percentage: similarity threshold in the name strings to consider that two nearby POIs can represent the same POI
   
	b) The element <source> represents data sources. Currently there are 3 data sources added by default: DBPedia, OSM and POIProxy. For each data source, there is a properties file that maps one category from our POI domain into one or more categories in its corresponding domain. You may find under the conf directory three properties files:
		b.1) dbpedia.properties (here one category maps to one category)
		b.2) osm.properties (here one category 'shop' maps to many categories in OSM)
		b.3) poiproxy_local_valencia and poiproxy_local_tenerife. As POIProxy provides local data, you need to have one properties file (poiproxy_local_X) per each city. the name of the city is given in the fusion rules file


Running
-------

Running is as easy as executing ant on the build.xml
You can either run it from a console:

```
$ cd poi_fusion_engine2
$ ant 
```
or you can do it from your Eclipse IDE (Right click on build.xml --> Run As --> Ant Build)

Depending on the number of data sources, this can take a little while. As you can imagine, this depends on the number of inputs inserted in the FusionRules.xml file.
For the Tenerife OCD it took around 5 min in an i3-4GB RAM computer, whereas for the Valencia OCD it took around 11 min. Note also that sometimes (many times) is not the fusion algorithm but it may be a network issue accessing DBPedia or OSM data.





Testing
-------

Open the manager panel of your Tomcat installation at http://localhost:8080/manager/html
Deploy the WAR archive in the services directory (fic2_fe_inquiry_valencia)

Open a new tab and browse through http://localhost:8080/fic2_fe_inquiry_valencia/citysdk/test/index
You will find here two demos:
- Demo1 shows lets you display on a georeferenced map the different categories you have in your OCD built by the FE
Just select one category and click the 'Show' button. On the right frame you can see the POIs. By clickingon one of them, you can see some properties of the POI 

- Demo2 shows you the JSON format of an inquiry request
Here you can select among three different requst to see the Query and the response

Note: The WAR file includes sources just in case you want to adapt it to your needs

General remarks
----------------
- As you may have noted, there is no place where we have inserted the way to access the different data sources. Currently it is partially hardcoded, but you can easily insert it from another configuration file. The class org.upv.satrd.main.OutputDB includes in its funtion initDBFromXML() three data sources (OSM, DBPEdia and POIProxy).

- Note also that the data sources endpoints provide JSON data in CitySDK format. Other sources will require an additional connector to be developed

- One of the goals of this service i to provide a web interface to easily generate a fusion rules XML file as well as a data sources configuration files. However, as this is a backend service for developers, it is not a priority currently. 



Problems
--------

Please use the issue tracker to report any problems you might encounter.


License
-------
Copyright 2014 SATRD-Universitat Politecnica de Valencia

```
/*******************************************************************************
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Copyright 2014 SATRD-Universitat Politecnica de Valencia
 *******************************************************************************/
```

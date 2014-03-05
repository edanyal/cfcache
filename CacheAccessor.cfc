<!---
Author: Edmund Danyal (edmunddanyal@gmail.com)

CacheAccessor Component
	This object is responsible for managing the cache and data accesses in the system.
	It must perform the correct locks based on table name which maps to a cache branch.
	
Requirements
	["dataAccessor"]		- The object for the cache to use to access the underlying database
	["cache"]			- The cache that this object will utilize for storage
	["cacheEntryFactory"]	- The cacheEntryFactory is responsible for creating cacheEntries
	["cacheCollector"]	- The cache collector is responsible for keeping the cache clean
	
Versions
	v0.1 -	init(), read()
	v0.2 - 	Incorporated collection strategy via cacheEntries and a cacheCollector
	v0.3 -	write(), update()
--->
<cfcomponent 
	displayname="CacheAccessor"
	output="false"
	hint="Facade between the application and dataaccess and the cache.">
	
	<!--- Properties --->
	<cfset variables.dataAccessor = "" /><!--- DataAccessor to use to populate the cache --->
	<cfset variables.cache = "" /> <!--- The cache to use --->
	<cfset variables.cacheEntryFactory = "" /> <!--- The factory for cache entries --->
	<cfset variables.cacheCollector = "" /> <!--- The CacheCollector to clean the cache --->
	<cfset variables.instanceName = "" /> <!--- UUID Generated to optimize locking and waiting --->
	<!---
	  	Author: Edmund Danyal (edmunddanyal@gmail.com)
	  	Function: init
	  		Initializes the object.  This function is like a constructor and is required to use the object
	  	Params:
	  		"dataAccessor" - The object to perform datareads and writes
	  		"cache" - The cache this object manages
	  		"cacheCollector" - The cache collector which cleans the cache
	  		"cacheEntryFactory" - Determines the type of cache entries.
	 --->
	<cffunction name="init" access="public" output="false" returntype="cache.CacheAccessor">
		<cfargument name="dataAccessor" type="cache.DataAccessor" required="true" />
		<cfargument name="cache" type="cache.Cache" required="true" />
		<cfargument name="cacheEntryFactory" type="cache.CacheEntryFactory" required="true" />
		<cfargument name="cacheCollector" type="cache.CacheCollector" required="true" />
		
		<cfset variables.instanceName = CreateUUID() />
		
		<cfset variables.dataAccessor = arguments.dataAccessor />
		<cfset variables.cache = arguments.cache />
		<cfset variables.cacheEntryFactory = arguments.cacheEntryFactory />
		<cfset variables.cacheCollector = arguments.cacheCollector />
		
		<cfset variables.cacheEntryFactory.setInstanceName( variables.instanceName ) />
		<cfset variables.cacheCollector.setInstanceName( variables.instanceName ) />
			
		<cfreturn this />
	</cffunction>
	
	<cffunction name="getInstanceName" access="public" output="false" returntype="string">
		<cfreturn variables.instanceName />
	</cffunction>
	
	<!---
	  	Author: Edmund Danyal (edmunddanyal@gmail.com)
	  	Function: read
	  		Attempts a read from the cache.  If the memory is not there, it will do a read from a concrete
	  		dataaccessor, store that object in the cache, then return the value.
	  	Params:
	  		"key" - The key for the read attempt within the relative branch of the cache
	 --->
	 <cffunction name="read" access="public" output="false" returntype="any">
	 	<cfargument name="key" type="string" required="true" />
	 	
	 	<cfset var requestValue = "" />
	 	<cfset var cacheEntry = "" />
	 	
	 	<cflock name="cache_#variables.instanceName#" timeout="5">
		 	<cftry>
			 	<cfset cacheEntry = variables.cache.get( arguments.key ) />
			 	<cfreturn cacheEntry.getData() />
			 <cfcatch type="CACHE_KEY_NOT_FOUND">
		 		<cfset requestValue = variables.dataAccessor.read( arguments.key ) />
		 		<cfset cacheEntry = variables.cacheEntryFactory.newCacheEntry(arguments.key, requestValue) />
		 		
		 		<cfset variables.cache.put( arguments.key, cacheEntry ) />
		 	</cfcatch>
		 	</cftry>
		 	<cfreturn requestValue />
	 	</cflock>
	 </cffunction>
	 
	 <!---
	  	Author: Edmund Danyal (edmunddanyal@gmail.com)
	  	Function: write
	  		Writes data to the cache and to the database
	 --->
	 <cffunction name="write" access="public" output="false" returntype="any">
	 	<cfargument name="data" type="any" required="true" />
		
		<cfset var insertedObject = variables.dataAccessor.create( arguments.data ) />
		<cfset var key = insertedObject.getKey() />
		<cfset var cacheEntry = variables.cacheEntryFactory.newCacheEntry( key , arguments.data ) />
		
		<cflock name="cache_#variables.instanceName#" timeout="5">
			<cfset variables.cache.put( key, cacheEntry ) />
		</cflock>
		<cfreturn this.read(key) />
	</cffunction>
	
	<!---
	  	Author: Edmund Danyal (edmunddanyal@gmail.com)
	  	Function: update
	  		Updates data in the cache and database
	 --->
	<cffunction name="update" access="public" output="false" returntype="void">
		<cfargument name="key" type="string" required="true" />
		<cfargument name="data" type="any" required="true" />
		
		<cfset var cacheEntry = variables.cacheEntryFactory.newCacheEntry( arguments.key , arguments.data ) />
		
		<cflock name="cache_#variables.instanceName#" timeout="5">
			<cftry>
				<cfset variables.dataAccessor.update( data ) />
				<cfset variables.cache.put( key, cacheEntry ) />
			<cfcatch type="any">
			 	<cfrethrow />
			</cfcatch>
			</cftry>
		</cflock>
	</cffunction>
</cfcomponent>

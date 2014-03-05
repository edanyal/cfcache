<!---
Author: Edmund Danyal (edmunddanyal@gmail.com)

Cache Component
	-This object is responsible for physical cache access.
	
Versions
	v0.1 - 	get(), put(), remove(), clear()
	v0.2 - 	Abstracted locking to the CacheAssesor.
	v0.3 -	Cache no longer worries about duplicating objects
--->
<cfcomponent 
	displayname="Cache"
	output="false"
	hint="Responsible for physical cache reads and writes">
	
	<!--- Central Cache Object --->
	<cfset variables.cache = StructNew() />
	
	<!---
	  	Author: Edmund Danyal (edmunddanyal@gmail.com)
	  	Function: put
	  		Adds a value to the cache. This function will add a value to cache if the key is new and
	  		overwrite a value if the key is already in the cache.
	  	Params:
	  		"key" - Mapping key to the value
	  		"value" - The value to save in cache
	 --->
	<cffunction name="put" access="public" output="false" returntype="void">
		<cfargument name="key" type="string" required="true" />
		<cfargument name="value" type="any" required="true" />
		
		<cfset StructInsert(variables.cache, arguments.key, arguments.value, "yes") />
	</cffunction>
	
	<!---
	  	Author: Edmund Danyal (edmunddanyal@gmail.com)
	  	Function: get
	  		Gets a value out of the cache.  Function will throw the CACHE_KEY_NOT_FOUND exception if the
	  		key wasn't in the cache.
	  	Params:
	  		"key" - Mapping key to the value
	 --->
	<cffunction name="get" access="public" output="false" returntype="any">
		<cfargument name="key" type="string" required="true" />

		<cfif StructKeyExists(variables.cache, arguments.key)>
			<cfreturn variables.cache[arguments.key] />
		</cfif>
		<cfthrow type="CACHE_KEY_NOT_FOUND" />
	</cffunction>
	
	<!---
	  	Author: Edmund Danyal (edmunddanyal@gmail.com)
	  	Function: remove
	  		Removes a value from the cache.  Blind deletion is done for performance purposes.
	  	Params:
	  		"key" - Mapping key to the value
	 --->
	<cffunction name="remove" access="public" output="false" returntype="void">
		<cfargument name="key" type="string" required="true" />
		
		<cfset StructDelete(variables.cache, arguments.key) />
	</cffunction>
	
	<!---
	  	Author: Edmund Danyal (edmunddanyal@gmail.com)
	  	Function: clear
	  		Clears the cache.  Global locking is needed in cache assesor whenever code wants to execute this.
	  	Requirements:
	  		Global Cache Locking
	 --->
	<cffunction name="clear" access="public" output="false" returntype="void">
		<cfset StructClear(variables.cache) />
	</cffunction>
	
</cfcomponent>
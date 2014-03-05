<!---
Author: Edmund Danyal (edmunddanyal@gmail.com)

CacheCollector Component
	-This object is an interface for CacheCollector objects
	
Versions
	v0.1 - 	collect()
--->
<cfcomponent 
	displayname="CacheCollector"
	output="false"
	hint="CacheCollector Interface">
	
	<cffunction name="collect" access="public" returntype="void">
		<!--- PURE VIRTUAL: MUST OVERRIDE --->
	</cffunction>
	
	<cffunction name="setInstanceName" access="public" returntype="void">
		<cfargument name="instanceName" type="string" required="true" />
		<!--- PURE VIRTUAL: MUST OVERRIDE --->
	</cffunction>
	
</cfcomponent>
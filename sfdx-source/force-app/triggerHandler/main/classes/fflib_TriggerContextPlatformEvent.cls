/**
 * File Name: fflib_TriggerPlatformEventContext 
 * Description: 
 * Copyright (c) 2020 Johnson & Johnson
 * @author: architect ir. Wilhelmus G.J. Velzeboer | wvelzebo@its.jnj.com 
 */
public virtual with sharing class fflib_TriggerContextPlatformEvent implements fflib_TriggerContext
{
	protected Schema.SObjectType sObjectType;
	protected fflib_DomainFactory domainFactory;

	/**
	 * Class constructor
	 */
	public fflib_TriggerContextPlatformEvent(Schema.SObjectType sObjectType)
	{
		this.sObjectType = sObjectType;
	}

	public SObjectType getSObjectType()
	{
		return this.sObjectType;
	}

	public void setDomainFactory(fflib_DomainFactory domainFactory)
	{
		this.domainFactory = domainFactory;
	}
}
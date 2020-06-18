/**
 * File Name: fflib_TriggerHandler
 * Description: 
 * Copyright (c) 2020 Johnson & Johnson
 * @author: architect ir. Wilhelmus G.J. Velzeboer | wvelzebo@its.jnj.com 
 */
public interface fflib_TriggerHandler
{
	void handle(Schema.SObjectType sObjectType);
	void handle(fflib_TriggerContext ctx);
	void replaceWith(Schema.SObjectType sObjectType, Type triggerActionInterfaceType, Object triggerActionImpl);
}
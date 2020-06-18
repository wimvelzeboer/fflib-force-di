/**
 * File Name: fflib_TriggerSObjectContextTest 
 * Description: 
 * Copyright (c) 2020 Johnson & Johnson
 * @author: architect ir. Wilhelmus G.J. Velzeboer | wvelzebo@its.jnj.com 
 */
@IsTest
private with sharing class fflib_TriggerSObjectContextTest
{

	@IsTest
	static void itShouldCallTheTrigger()
	{
		// GIVEN a trigger handler

		// WHEN - we invoke the trigger
		new TestApplication().TriggerHandler.handle(
				new fflib_TriggerContextSObject(Schema.Account.SObjectType)
		);


		// THEN

	}


	private class TestApplication
	{
		private final String APP_NAME = 'TEST';

		// Configure and create the SelectorFactory for this Application
		public final fflib_SelectorFactory Selector = new fflib_SelectorFactoryImp(APP_NAME);

		// Configure and create the DomainFactory for this Application
		public final fflib_DomainFactory Domain =
				new fflib_DomainFactoryImp(APP_NAME, Selector);

		public final fflib_TriggerHandler TriggerHandler =
				new fflib_TriggerHandlerImp(APP_NAME, Domain);
	}


	private class AccountTriggerHandler implements fflib_TriggerAction
	{
		public void pre(fflib_TriggerContext ctx)
		{
		}

		public void run(fflib_TriggerContext ctx)
		{
		}

		public void post(fflib_TriggerContext ctx)
		{
		}
	}
}
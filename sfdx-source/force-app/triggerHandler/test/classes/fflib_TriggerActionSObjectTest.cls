/**
 * File Name: fflib_TriggerSObjectHandlerTest 
 * Description:
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 */
@IsTest(IsParallel=true)
public with sharing class fflib_TriggerActionSObjectTest
{

/*	@IsTest
	private static void itShouldConstructTheTrigger()
	{
		// GIVEN A configured triggerhandler
		di_Injector.Org.Bindings
				.bySObject(Schema.Account.SObjectType)
				.set(
				new di_Module().bind(Schema.Account.SObjectType).to(fflib_TestTriggerSObjectHandler.class)
		);
		Application app = new Application();

		// WHEN we invoke the trigger handler
		app.TriggerHandler.handle(Schema.Account.SObjectType);

		// THEN it should have called the handler
		System.assert(fflib_TestTriggerSObjectHandler.preInvoked, 'Pre logic should be invoked on the handler');
		System.assert(fflib_TestTriggerSObjectHandler.handleInvoked, 'Handle logic should be invoked on the handler');
	}*/

	private static final String INCORRECT_AMOUNT_OF_ACTIONS_INVOKED = 'Incorrect amount of actions invoked; ';

	@IsTest
	static void itShouldThrowExceptionOnUnknownOperationType()
	{
		// GIVEN a SObject Trigger Action
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_TriggerContextSObject ctxMock =
				createCtxSObjectMockForOperationType(mocks, null);
		fflib_TriggerActionSObjectTest.TraditionalHandler triggerAction = new TraditionalHandler();

		// WHEN we invoke the PRE and RUN methods
		Boolean exceptionThrown = false;
		try
		{
			System.Test.startTest();
			triggerAction.pre(ctxMock);
			triggerAction.run(ctxMock);
			System.Test.stopTest();
		}
		catch (fflib_TriggerActionSObject.TriggerActionSObjectException e)
		{
			exceptionThrown = true;
			System.assertEquals('Unknown trigger operationType: null', e.getMessage());
		}

		// THEN an exception should have been thrown
		System.assert(exceptionThrown, 'A fflib_TriggerActionSObject.TriggerActionSObjectException should have been thrown');
	}

	@IsTest
	static void itShouldHandleBeforeInsert()
	{
		// GIVEN a SObject Trigger Action
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_TriggerContextSObject ctxMock =
				createCtxSObjectMockForOperationType(mocks, System.TriggerOperation.BEFORE_INSERT);
		fflib_TriggerActionSObjectTest.TraditionalHandler triggerAction = new TraditionalHandler();

		// WHEN we invoke the PRE and RUN methods
		System.Test.startTest();
		triggerAction.pre(ctxMock);
		triggerAction.run(ctxMock);
		System.Test.stopTest();

		// THEN all triggerActions Should Be Invoked
		System.assertEquals(2, triggerAction.invokedActions.size(), INCORRECT_AMOUNT_OF_ACTIONS_INVOKED + triggerAction.invokedActions);
		System.assert(triggerAction.invokedActions.contains('onBeforeInsert'), 'onBeforeInsert was not invoked');
		System.assert(triggerAction.invokedActions.contains('onApplyDefaults'), 'onApplyDefaults was not invoked');
	}

	@IsTest
	static void itShouldHandleAfterInsert()
	{
		// GIVEN a SObject Trigger Action
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_TriggerContextSObject ctxMock =
				createCtxSObjectMockForOperationType(mocks, System.TriggerOperation.AFTER_INSERT);
		fflib_TriggerActionSObjectTest.TraditionalHandler triggerAction = new TraditionalHandler();

		// WHEN we invoke the PRE and RUN methods
		System.Test.startTest();
		triggerAction.pre(ctxMock);
		triggerAction.run(ctxMock);
		System.Test.stopTest();

		// THEN all triggerActions Should Be Invoked
		System.assertEquals(2, triggerAction.invokedActions.size(), INCORRECT_AMOUNT_OF_ACTIONS_INVOKED + triggerAction.invokedActions);
		System.assert(triggerAction.invokedActions.contains('onValidate'), 'onValidate was not invoked');
		System.assert(triggerAction.invokedActions.contains('onAfterInsert'), 'onAfterInsert was not invoked');
	}

	@IsTest
	static void itShouldHandleAfterUpdate()
	{
		// GIVEN a SObject Trigger Action
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_TriggerContextSObject ctxMock =
				createCtxSObjectMockForOperationType(mocks, System.TriggerOperation.AFTER_UPDATE);
		fflib_TriggerActionSObjectTest.TraditionalHandler triggerAction = new TraditionalHandler();

		// WHEN we invoke the PRE and RUN methods
		System.Test.startTest();
		triggerAction.pre(ctxMock);
		triggerAction.run(ctxMock);
		System.Test.stopTest();

		// THEN all triggerActions Should Be Invoked
		System.assertEquals(2, triggerAction.invokedActions.size(), INCORRECT_AMOUNT_OF_ACTIONS_INVOKED + triggerAction.invokedActions);
		System.assert(triggerAction.invokedActions.contains('onValidate'), 'onValidate was not invoked');
		System.assert(triggerAction.invokedActions.contains('onAfterUpdate'), 'onAfterUpdate was not invoked');
	}

	@IsTest
	static void itShouldHandleAfterDelete()
	{
		// GIVEN a SObject Trigger Action
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_TriggerContextSObject ctxMock =
				createCtxSObjectMockForOperationType(mocks, System.TriggerOperation.AFTER_DELETE);
		fflib_TriggerActionSObjectTest.TraditionalHandler triggerAction = new TraditionalHandler();

		// WHEN we invoke the PRE and RUN methods
		System.Test.startTest();
		triggerAction.pre(ctxMock);
		triggerAction.run(ctxMock);
		System.Test.stopTest();

		// THEN all triggerActions Should Be Invoked
		System.assertEquals(1, triggerAction.invokedActions.size(), INCORRECT_AMOUNT_OF_ACTIONS_INVOKED + triggerAction.invokedActions);
		System.assert(triggerAction.invokedActions.contains('onAfterDelete'), 'onAfterDelete was not invoked');
	}

	@IsTest
	static void itShouldHandleAfterUnDelete()
	{
		// GIVEN a SObject Trigger Action
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_TriggerContextSObject ctxMock =
				createCtxSObjectMockForOperationType(mocks, System.TriggerOperation.AFTER_UNDELETE);
		fflib_TriggerActionSObjectTest.TraditionalHandler triggerAction = new TraditionalHandler();

		// WHEN we invoke the PRE and RUN methods
		System.Test.startTest();
		triggerAction.pre(ctxMock);
		triggerAction.run(ctxMock);
		System.Test.stopTest();

		// THEN all triggerActions Should Be Invoked
		System.assertEquals(1, triggerAction.invokedActions.size(), INCORRECT_AMOUNT_OF_ACTIONS_INVOKED + triggerAction.invokedActions);
		System.assert(triggerAction.invokedActions.contains('onAfterUnDelete'), 'onAfterUnDelete was not invoked');
	}

	@IsTest
	static void itShouldHandleBeforeUpdate()
	{
		// GIVEN a SObject Trigger Action
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_TriggerContextSObject ctxMock =
				createCtxSObjectMockForOperationType(mocks, System.TriggerOperation.BEFORE_UPDATE);
		fflib_TriggerActionSObjectTest.TraditionalHandler triggerAction = new TraditionalHandler();

		// WHEN we invoke the PRE and RUN methods
		System.Test.startTest();
		triggerAction.pre(ctxMock);
		triggerAction.run(ctxMock);
		System.Test.stopTest();

		// THEN all triggerActions Should Be Invoked
		System.assertEquals(1, triggerAction.invokedActions.size(), INCORRECT_AMOUNT_OF_ACTIONS_INVOKED + triggerAction.invokedActions);
		System.assert(triggerAction.invokedActions.contains('onBeforeUpdate'), 'onBeforeUpdate was not invoked');
	}

	@IsTest
	static void itShouldHandleBeforeDelete()
	{
		// GIVEN a SObject Trigger Action
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_TriggerContextSObject ctxMock =
				createCtxSObjectMockForOperationType(mocks, System.TriggerOperation.BEFORE_DELETE);
		fflib_TriggerActionSObjectTest.TraditionalHandler triggerAction = new TraditionalHandler();

		// WHEN we invoke the PRE and RUN methods
		System.Test.startTest();
		triggerAction.pre(ctxMock);
		triggerAction.run(ctxMock);
		System.Test.stopTest();

		// THEN all triggerActions Should Be Invoked
		System.assertEquals(1, triggerAction.invokedActions.size(), INCORRECT_AMOUNT_OF_ACTIONS_INVOKED + triggerAction.invokedActions);
		System.assert(triggerAction.invokedActions.contains('onBeforeDelete'), 'onBeforeDelete was not invoked');
	}

	private static fflib_TriggerContextSObject createCtxSObjectMockForOperationType(
			fflib_ApexMocks mocks,
			System.TriggerOperation operationType)
	{
		fflib_TriggerContextSObject ctxMock =
				(fflib_TriggerContextSObject) mocks.mock(fflib_TriggerContextSObject.class);
		mocks.startStubbing();
		mocks.when(ctxMock.getOperationType()).thenReturn(operationType);
		mocks.stopStubbing();
		return ctxMock;
	}

	private class TraditionalHandler extends fflib_TriggerActionSObject
	{
		public Set<String> invokedActions = new Set<String>();
		public override void onApplyDefaults(fflib_TriggerContextSObject ctx){ invokedActions.add('onApplyDefaults'); }
		public override void onValidate(fflib_TriggerContextSObject ctx){ invokedActions.add('onValidate'); }
		public override void onBeforeInsert(fflib_TriggerContextSObject ctx){ invokedActions.add('onBeforeInsert'); }
		public override void onBeforeUpdate(fflib_TriggerContextSObject ctx){ invokedActions.add('onBeforeUpdate'); }
		public override void onBeforeDelete(fflib_TriggerContextSObject ctx){ invokedActions.add('onBeforeDelete'); }
		public override void onAfterInsert(fflib_TriggerContextSObject ctx){ invokedActions.add('onAfterInsert'); }
		public override void onAfterUpdate(fflib_TriggerContextSObject ctx){ invokedActions.add('onAfterUpdate'); }
		public override void onAfterDelete(fflib_TriggerContextSObject ctx){ invokedActions.add('onAfterDelete'); }
		public override void onAfterUnDelete(fflib_TriggerContextSObject ctx){ invokedActions.add('onAfterUnDelete'); }
	}
	/*

	private class Application
	{
		private final String APP_NAME = 'TEST';

		// Configure and create the SelectorFactory for this Application
		public final fflib_SelectorFactory Selector = new fflib_SelectorFactoryImp(APP_NAME);

		// Configure and create the DomainFactory for this Application
		public final fflib_DomainFactory Domain =
				new fflib_DomainFactoryImp(APP_NAME, Selector);

		public final fflib_TriggerHandler TriggerHandler =
				new fflib_TriggerHandlerImp(APP_NAME, Domain);
	}*/
}
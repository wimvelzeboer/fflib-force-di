/**
 * File Name: fflib_TriggerContextSObjectTest 
 * Description: Unit test class for fflib_TriggerContextSObject
 * @author: architect ir. Wilhelmus G.J. Velzeboer
 */
@IsTest
private class fflib_TriggerContextSObjectTest
{
	@IsTest
	static void itShouldReturnDomainWithTheRecords()
	{
		// GIVEN a trigger context with records
		fflib_TriggerContextSObject ctx = new fflib_TriggerContextSObject(Account.SObjectType);
		List<Account> records = new List<Account>
		{
				new Account( Id = fflib_IDGenerator.generate(Account.SObjectType)),
				new Account( Id = fflib_IDGenerator.generate(Account.SObjectType))
		};
		ctx.records = records;
		ctx.setDomainFactory(getDomainFactoryMock(records));

		// WHEN we get a domain from the trigger context
		System.Test.startTest();
		fflib_ISObjectDomain domain = ctx.getDomain();
		System.Test.stopTest();

		// THEN the domain should contain the records;
		System.assertEquals(2, domain.getRecords().size());
		System.assert(records.equals(domain.getRecords()));
	}


	@IsTest
	private static void itShouldGetRecordWithChangedFieldsAsStrings()
	{
		// GIVEN a trigger context with two changed records,
		// one with changed Account.Name and the other with changed Account.Site
		Account accountA = new Account(
					Id = fflib_IDGenerator.generate(Account.SObjectType),
					Name = 'Account A',
					AccountNumber = '12345',
					Site = 'A'),
				accountB = new Account (
					Id = fflib_IDGenerator.generate(Account.SObjectType),
					Name = 'Account B',
					AccountNumber = '67890',
					Site = 'B'),
				newAccountA = accountA.clone(true),
				newAccountB = accountB.clone(true);
		newAccountA.Name = 'Account A updated';
		newAccountA.Site = 'C';

		fflib_TriggerContextSObject ctx = new fflib_TriggerContextSObject(Account.SObjectType);
		ctx.existingRecords = new Map<Id, SObject>(new List<Account>{ accountA, accountB });
		ctx.records = new List<Account>{ newAccountA, newAccountB };
		ctx.setDomainFactory(getDomainFactoryMock(new List<Account>{ newAccountA }));

		// WHEN we want to get the records with a change to the Account.Name field
		System.Test.startTest();
		fflib_ISObjectDomain domain = ctx.getChangedRecords(new Set<String> {'Name'});
		System.Test.stopTest();

		// THEN it should return one record
		System.assertEquals(1, domain.getRecords().size());
	}


	@IsTest
	private static void itShouldGetRecordWithChangedFieldsAsSObjectField()
	{
		// GIVEN a trigger context with two changed records,
		// one with changed Account.Name and the other with changed Account.Site
		Account accountA = new Account(
					Id = fflib_IDGenerator.generate(Account.SObjectType),
					Name = 'Account A',
					AccountNumber = '12345',
					Site = 'A'),
				accountB = new Account (
					Id = fflib_IDGenerator.generate(Account.SObjectType),
					Name = 'Account B',
					AccountNumber = '67890',
					Site = 'B'),
				newAccountA = accountA.clone(true),
				newAccountB = accountB.clone(true);
		newAccountA.Name = 'Account A updated';
		newAccountA.Site = 'C';

		fflib_TriggerContextSObject ctx = new fflib_TriggerContextSObject(Account.SObjectType);
		ctx.existingRecords = new Map<Id, SObject>(new List<Account>{ accountA, accountB });
		ctx.records = new List<Account>{ newAccountA, newAccountB };
		ctx.setDomainFactory(getDomainFactoryMock(new List<Account>{ newAccountA }));

		// WHEN we want to get the records with a change to the Account.Name field
		System.Test.startTest();
		fflib_ISObjectDomain domain = ctx.getChangedRecords(new Set<Schema.SObjectField>{ Account.Name });
		System.Test.stopTest();

		// THEN it should return one record
		System.assertEquals(1, domain.getRecords().size());
	}

	private static fflib_DomainFactory getDomainFactoryMock(List<SObject> records)
	{
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		fflib_DomainFactory result = (fflib_DomainFactory) mocks.mock(fflib_DomainFactory.class);
		mocks.startStubbing();
		mocks.when(result.newInstance(records, Account.SObjectType))
				.thenReturn(new TestAccounts(records, Account.SObjectType));
		mocks.stopStubbing();
		return result;
	}

	private class TestAccounts extends fflib_SObjectDomain
	{
		public TestAccounts(List<SObject> records, Schema.SObjectType sObjectType)
		{
			super(records, sObjectType);
		}
	}
}